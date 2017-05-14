package tsp;

import java.util.List;

import model.DistanceMatrix;

public class TSPHelper {
	public static double getRouteCosts(DistanceMatrix distanceMatrix, int[] route) {
		double currentDistance = 0;
		for (int j = 0; j < distanceMatrix.getDimension(); j++) {
			if (route[j+1] == 0) continue;
			currentDistance += distanceMatrix.getEntry(route[j], route[j+1]);
		}
		return currentDistance;
	}
	
	public static boolean containsEdge(int[][] edges, int from, int to) {
		for (int i = 0; i < edges[0].length; i++) {
			if ((edges[0][i] == from && edges[1][i] == to) ||
					edges[1][i] == from && edges[0][i] == to) return true;
		}
		return false;
	}
	
	public static boolean containsNode(int[] nodes, int node) {
		for (int n : nodes) {
			if (n == node) return true;
		}
		return false;
	}
	
	public static boolean containsNodeInList(List<Integer> nodes, int node) {
		for (int n : nodes) {
			if (n == node) return true;
		}
		return false;
	}
	
	public static boolean edgeExists(int[][] edges, int from, int to) {
		for (int i = 0; i < edges[0].length; i++) {
			if (edges[0][i] == from && edges[1][i] == to ||
					edges[0][i] == to && edges[1][i] == from) return true;
		}
		return false;
	}
}
