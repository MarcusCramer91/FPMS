package solomon;

import java.util.ArrayList;

public class Path {

	private int[][] arcsUsed;
	private double costs;
	private double reducedCosts;
	private ArrayList<Integer> nodes;
	private int[] a;
	private double[] sValue;
	
	public Path(ArrayList<Integer> nodes, double costs, double reducedCosts, int dimension) {
		a = new int[dimension];
		this.setCosts(costs);
		this.arcsUsed = new int[dimension][dimension];
		this.reducedCosts = reducedCosts;
		// convert nodes of the path to arcs used
		for (int i = 0; i < nodes.size()-1; i++) {
			arcsUsed[nodes.get(i)][nodes.get(i+1)] = 1;
		}
		for (int i = 0; i < nodes.size(); i++) {
			a[nodes.get(i)] = 1;
		}
		this.setNodes(nodes);
	}

	public void setSValue(double[] sValue) {
		this.sValue = sValue;
	}
	
	public double[] getSValue() {
		return sValue;
	}
	
	public int[] getA() {
		return a;
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
