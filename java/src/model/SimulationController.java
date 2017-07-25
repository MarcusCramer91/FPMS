package model;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import optimization.CPlexConnector;
import optimization.FPOptimize;
import optimization.ModelHelperMethods;
import solomon.SolomonImporter;
import util.DistanceMatrixImporter;
import util.OrdersImporter;
import util.VehiclesImporter;

public class SimulationController {

	private ArrayList<Order> orders;
	private ArrayList<Vehicle> vehicles;
	private DistanceMatrix distanceMatrix;
	private DistanceMatrix airDistanceMatrix;
	private int currentTime;
	private int nVehicles;
	
	// costs and METs
	private double overallMET = 0;
	private HashMap<Order,Double> mets = new HashMap<Order,Double>();
	private double overallCosts = 0;
	
	// CPLEX parameters
	int compTimeLimit = 600;
	boolean useInitial = true;
	boolean useUpperBound = true;
	boolean useMaxRoute = true;
	boolean useEarliestArrival = true;
	

	//private static String distanceMatrixFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\TravelTimes_30_1.csv";
	//private static String airDistanceMatrixFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\TravelTimes_30_1.csv";
	//private static String ordersFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\Orders_30_1.csv";

	private static String distanceMatrixFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv";
	private static String airDistanceMatrixFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv";
	private static String ordersFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\DummyOrders_30.csv";
	
	private static String mode = "cg";
	
	
	public SimulationController(String distanceMatrixFile, String ordersFile, int currentTime) {
		distanceMatrix = new DistanceMatrix(DistanceMatrixImporter.importCSV(distanceMatrixFile));
		orders = OrdersImporter.importCSV(ordersFile);
		this.currentTime = currentTime;
	}
	
	public SimulationController(String distanceMatrixFile, String airDistanceMatrixFile, String ordersFile, 
			int currentTime) {
		distanceMatrix = new DistanceMatrix(DistanceMatrixImporter.importCSV(distanceMatrixFile));
		airDistanceMatrix = new DistanceMatrix(DistanceMatrixImporter.importCSV(airDistanceMatrixFile));
		orders = OrdersImporter.importCSV(ordersFile);
		this.currentTime = currentTime;
		this.nVehicles = 20;
	}

	public static void main(String[] args) throws Exception {
		int currentTime = 30*60;
		SimulationController controller = new SimulationController(SimulationController.distanceMatrixFile, SimulationController.airDistanceMatrixFile,
				SimulationController.ordersFile, currentTime);

		String optimizationMode = "fp";
		
		//controller.startSimulation(optimizationMode);

		// TESTING
		//controller.testOneIterationFP(currentTime);

		boolean useInitial = false;
		boolean useUpperBound = false;
		boolean useMaxRoute = false;
		boolean useEarliestArrival = false;
		int computationTime = 3600;
		controller.testOneIterationCPlex(currentTime, computationTime, useInitial, useUpperBound, useMaxRoute, useEarliestArrival);
	}

	
	public void startSimulation(String optimizationMode) throws Exception {
		if (optimizationMode.equals("fp")) simulationFlaschenpostApproach();
		if (optimizationMode.equals("cplex")) simulationCPLEXApproach();
	}
	
	private void simulationFlaschenpostApproach() throws Exception {
		ArrayList<Order[]> routes = getRoutesFP(currentTime);
		handleMETsAndCosts(routes);
	}
	
	private void simulationCPLEXApproach() throws Exception {
		ArrayList<Order[]> routes = getRoutesCPLEX(currentTime);
		handleMETsAndCosts(routes);
	}
	
	private ArrayList<Order[]> getRoutesFP(int currentTime) throws Exception {
		boolean optimizationNecessary = FPOptimize.checkOptimizationNecessity(currentTime, orders, 30);
		System.out.println("Routing step due: " + optimizationNecessary + " in iteration " + currentTime);
		if (!optimizationNecessary) return null;
		ArrayList<Order[]> routes = FPOptimize.assignRoutes(distanceMatrix, airDistanceMatrix, orders, nVehicles, currentTime, true, false);
		
		return routes;
	}
	
