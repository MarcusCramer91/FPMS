package optimization;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;

import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import model.Vehicle;
import util.CSVExporter;

public class ModelHelperMethods {
	
	/**
	 * Checks the MET adherence
	 * @param distanceMatrix
	 * @param route
	 * @param currentTime
	 * @return
	 */
	public static boolean checkTimeWindowAdherenceMET(DistanceMatrix distanceMatrix, Order[] route, int currentTime) {
		// first add depot loading time
		int timeConsumed = ModelConstants.DEPOT_LOADING_TIME;
		// then add the duration from the depot to the first customer
		timeConsumed += Math.round(distanceMatrix.getEntry(1, route[0].getDistanceMatrixLink()));
		// check for the first customer
		if (timeConsumed + route[0].getMET(currentTime) > ModelConstants.TIME_WINDOW) return false;		
		// then add all travel times and service times up to the last order
		for (int i = 1; i < route.length; i++) {
			// add service time of previous customer
			timeConsumed += ModelConstants.CUSTOMER_LOADING_TIME;
			long travelTime = Math.round(distanceMatrix.getEntry(route[i-1].getDistanceMatrixLink(), route[i].getDistanceMatrixLink()));
			timeConsumed += travelTime;
			if (timeConsumed + route[i].getMET(currentTime) > ModelConstants.TIME_WINDOW) return false;
		}
		return true;
	}
	
	/**
	 * Only checks for route length
	 * @param distanceMatrix
	 * @param route
	 * @param currentTime
	 * @return
	 */
	public static boolean checkTimeWindowAdherence(DistanceMatrix distanceMatrix, Order[] route, int currentTime) {
		// first add depot loading time
		int timeConsumed = ModelConstants.DEPOT_LOADING_TIME;
		// then add the duration from the depot to the first customer
		timeConsumed += distanceMatrix.getEntry(1, route[0].getDistanceMatrixLink());
		// then add all travel times and service times up to the last order
		for (int i = 1; i < route.length; i++) {
			// add service time of previous customer
			timeConsumed += ModelConstants.CUSTOMER_LOADING_TIME;
			long travelTime = Math.round(distanceMatrix.getEntry(route[i-1].getDistanceMatrixLink(), route[i].getDistanceMatrixLink()));
			timeConsumed += travelTime;
			if (timeConsumed > ModelConstants.TIME_WINDOW) return false;
		}
		return true;
	}
	
	public static int getNumberOfAvailableVehiclesInDepot(ArrayList<Vehicle> vehicles) {
		int number = 0;
		for (Vehicle v : vehicles) {
			if (v.isAvailable()) number++;
		}
		return number;
	}
	
	/**
	 * TSP output gives a sequence in which the nodes are names 1,2,...,N
	 * However, the orders obviously have different IDs
	 * This function maps the TSP output to the orders
	 * @param tspSequence
	 * @return
	 */
	public static Order[] parseTSPOutput(int[] tspSequence, ArrayList<Order> orders) {
		Order[] result = new Order[tspSequence.length-2];
		if (tspSequence.length != orders.size()) new Exception("TSP sequence and orders ArrayList must be of same length");
		Order[] sortedOrders = sortOrders(orders.toArray(new Order[orders.size()]));
		for (int i = 0; i < tspSequence.length-2; i++) {
			//System.out.println(i);
			result[i] = sortedOrders[tspSequence[i+1]-2];
		}
		return result;
	}
	
	public static Order[] sortOrders(Order[] orders) {
		Order[] sortedOrders = new Order[orders.length];
		for (int i = 0; i < orders.length; i++) {
			sortedOrders[i] = orders[i];
		}
		Arrays.sort(sortedOrders, new ArrayOrderComparator());
		return sortedOrders;
	}
	
	// compares two orders based on their id
	private static class ArrayOrderComparator implements Comparator<Order> {
				
		@Override
		public int compare(Order o1, Order o2) {
			if (o1.getID() < o2.getID()) return -1;
			else return 1;
		}
	}
	
	public static double getRouteCosts(DistanceMatrix distanceMatrix, Order[] route) {
		double currentDistance = distanceMatrix.getEntry(1, route[0].getDistanceMatrixLink());
		for (int i = 0; i < route.length-1; i++) {
			currentDistance += distanceMatrix.getEntry(route[i].getDistanceMatrixLink(), 
					route[i+1].getDistanceMatrixLink());
		}
		currentDistance += distanceMatrix.getEntry(route[route.length-1].getDistanceMatrixLink(), 1);
		return currentDistance;
	}
	
