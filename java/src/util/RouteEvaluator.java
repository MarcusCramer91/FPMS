package util;

import model.DistanceMatrix;
import tsp.TSPExact;
import tsp.TSPHelper;

public class RouteEvaluator {
 	private static String travelTimesMatrix = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\SmallRealTravelTimes.csv";

	public static void main(String[] args) {
		int[] routeAirDistance = {1,7,9,5,6,4,2,3,10,8,1};
		int[] routeTravelTimese = {1,10,3,2,4,5,6,9,7,8,1};
		int[] christofides = {2,3,6,9,7,1,8,10,5,4,2};
		double[] valuesTravelTimes = DistanceMatrixImporter.importCSV(travelTimesMatrix);
		DistanceMatrix distanceMatrix = new DistanceMatrix(valuesTravelTimes);
		double distanceAir = TSPHelper.getRouteCosts(distanceMatrix, routeAirDistance);
		double distanceTravelTimes = TSPHelper.getRouteCosts(distanceMatrix, routeTravelTimese);
		double distanceChristofides = TSPHelper.getRouteCosts(distanceMatrix, christofides);
		System.out.println("The TSP via air distances yields a route with the total travel times of: " + distanceAir);
		System.out.println("The TSP via travel times yields a route with the total travel times of: " + distanceTravelTimes);
		System.out.println("The TSP via Christofides construction yields a route with the total travel times of: " + distanceChristofides);
	}
}
