package day;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import model.Vehicle;
import optimization.ColumnGenerationStabilized;
import optimization.ColumnGenerationStabilizedOptim;
import optimization.PPOptimize;
import optimization.ModelHelperMethods;
import util.DistanceMatrixImporter;
import util.OrdersImporter;

public class DayTesterColgenMETGoodness {
	private ArrayList<Order> orders;
	private ArrayList<Vehicle> vehicles;
	private DistanceMatrix distanceMatrix;
	private int nVehicles = 999;
	
	// costs and METs
	private double overallMET = 0;
	private double overallMETExceeded = 0;
	private int overallNCustExceeded = 0;
	private HashMap<Order,Double> mets = new HashMap<Order,Double>();
	private double overallDrivingCosts = 0;
	private double overallEmployeeCosts = 0;
	private int currentSize = 0;

	public static void main(String[] args) throws Exception {
		
		int[] metThresholds = {72*60};
		for (int metThreshold : metThresholds) {
			String rootPath = new File("").getAbsolutePath();
			rootPath = rootPath.substring(0, rootPath.length() - 5);
			String distanceMatrixFile = rootPath + "/data/daytestcases/TravelTimesDay1.csv";
			String ordersFile = rootPath + "/data/daytestcases/OrdersDay1.csv";
			
			ArrayList<Order> orders = OrdersImporter.importCSV(ordersFile);
			DistanceMatrix distmat = new DistanceMatrix(
					 DistanceMatrixImporter.importCSV(distanceMatrixFile));
			
			int startingTime = 0; // 9 am
			int endTime = 43200; // 9 pm
			try {
				DayTesterColgenMETGoodness tester = new DayTesterColgenMETGoodness(distmat, orders);
				tester.getColgenCosts(startingTime, endTime, metThreshold);
			}
			catch(Exception e) {}
		}
	}
	
	public DayTesterColgenMETGoodness(DistanceMatrix distmat, ArrayList<Order> orders) {
		this.distanceMatrix = distmat;
		this.orders = orders;
	}
	
