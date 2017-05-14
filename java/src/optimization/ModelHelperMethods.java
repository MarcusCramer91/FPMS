package optimization;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;

import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import model.Vehicle;

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
		timeConsumed += Math.round(distanceMatrix.getEntry(1, route[0].getDistanceMatrixLink()) / 60);
		// check for the first customer
		if (timeConsumed + route[0].getMET(currentTime) > ModelConstants.TIME_WINDOW) return false;		
		// then add all travel times and service times up to the last order
		for (int i = 1; i < route.length; i++) {
			// add service time of previous customer
			timeConsumed += ModelConstants.CUSTOMER_LOADING_TIME;
			long travelTime = Math.round(distanceMatrix.getEntry(route[i-1].getDistanceMatrixLink(), route[i].getDistanceMatrixLink()) / 60);
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
		// check for the first customer
		if (timeConsumed + route[0].getMET(currentTime) > ModelConstants.TIME_WINDOW) return false;		
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
}