	private ArrayList<Order[]> getRoutesCPLEX(int currentTime) throws Exception {
		ArrayList<ArrayList<Integer>> routes = null;
		// get Flaschenpost solution
		ArrayList<Order[]> initial = FPOptimize.assignRoutes(distanceMatrix, airDistanceMatrix, orders, nVehicles, currentTime, true, true);
		double costs = 0;
		for (Order[] route : initial) {
			costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
		}
		System.out.println("Initial FP heuristic costs: " + costs);
		System.out.println("Number of vehicles required in heuristic solution: " + initial.size());
		
		// take the number of vehicles required in the heuristic solution as an upper bound on the number of vehicles
		int nVehicles = initial.size();
		
		double[][][] initialArray = null;
		if (useInitial) {
			//  convert result to int[][][]
			initialArray = new double[distanceMatrix.getDimension()+1][distanceMatrix.getDimension()+1][vehicles.size()];
			int[] currentLocations = new int[nVehicles];
			for (int i = 0; i < currentLocations.length; i++) {
				currentLocations[i] = 0;
			}
			for (int k = 0; k < nVehicles; k++) {
				Order[] currentOrders = initial.get(k);
				int currentNode = currentOrders[0].getDistanceMatrixLink()-1;
				initialArray[0][currentNode][k] = 1;
				for (Order o : currentOrders) {
					initialArray[currentNode][o.getDistanceMatrixLink()-1][k] = 1;
					currentNode = o.getDistanceMatrixLink()-1;
				}
				initialArray[currentNode][distanceMatrix.getDimension()][k] = 1;
			}
			routes = CPlexConnector.getRoutes(distanceMatrix, orders, nVehicles, currentTime, compTimeLimit, true, 
					initialArray, costs, useMaxRoute, useEarliestArrival);
		}
		else if (useUpperBound) routes = CPlexConnector.getRoutes(distanceMatrix, orders, nVehicles, currentTime, compTimeLimit, true, 
				null, costs, useMaxRoute, useEarliestArrival);
					
		else {
			routes = CPlexConnector.getRoutes(distanceMatrix, orders, nVehicles, currentTime, compTimeLimit, true, 
					null, -1, useMaxRoute, useEarliestArrival);		
		}
		for (ArrayList<Integer> route : routes) {
			 for (Integer i : route) System.out.print(i + "\t");
			 System.out.println();
		 }
		ArrayList<Order[]> formattedRoutes = new ArrayList<Order[]>();
		for (int i = 0; i < routes.size(); i++) {
			int[] arrayRoute = new int[routes.get(i).size()];
			for (int j = 0; j < arrayRoute.length; j++) {
				arrayRoute[j] = routes.get(i).get(j);
			}
			Order[] oneRoute = ModelHelperMethods.parseTSPOutput(arrayRoute, orders);
			formattedRoutes.add(oneRoute);
		}
		return formattedRoutes;
	}
	
	private void handleMETsAndCosts(ArrayList<Order[]> routes) {
		// calculate METs for orders upon fulfillment
		double currentMETTotal = calculateMETs(routes);
		overallMET += currentMETTotal;
		System.out.println("All METs: " + Math.floor(currentMETTotal/60) + " minutes");
		for (Order key : mets.keySet()) {
		    System.out.println("MET for order number " + key.getID() + ": " + Math.floor(mets.get(key)/60) + " minutes");
		}
		// calculate costs
		double costs = calculateTimeDriving(routes);
		System.out.println("Overall costs for driving " + costs);
	}
	
	private double calculateMETs(ArrayList<Order[]> routes) {
		double currentMETTotal = 0;
		for (int i = 0; i < routes.size(); i++) {
			 double currentRouteLength = ModelConstants.DEPOT_LOADING_TIME;
			 currentRouteLength += distanceMatrix.getEntry(1, routes.get(i)[0].getDistanceMatrixLink());
			 Order[] currentOrders = routes.get(i);
			 for (int j = 0; j < currentOrders.length; j++) {
				 Order o = currentOrders[j];
				 double currentMET = o.getMET(currentTime) + currentRouteLength;
				 mets.put(o, currentMET);
				 currentMETTotal += currentMET;
				 currentRouteLength += ModelConstants.CUSTOMER_LOADING_TIME;
				 if (j < currentOrders.length-1) currentRouteLength += distanceMatrix.getEntry(o.getDistanceMatrixLink(), 
						 currentOrders[j+1].getDistanceMatrixLink());
			 }
		}
		return currentMETTotal;
	}
	
	private double calculateTimeDriving(ArrayList<Order[]> routes) {
		double costs = 0;
		for (Order[] route : routes) {
			costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
		}
		return costs;
	}

	
	
	
	
	// TESTING METHODS
	
