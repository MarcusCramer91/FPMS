package model;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import optimization.ColumnGenerationStabilized;
import optimization.ColumnGenerationStabilizedOptim;
import optimization.FPOptimize;
import optimization.ModelHelperMethods;
import util.DistanceMatrixImporter;
import util.OrdersImporter;

public class DayTesterColgen {
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
		String ordersFile = rootPath + "/data/daytestcases/OrdersDay1.csv";
		
		ArrayList<Order> orders = OrdersImporter.importCSV(ordersFile);
		DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV(distanceMatrixFile));
		
		int startingTime = 0; // 9 am
		int endTime = 43200; // 9 pm
		int problemSize = 20;
		DayTesterColgen tester = new DayTesterColgen(distmat, orders);
		tester.getColgenCosts(startingTime, endTime, problemSize);
	}
	
	public DayTesterColgen(DistanceMatrix distmat, ArrayList<Order> orders) {
		this.distanceMatrix = distmat;
		this.orders = orders;
	}
	
	public void getColgenCosts(int startingTime, int endTime, int problemSize) throws Exception {
		for (int time = startingTime; time <= endTime; time += 60) {
			if (numberOfAvailableOrders(time) >= problemSize) {
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
				croppedMatrix.insertDummyDepotAsFinalNode();
				croppedMatrix.addCustomerServiceTimes(ModelConstants.CUSTOMER_LOADING_TIME);
				croppedMatrix.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
				
				/*String rootPath = new File("").getAbsolutePath();
				 rootPath = rootPath.substring(0, rootPath.length() - 5);
				 FileWriter writer = new FileWriter(rootPath + "\\results\\days\\distmat.csv", true);
				 for (int i = 0; i < croppedMatrix.getDimension(); i++) {
					 for (int j = 0; j < croppedMatrix.getDimension(); j++) {
						 writer.write(croppedMatrix.getEntry(i+1, j+1) + ",");
					 }
					 writer.write("\n");
				 }
			     writer.close();*/
				
				
				ColumnGenerationStabilizedOptim colgen = new ColumnGenerationStabilizedOptim(croppedMatrix, croppedOrders, time);
				ArrayList<ArrayList<Integer>> routes = colgen.getRoutes(croppedMatrix, 600, 600);
				ArrayList<Order[]> orderRoutes = new ArrayList<Order[]>();
				for (int i = 0; i < routes.size(); i++) {
					orderRoutes.add(ModelHelperMethods.parseColgenOutput(routes.get(i), croppedOrders));
				}
				handleMETsAndCosts(time, orderRoutes, problemSize);
			}
		}
	}
	
	private void handleMETsAndCosts(int currentTime, ArrayList<Order[]> routes, int problemSize) throws IOException {
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
	}
	
	private double[] calculateMETs(int currentTime, ArrayList<Order[]> routes) {
		double[] result = new double[3];
		double currentMETTotal = 0;
		double currentMETExceeded = 0;
		double nCustExceeded = 0;
		for (int i = 0; i < routes.size(); i++) {
			 double currentRouteLength = ModelConstants.DEPOT_LOADING_TIME;
			 currentRouteLength += distanceMatrix.getEntry(1, routes.get(i)[0].getDistanceMatrixLink());
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
				 if (j < currentOrders.length-1) currentRouteLength += distanceMatrix.getEntry(o.getDistanceMatrixLink(), 
						 currentOrders[j+1].getDistanceMatrixLink());
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
}