	public static double getRouteCosts(DistanceMatrix distanceMatrix, ArrayList<Integer> route) {
		double currentDistance = 0;
		for (int i = 0; i < route.size()-1; i++) {
			currentDistance += distanceMatrix.getEntry(route.get(i), route.get(i+1));
		}
		return currentDistance;
	}
	
	public static double getRouteCostsIndexed0(DistanceMatrix distanceMatrix, ArrayList<Integer> route) {
		double currentDistance = 0;
		for (int i = 0; i < route.size()-1; i++) {
			currentDistance += distanceMatrix.getEntry(route.get(i)+1, route.get(i+1)+1);
		}
		return currentDistance;
	}
	
	/**
	 * Subtracts the service time from the route costs
	 * @param distanceMatrix
	 * @param route
	 * @param serviceTime
	 * @return
	 */
	public static double getRouteCostsSolomon(DistanceMatrix distanceMatrix, ArrayList<Integer> route, int serviceTime) {
		double currentDistance = 0;
		for (int i = 0; i < route.size()-1; i++) {
			currentDistance += distanceMatrix.getEntry(route.get(i), route.get(i+1));
			if (i > 0) currentDistance -= serviceTime;
		}
		return currentDistance;
	}
	
	public static ArrayList<Integer> convertArcsUsedToPath(int[][] arcsUsed) {
		int nLocations = arcsUsed.length;
		int nodeCount = 0;
		for (int i = 0; i < nLocations; i++) {
			for (int j = 0; j < nLocations; j++) {
				nodeCount += arcsUsed[i][j];
			}
		}
	   	int[][] edges = new int[2][nodeCount];
	    int counter = 0;
		for (int i = 0; i < nLocations; i++) {
   		 for (int j = 0; j < nLocations; j++) {
   			 if (i == 19) {
   				 int a = 0;
   				 a++;
   			 }
   			 if (arcsUsed[i][j] == 1) {
   				 edges[0][counter] = i;
   				 edges[1][counter] = j;
   				 counter++;
   			 }
   		 }
   	 }
   	 // now connect the edges 
   	 int[][] sortedEdges = new int[2][nodeCount];
   	 // insert first connection
   	 sortedEdges[0][0] = 0;
   	 sortedEdges[1][0] = edges[1][0];
		 int currentSuccessor = edges[1][0];
   	 for (int i = 0; i < nodeCount-1; i++) {
   		 for (int j = 1; j < nodeCount; j++) {
   			 if (edges[0][j] == currentSuccessor) {
   				 sortedEdges[0][i+1] = currentSuccessor;
   				 sortedEdges[1][i+1] = edges[1][j];
   				 currentSuccessor = edges[1][j];
   				 break;
   			 }
   		 }
   	 }
   	 // now take the first entry of the edges to build the route
   	 ArrayList<Integer> route = new ArrayList<Integer>();
   	 for (int i = 0; i < sortedEdges[0].length; i++) {
   		 if (sortedEdges[1][i] == 0) break;
   		 route.add(sortedEdges[0][i]+1);
   	 }
   	 
   	 // add the final depot
   	 route.add(1);
   	 return route;
	}
	
	public static void generateOutput(ArrayList<ArrayList<Integer>> routes, int compTimeLimit) throws Exception {
		ArrayList<Integer> nodeSequence = new ArrayList<Integer>();
		// add a group for plotting
		ArrayList<Integer> groups = new ArrayList<Integer>();
		for (int i = 0; i < routes.size(); i++) {
			for (int j = 0; j < routes.get(i).size(); j++) {
				nodeSequence.add(routes.get(i).get(j));
				groups.add(i+1);
			}
		}
		CSVExporter.writeNodesWithGroups("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy_30ExactSolution" + compTimeLimit + 
				"s.csv", nodeSequence, groups);
		
		String[] cmdarray = new String[6];
		//cmdarray[0] = "Rscript C:\\Users\\Marcus\\Documents\\FPMS\\source\\R\\TSPPlotting.R";
		cmdarray[0] = "\"C:\\Program Files\\R\\R-3.3.2\\bin\\Rscript.exe\"";
		cmdarray[1] = "C:\\Users\\Marcus\\Documents\\FPMS\\source\\R\\TSPPlotting.R";
		cmdarray[2] = "C:/Users/Marcus/Documents/FPMS/data/Dummy30Lonlats.csv";
		cmdarray[3] = "C:/Users/Marcus/Documents/FPMS/data/Dummy_30ExactSolution" + compTimeLimit + 
				"s.csv";
		cmdarray[4] = "fpApproach";
		cmdarray[5] = "C:/Users/Marcus/Documents/FPMS/images/autoGenerated/Dummy30_ExactSolution" + compTimeLimit + 
				"s";
		Process p = Runtime.getRuntime().exec(cmdarray);
	}
}