	private void testOneIterationFP(int currentTime) throws Exception {
		
		/**
		// Crop problem to 20 customers and 3 vehicles
		distanceMatrix = distanceMatrix.getCroppedMatrix(new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21});
		airDistanceMatrix = airDistanceMatrix.getCroppedMatrix(new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21});
		for (int i = 0; i < 10; i ++) {
			orders.remove(20);
		}
		vehicles.remove(3);*/
		// +++++++++++++++++++++++++++++++++++++++++++++++++++
		
		for (Order o : orders) {
			o.setStatus(1);
		}
		if (mode.equals("fp")) {
			System.out.println("Routing step due: " + FPOptimize.checkOptimizationNecessity(currentTime, orders, 30));
			ArrayList<Order[]> routes = FPOptimize.assignRoutes(distanceMatrix, airDistanceMatrix, orders, nVehicles, currentTime, true, true);
			for (int i = 0; i < routes.size(); i++) {
				System.out.println("Route for vehicle " + i);
				System.out.print("1->");
				for (int j = 0; j < routes.get(i).length-1; j++) {
					System.out.print(routes.get(i)[j].getDistanceMatrixLink() + "->");
				}
				System.out.println(routes.get(i)[routes.get(i).length-1].getDistanceMatrixLink());
			}
			double costs = 0;
			for (Order[] route : routes) {
				costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
			}
			System.out.println("Total costs: " + costs);
		}
	}
	
	private void testOneIterationCPlex(int currentTime, int compTimeLimit, boolean useInitial,
			boolean useUpperBound, boolean useMaxRoute, boolean useEarliestArrival) throws Exception {
		
		ArrayList<ArrayList<Integer>> routes = null;
		
		// get Flaschenpost solution
		ArrayList<Order[]> initial = FPOptimize.assignRoutes(distanceMatrix, airDistanceMatrix, orders, nVehicles, currentTime, true, true);
		double costs = 0;
		for (Order[] route : initial) {
			costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
		}
		System.out.println("Initial FP heuristic costs: " + costs);
		System.out.println("Number of vehicles required in heuristic solution: " + initial.size());
		
		// take the number of vehicles required in the heuristic solution as an upper bound on the number of vehicles
		int nVehicles = initial.size();
		
		double[][][] initialArray = null;
		if (useInitial) {
			//  convert result to int[][][]
			initialArray = new double[distanceMatrix.getDimension()+1][distanceMatrix.getDimension()+1][nVehicles];
			int[] currentLocations = new int[nVehicles];
			for (int i = 0; i < currentLocations.length; i++) {
				currentLocations[i] = 0;
			}
			for (int k = 0; k < nVehicles; k++) {
				Order[] currentOrders = initial.get(k);
				int currentNode = currentOrders[0].getDistanceMatrixLink()-1;
				initialArray[0][currentNode][k] = 1;
				for (Order o : currentOrders) {
					initialArray[currentNode][o.getDistanceMatrixLink()-1][k] = 1;
					currentNode = o.getDistanceMatrixLink()-1;
				}
				initialArray[currentNode][distanceMatrix.getDimension()][k] = 1;
			}
			routes = CPlexConnector.getRoutes(distanceMatrix, orders, nVehicles, currentTime, compTimeLimit, true, 
					initialArray, costs, useMaxRoute, useEarliestArrival);
		}
		else if (useUpperBound) routes = CPlexConnector.getRoutes(distanceMatrix, orders, nVehicles, currentTime, compTimeLimit, true, 
				null, costs, useMaxRoute, useEarliestArrival);
					
		else {
			routes = CPlexConnector.getRoutes(distanceMatrix, orders, nVehicles-1, currentTime, compTimeLimit, true, 
					null, -1, useMaxRoute, useEarliestArrival);		
		}
		
		 // due to distance matrix adaptations in this case, new costs have to be calculated
		 // cplex objective costs are 10920 too high (for 4 vehicles)
		costs = 0;
		 for (ArrayList<Integer> route : routes) {
			 for (Integer i : route) System.out.print(i + "\t");
			 costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
			 System.out.println();
		 }
		 System.out.println("Total costs: " + costs);
		 System.out.println("Computation time: " + compTimeLimit);
	}
	
	/**
	private void testOneIterationCPlexExperimental(int currentTime) throws Exception {
		int compTimeLimit = 60;
		vehicles.remove(vehicles.size()-1);
		ArrayList<ArrayList<Integer>> routes = CPlexConnector2.getRoutes(distanceMatrix, orders, vehicles, currentTime, compTimeLimit, true);
		 // due to distance matrix adaptations in this case, new costs have to be calculated
		 // cplex objective costs are 10920 too high (for 4 vehicles)
		 double costs = 0;
		 for (ArrayList<Integer> route : routes) {
			 for (Integer i : route) System.out.print(i + "\t");
			 costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
			 System.out.println();
		 }
		 System.out.println("Total costs: " + costs);
		 System.out.println("Computation time: " + compTimeLimit);
	}*/
	
}