	public void getColgenCosts(int startingTime, int endTime, int metThreshold) throws Exception {
		for (int i = 0; i < orders.size(); i++) {
			Order o = orders.get(i);
			if (o.getTime() < startingTime) {
				orders.remove(i);
				i--;
			}
		}
		double previousAverageMET = 0*60;
		int previousNumberOfAvailableOrders = 0;
		ArrayList<Order[]> previousOrderRoutes = null;
		for (int time = startingTime; time <= endTime; time += 60) {
			int numberOfAvailableOrders = numberOfAvailableOrders(time);
			if (orders.size() > 0 && (numberOfAvailableOrders >= 70 || (time == endTime && orders.size() > 0) || 
					getOldestOrder(orders).getMET(time) >= ModelConstants.FP_TIME_WINDOW / 2)) {
				
				// if no new orders continue
				if (numberOfAvailableOrders > previousNumberOfAvailableOrders) previousNumberOfAvailableOrders = numberOfAvailableOrders;
				else continue;
			    System.out.println();
				System.out.println("########################################");
				System.out.println();
				System.out.println("Routing step due in time point " + time);
				ArrayList<Order> croppedOrders = new ArrayList<Order>();
				ArrayList<Order> backupOrders = new ArrayList<Order>();
				int removalCounter = 0;
				for (int i = 0; i < orders.size(); i++) {
					if (orders.get(i).getTime() <= time) {
						Order current = orders.get(i);
						croppedOrders.add(current);
						Order backupOrder = new Order(current.getID(), current.getTime(), current.getWeight(), current.getDistanceMatrixLink());
						backupOrders.add(backupOrder);
						orders.remove(i);
						i--;
						removalCounter++;
					}
				}
				currentSize = croppedOrders.size();
				System.out.println("Orders removed: " + removalCounter);
				DistanceMatrix croppedMatrix = new DistanceMatrix(distanceMatrix.getAllEntries());
				int[] routeIndices = new int[croppedOrders.size() + 1];
				routeIndices[0] = 1;
				for (int k = 1; k <= croppedOrders.size(); k++) {
					routeIndices[k] = croppedOrders.get(k-1).getDistanceMatrixLink();
				}
				
				croppedMatrix = croppedMatrix.getCroppedMatrix(routeIndices);
				croppedMatrix = croppedMatrix.insertDummyDepotAsFinalNode();
				
				
				ColumnGenerationStabilizedOptim colgen = new ColumnGenerationStabilizedOptim(croppedMatrix, croppedOrders, time);
				ArrayList<ArrayList<Integer>> routes = new ArrayList<ArrayList<Integer>>();
				ArrayList<Order[]> orderRoutes = PPOptimize.assignRoutes(croppedMatrix, croppedMatrix, croppedOrders, 
						nVehicles, time, false, true);
				double fpCosts = 0;
				for (Order[] orders : orderRoutes) fpCosts += ModelHelperMethods.getRouteCosts(distanceMatrix, orders);
				try {
					croppedMatrix.addCustomerServiceTimes(ModelConstants.CUSTOMER_LOADING_TIME);
					croppedMatrix.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
					routes = colgen.getRoutes(croppedMatrix, 600, 600);
					double colgenCosts = 0;
					for (ArrayList<Integer> route : routes) {
						colgenCosts += ModelHelperMethods.getRouteCostsIndexed0(croppedMatrix, route);
						colgenCosts -= ModelConstants.DEPOT_LOADING_TIME;;
						colgenCosts -= (route.size() - 2) * ModelConstants.CUSTOMER_LOADING_TIME;
					}
					// take colgen solution only if it beats the fp solution
					if (colgenCosts < fpCosts) {
						orderRoutes = new ArrayList<Order[]>();
						for (int i = 0; i < routes.size(); i++) {
							orderRoutes.add(ModelHelperMethods.parseColgenOutput(routes.get(i), croppedOrders));
						}
					}
					else System.out.println("Column generation led to no improvement. Using FP heuristic solution instead");
				}
				catch(Exception e) {
					e.printStackTrace();
					System.out.println("Column generation lead to exception. Changing to FP heuristic solution");
					for (Order[] orders : orderRoutes) {
						ArrayList<Integer> route = new ArrayList<Integer>();
						for (Order o : orders) {
							route.add(o.getDistanceMatrixLink()-1);
						}
						routes.add(route);
					}
				}
				double currentMET = calculateMETs(time, orderRoutes)[0];
				
				// if route goodness (MET) not reached and average MET was raised -> likely cost decrease if one more iteration is waited
				if (orders.size() != 0 && currentMET/croppedOrders.size() < metThreshold && previousAverageMET < currentMET/croppedOrders.size()) {
					int reinsertionCounter = 0;
					for (int i = 0; i < backupOrders.size(); i++) {
						this.orders.add(i, backupOrders.get(i));
						reinsertionCounter++;
					}
					System.out.println("Number of order reinserted: " + reinsertionCounter);
					previousAverageMET = currentMET/croppedOrders.size();
					System.out.println("Route goodness not reached. Postponing decision to next iteration");
				}
				else {
					previousAverageMET = 0;
					handleMETsAndCosts(distanceMatrix, time, orderRoutes, metThreshold);
					previousNumberOfAvailableOrders = 0;
				}
			}
		}
	}
	
	private void handleMETsAndCosts(DistanceMatrix distmat, int currentTime, ArrayList<Order[]> routes, int metThreshold) throws IOException {
		// calculate METs for orders upon fulfillment
		double[] mets = calculateMETs(currentTime, routes);
		double currentMETTotal = mets[0];
		double currentMETExceeded = mets[1];
		double nCustExceeded = mets[2];
		overallMET += currentMETTotal;
		overallMETExceeded += currentMETExceeded;
		overallNCustExceeded += nCustExceeded;
		System.out.println("All METs in seconds: " + currentMETTotal);
		System.out.println("METs exceeded in seconds: " + currentMETExceeded);
		System.out.println("Customers MET exceeded: " + nCustExceeded);
		// calculate costs
		double drivingTime = calculateTimeDriving(routes);
		double employeeTime = calculateOverallTime(routes);
		overallDrivingCosts += drivingTime * (ModelConstants.DRIVING_COSTS / 60);
		overallEmployeeCosts += employeeTime * (ModelConstants.EMPLOYEE_COSTS / 60);
		System.out.println("Overall seconds driven " + drivingTime);
		System.out.println("Overall seconds worked " + employeeTime);
		log(currentTime, routes, drivingTime, employeeTime, drivingTime * (ModelConstants.DRIVING_COSTS / 60), 
				employeeTime * (ModelConstants.EMPLOYEE_COSTS / 60), currentMETTotal, metThreshold);
		logRouteLengths(distmat, routes, currentTime);
	}
	
