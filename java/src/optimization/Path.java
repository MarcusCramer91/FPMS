package optimization;

import java.util.ArrayList;

public class Path {

	private int[][] arcsUsed;
	private double costs;
	private double reducedCosts;
	private ArrayList<Integer> nodes;
	
	public Path(ArrayList<Integer> nodes, double costs, double reducedCosts, int dimension) {
		this.setCosts(costs);
		this.arcsUsed = new int[dimension][dimension];
		this.reducedCosts = reducedCosts;
		// convert nodes of the path to arcs used
		for (int i = 0; i < nodes.size()-1; i++) {
			arcsUsed[nodes.get(i)][nodes.get(i+1)] = 1;
		}
		this.setNodes(nodes);
	}

	public double getCosts() {
		return costs;
	}

	public void setCosts(double costs) {
		this.costs = costs;
	}

	public int[][] getArcsUsed() {
		return arcsUsed;
	}

	public void setArcsUsed(int[][] arcsUsed) {
		this.arcsUsed = arcsUsed;
	}

	public double getReducedCosts() {
		return reducedCosts;
	}

	public void setReducedCosts(double reducedCosts) {
		this.reducedCosts = reducedCosts;
	}

	public ArrayList<Integer> getNodes() {
		return nodes;
	}

	public void setNodes(ArrayList<Integer> nodes) {
		this.nodes = nodes;
	}
}
