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

public class DayTesterColgenProblemSize {
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

	public static void main(String[] args) throws Exception {

		String rootPath = new File("").getAbsolutePath();
		rootPath = rootPath.substring(0, rootPath.length() - 5);
		String distanceMatrixFile = rootPath + "/data/daytestcases/TravelTimesDay1.csv";
		//String ordersFile = rootPath + "/data/daytestcases/OrdersDay1_uniform.csv";
		String ordersFile = rootPath + "/data/daytestcases/OrdersDay1.csv";
		
		ArrayList<Order> orders = OrdersImporter.importCSV(ordersFile);
		DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV(distanceMatrixFile));
		
		int startingTime = 0; // 9 am
		int endTime = 43200; // 9 pm
		int[] problemSizes = {80};
		for (int problemSize : problemSizes) {
			ArrayList<Order> orderCopy = new ArrayList<>(orders);
			try {
				DayTesterColgenProblemSize tester = new DayTesterColgenProblemSize(distmat, orders);
				tester.getColgenCosts(startingTime, endTime, problemSize);
			}
			catch(Exception e) {}
		}
	}
	
	public DayTesterColgenProblemSize(DistanceMatrix distmat, ArrayList<Order> orders) {
		this.distanceMatrix = distmat;
		this.orders = orders;
	}
	
	public void getColgenCosts(int startingTime, int endTime, int problemSize) throws Exception {
		for (int i = 0; i < orders.size(); i++) {
			Order o = orders.get(i);
			if (o.getTime() < startingTime) {
				orders.remove(i);
				i--;
			}
		}
		for (int time = startingTime; time <= endTime; time += 60) {
			if (orders.size() > 0 && (numberOfAvailableOrders(time) >= problemSize || (time == endTime && orders.size() > 0) || 
					getOldestOrder(orders).getMET(time) >= (ModelConstants.TIME_WINDOW / 2))) {
			    System.out.println();
				System.out.println("########################################");
				System.out.println();
				System.out.println("Routing step due in time point " + time);
				ArrayList<Order> croppedOrders = new ArrayList<Order>();
				for (int i = 0; i < orders.size(); i++) {
					if (orders.get(i).getTime() <= time) {
						croppedOrders.add(orders.get(i));
						orders.remove(i);
						i--;
					}
					else break;
				}
				DistanceMatrix croppedMatrix = new DistanceMatrix(distanceMatrix.getAllEntries());
				int[] routeIndices = new int[croppedOrders.size() + 1];
				routeIndices[0] = 1;
				for (int k = 1; k <= croppedOrders.size(); k++) {
					routeIndices[k] = croppedOrders.get(k-1).getDistanceMatrixLink();
				}
				
				croppedMatrix = croppedMatrix.getCroppedMatrix(routeIndices);
				croppedMatrix = croppedMatrix.insertDummyDepotAsFinalNode();
				//croppedMatrix.addCustomerServiceTimes(ModelConstants.CUSTOMER_LOADING_TIME);
				//croppedMatrix.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
				
				//logDistmat(croppedMatrix, time/60);
				
				
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
				handleMETsAndCosts(distanceMatrix, time, orderRoutes, problemSize);
			}
		}
	}
	
	private void handleMETsAndCosts(DistanceMatrix distmat, int currentTime, ArrayList<Order[]> routes, int problemSize) throws IOException {
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
				employeeTime * (ModelConstants.EMPLOYEE_COSTS / 60), currentMETTotal, problemSize);
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
			double drivingCosts, double overallCosts, double overallMETs, int problemSize) throws IOException {
		int nCust = 0;
		for (Order[] orders : routes) nCust += orders.length;
		System.out.println("Number of customers served: " + nCust);
		String rootPath = new File("").getAbsolutePath();
		rootPath = rootPath.substring(0, rootPath.length() - 5);
		FileWriter writer = new FileWriter(rootPath + "/results/days/"+problemSize + "_Day1.csv", true);
		// time, number of routes, number of customers, time driven, overall time, costs driving, overall costs, overall METs
		writer.write(time + "," +  routes.size() + "," +   nCust + "," +   drivingTime + "," +  
				overallTime + "," +   drivingCosts + "," +   overallCosts + "," + overallMETs + "\n");
		writer.close();
	}
	
	private int numberOfAvailableOrders(int time) {
		int n = 0;
		for (int i = 0; i < orders.size(); i++) {
			if (orders.get(i).getTime() > time) break;
			n++;
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
	
	private void logDistmat(DistanceMatrix distmat, int time) throws FileNotFoundException {
		PrintWriter writer = new PrintWriter(new File("C:\\Users\\Marcus\\Documents\\FPMS\\results\\days\\distmats\\Distmat_" + time + "_" +
						distmat.getDimension() + ".csv"));
		int counter = 0;
		StringBuilder sb = new StringBuilder();
		for (int i = 1; i <= distmat.getDimension(); i++) {
			for (int j = 1; j <= distmat.getDimension(); j++) {
				sb.append(distmat.getEntry(i, j));
				sb.append(",");
			}
			sb.append("\n");
		}
		writer.write(sb.toString());
		writer.close();
	}
	
	private void logRouteLengths(DistanceMatrix distmat, ArrayList<Order[]> orderRoutes, int time) throws IOException {
		String rootPath = new File("").getAbsolutePath();
		rootPath = rootPath.substring(0, rootPath.length() - 5);
		
		FileWriter writer = new FileWriter(rootPath + "/results/days/RouteLengths.csv", true);
		writer.write(time + ",");
		for (Order[] orderRoute : orderRoutes) {
			double length = ModelHelperMethods.getRouteLength(distmat, orderRoute);
			writer.write(length + ",");
		}
		writer.write("\n");
		writer.close();
	}
}