	private double[] calculateMETs(int currentTime, ArrayList<Order[]> routes) {
		double[] result = new double[3];
		double currentMETTotal = 0;
		double currentMETExceeded = 0;
		double nCustExceeded = 0;
		for (int i = 0; i < routes.size(); i++) {
			 double currentRouteLength = ModelConstants.DEPOT_LOADING_TIME;
			 currentRouteLength += distanceMatrix.getEntry(1, routes.get(i)[0].getActualDistanceMatrixLink());
			 Order[] currentOrders = routes.get(i);
			 for (int j = 0; j < currentOrders.length; j++) {
				 Order o = currentOrders[j];
				 double currentMET = o.getMET(currentTime) + currentRouteLength;
				 if (currentMET > ModelConstants.FP_TIME_WINDOW) {
					 currentMETExceeded += (currentMET-ModelConstants.FP_TIME_WINDOW);
					 nCustExceeded++;
				 }
				 mets.put(o, currentMET);
				 currentMETTotal += currentMET;
				 currentRouteLength += ModelConstants.CUSTOMER_LOADING_TIME;
				 if (j < currentOrders.length-1) currentRouteLength += distanceMatrix.getEntry(o.getActualDistanceMatrixLink(), 
						 currentOrders[j+1].getActualDistanceMatrixLink());
			 }
		}
		result[0] = currentMETTotal;
		result[1] = currentMETExceeded;
		result[2] = nCustExceeded;
		return result;
	}
	
	private double calculateTimeDriving(ArrayList<Order[]> routes) {
		double costs = 0;
		for (Order[] route : routes) {
			costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
		}
		return costs;
	}
	
	private double calculateOverallTime(ArrayList<Order[]> routes) {
		double costs = 0;
		for (Order[] route : routes) {
			costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
			costs += ModelConstants.CUSTOMER_LOADING_TIME * route.length;
			costs += ModelConstants.DEPOT_LOADING_TIME;
		}
		return costs;
	}
	
	private void log(int time, ArrayList<Order[]> routes, double drivingTime, double overallTime, 
			double drivingCosts, double overallCosts, double overallMETs, int metThreshold) throws IOException {
		int nCust = 0;
		for (Order[] orders : routes) nCust += orders.length;
		if (nCust != currentSize) {
			for (Order[] orders : routes) {
				for (Order o : orders) System.out.print(o.getDistanceMatrixLink() + "\t");
			}
			System.out.println();
		}
		System.out.println("Number of customers served: " + nCust);
		String rootPath = new File("").getAbsolutePath();
		rootPath = rootPath.substring(0, rootPath.length() - 5);
		FileWriter writer = new FileWriter(rootPath + "/results/days/" + metThreshold + "_routeGoodnessMET_Day1.csv", true);
		// time, number of routes, number of customers, time driven, overall time, costs driving, overall costs, overall METs
		writer.write(time + "," +  routes.size() + "," +   nCust + "," +   drivingTime + "," +  
				overallTime + "," +   drivingCosts + "," +   overallCosts + "," + overallMETs + "\n");
		writer.close();
	}
	
	private int numberOfAvailableOrders(int time) {
		int n = 0;
		for (int i = 0; i < orders.size(); i++) {
			if (orders.get(i).getTime() <= time) n++;
		}
		return n;
	}
	
	
	private static Order getOldestOrder(ArrayList<Order> orders) {
		int oldestTime = Integer.MAX_VALUE;
		Order oldestOrder = null;
		for (int i = 0; i < orders.size(); i++) {
			if (orders.get(i).getTime() < oldestTime) {
				oldestTime = orders.get(i).getTime();
				oldestOrder = orders.get(i);
			}
		}
		return oldestOrder;
	}
	
	private void logRouteLengths(DistanceMatrix distmat, ArrayList<Order[]> orderRoutes, int time) throws IOException {
		String rootPath = new File("").getAbsolutePath();
		rootPath = rootPath.substring(0, rootPath.length() - 5);
		
		FileWriter writer = new FileWriter(rootPath + "/results/days/RouteLengths.csv", true);
		writer.write(time + ",");
		for (Order[] orderRoute : orderRoutes) {
			double length = ModelHelperMethods.getRouteLengthToLastCustomer(distmat, orderRoute);
			writer.write(length + ",");
		}
		writer.write("\n");
		writer.close();
	}
}
