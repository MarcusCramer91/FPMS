package solomon;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Random;

import model.DistanceMatrix;
import model.ModelConstants;
import util.DistanceMatrixImporter;
import util.OrdersImporter;
import model.Order;
import optimization.ModelHelperMethods;

/**
 * Solves an SPPTWCC via dynamic programming labeling approach
 * @author Marcus
 *
 */
public class ESPPTWCC_Heuristic {
	
	private ArrayList<Node> nodes;
	private ArrayList<ArrayList<Label>> labelList;
	private ArrayList<Label> nps;
	private DistanceMatrix distanceMatrix;
	private DistanceMatrix reducedCostsMatrix;
	private ArrayList<Integer> shortestPath;
	private int currentTime;
	private ArrayList<ArrayList<Integer>> noGoRoutes;
	private int nBestRounds;
	private boolean returnNegativeOnly;
	private int labelCount;
	private long startingTime;
	
	
	public ESPPTWCC_Heuristic(DistanceMatrix distmat, DistanceMatrix reducedCostsMat, ArrayList<Order> orders, int currentTime,
			int nBestRounds, boolean returnNegativeOnly) {
		this.startingTime = System.currentTimeMillis();
		this.returnNegativeOnly = returnNegativeOnly;
		this.nodes = new ArrayList<Node>();
		this.labelList = new ArrayList<ArrayList<Label>>();
		this.nps = new ArrayList<Label>();
		this.shortestPath = new ArrayList<Integer>();
		this.distanceMatrix = distmat;
		this.reducedCostsMatrix = reducedCostsMat;
		this.labelCount = 0;
		this.nBestRounds = nBestRounds;
		// initialize nodes
		// add dummy node for the depots
		nodes.add(new Node(0,0,0));
		for (Order o : orders) {
			int met = o.getMET(currentTime);
			Node n = new Node(o.getEarliest(), o.getLatest(), (int)o.getWeight());
			nodes.add(n);
		}
		nodes.add(new Node(0, Integer.MAX_VALUE,0));
		
		// initialize labels
		for (Node n : nodes) {
			labelList.add(new ArrayList<Label>());
		}
		this.currentTime = currentTime;
	}
	
	
	public ArrayList<Path> labelNodes() throws IOException {
		long time = System.currentTimeMillis();
		//determineNoGoRoutes(Math.floor(distanceMatrix.getDimension()/3));
		Label initialLabel = new Label(0,0,0,0);
		labelList.get(0).add(initialLabel);
		nps.add(initialLabel);
		while (!nps.isEmpty() && (System.currentTimeMillis() - startingTime) < 200*1000) {
			// find label with the lowest costs that is not assigned to the final node
			double lowestCosts = Double.MAX_VALUE;
			int lowestCostsIndex = -1;
			for (int i = 0; i < nps.size(); i++) {
				if (nps.get(i).getNode() == distanceMatrix.getDimension()-1) continue;
				if (nps.get(i).getCosts() < lowestCosts) {
					lowestCosts = nps.get(i).getCosts();
					lowestCostsIndex = i;
				}
			}
			if (lowestCostsIndex == -1) break;
			Label nextLabel = nps.get(lowestCostsIndex);
			nps.remove(lowestCostsIndex);
			labelNext(nextLabel);
		}
		/**FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\LabelsGeneratedStandard.csv", true);
		writer.write(labelCount + "\n");
		writer.close();*/
		//System.out.println("Labels created: " + labelCount);
		
		
		// compute the shortest path
		ArrayList<Label> allFinalLabels = labelList.get(distanceMatrix.getDimension()-1);
		if (allFinalLabels.size() == 0 && returnNegativeOnly) return null;
		ArrayList<Path> paths = new ArrayList<Path>();
		if (allFinalLabels.size() == 0 && !returnNegativeOnly) {		
			paths = new ArrayList<Path>();		
			ArrayList<Integer> nodes = new ArrayList<Integer>();		
			nodes.add(0);		
			nodes.add(distanceMatrix.getDimension()-1);		
			Path p = new Path(nodes, 0, 0, distanceMatrix.getDimension());		
			paths.add(p);
			return paths;
		}
		
		/*PrintWriter writer = new PrintWriter(new File("C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\firstreducedcostsmat.csv"));
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < distanceMatrix.getDimension(); i++) {
			for (int j = 0; j < distanceMatrix.getDimension(); j++) {
				sb.append(reducedCostsMatrix.getEntry(i+1, j+1));
				sb.append(",");
			}
			sb.append("\n");
		}
		writer.write(sb.toString());
		writer.close();*/
		
		// get n best routes
		for (int i = 0; i < nBestRounds; i++) {
			if (allFinalLabels.size() == 0) break;
			paths.add(getNextBestPath(allFinalLabels));
		}
		//System.out.println(labelCount + " labels created");
		for (int i : paths.get(0).getNodes()) System.out.print(i + " ");
		System.out.println();
		return paths;
	}

	private void labelNext(Label currentLabel) {
	
		// for all neighbors of the current label (which are all nodes)
		for (int i = 1; i < distanceMatrix.getDimension(); i++) {
			if (i == currentLabel.getNode()) continue;
			
			// check elementary constraint
			if (checkNodeRepetition(currentLabel,i)) continue;

			// skip nogo routes
			if (noGoRoutes != null && noGoRoutes.get(currentLabel.getNode()).contains(i)) continue;
			
			// check if new label is feasible wrt time
			double newTime = (currentLabel.getTime() + distanceMatrix.getEntry(currentLabel.getNode()+1, i+1));
			if (newTime > nodes.get(i).getUpperTimeWindow()) continue;

			// if arrival time is before the earliest for that node, wait
			if (newTime < nodes.get(i).getLowerTimeWindow()) newTime = nodes.get(i).getLowerTimeWindow();
			
			// check if new label is feasible wrt demand
			int newDemand = currentLabel.getDemand() + nodes.get(i).getDemand();
			if (newDemand > ModelConstants.SOLOMON_VEHICLE_CAPACITY) continue;
			int newCosts = (int)(currentLabel.getCosts() + reducedCostsMatrix.getEntry(currentLabel.getNode()+1, i+1));
			Label l = new Label(newCosts, newDemand, newTime, i, currentLabel, labelCount);

			// check if new label is dominated or dominates a label
			ArrayList<Label> labels = labelList.get(i);
			// different dominance criterion for the final node
			// only depends on the costs
			if (i == distanceMatrix.getDimension()-1) {					
				if (l.getCosts() < 0) {
					boolean dominated = false;
					for (int j = 0; j < labels.size(); j++) {		
						Label lab = labels.get(j);						
						// check if existing labels are dominated		
						if (dominates(l, lab)) {		
							// remove both from nps and the labels map if dominated		
							labels.remove(j);		
							if (nps.contains(lab)) nps.remove(lab);		
						}		
						// check if existing labels dominate the new one		
						if (dominates(lab,l)) {		
							dominated = true;		
							break;		
						}		
					}		
					// add only if non-dominated		
					if (!dominated) {		
						//System.out.println("Created label: (" + l.getNode() + "," + l.getTime() + "," + l.getDemand() + ") = " + l.getCosts());		
						labels.add(l);		
						labelCount++;		
					}		
				}
			}
			else {
				boolean dominated = false;
				for (int j = 0; j < labels.size(); j++) {
					Label lab = labels.get(j);				
					// check if existing labels are dominated
					if (dominates(l, lab)) {
						// remove both from nps and the labels map if dominated
						labels.remove(j);
						if (nps.contains(lab)) nps.remove(lab);
					}
					// check if existing labels dominate the new one
					if (dominates(lab,l)) {
						dominated = true;
						break;
					}
				}
				// add only if non-dominated
				if (!dominated) {
					//System.out.println("Created label: (" + l.getNode() + "," + l.getTime() + "," + l.getDemand() + ") = " + l.getCosts());
					labels.add(l);
					nps.add(l);
					labelCount++;
				}
			}
		}	
	}
	
	private boolean dominates(Label l1, Label l2) {
		if (l1.getCosts() > l2.getCosts() || l1.getDemand() > l2.getDemand() || l1.getTime() > l2.getTime()) return false;
		return true;
	}
	
	/** 
	 * Get the shortest path by walking backwards through the labels
	 */
	private void getShortestPath(Label currentLabel) {
		shortestPath.add(currentLabel.getNode());
		//System.out.println("l(" + currentLabel.getNode() + "," + currentLabel.getTime() + "," + currentLabel.getDemand() + 
		//		")=" + currentLabel.getCosts());
		if (currentLabel.getPredecessor() == null) return;
		getShortestPath(currentLabel.getPredecessor());	
	}
	
	private boolean checkNodeRepetition(Label currentLabel, int next) {
		if (currentLabel.getPredecessor() == null) return false;
		else if (currentLabel.getPredecessor().getNode() == next) return true;
		else return checkNodeRepetition(currentLabel.getPredecessor(), next);
	}
	
	private double getPathCosts(ArrayList<Integer> path) {	
		double costs = 0;
		for (int i = 0; i < path.size() - 1; i++) {
			costs += distanceMatrix.getEntry(path.get(i)+1, path.get(i+1)+1);
		}
		return costs;
	}
	

	/**
	 * For every node determines a set of no-go successor nodes based on the 
	 * numberOfNoGoRoutesPerLocation longest distances
	 * Exploits the problem characteristic of very relaxed resource constraints, in which 
	 * reduced costs outweigh decisions based on restrictions
	 * @param numberOfNoGoRoutesPerLocation
	 */
	private void determineNoGoRoutes(double numberOfNoGoRoutesPerLocation) {
		noGoRoutes = new ArrayList<ArrayList<Integer>>();
		ArrayList<Integer> nogo = new ArrayList<Integer>();
		// can go everywhere from the depot
		noGoRoutes.add(nogo);
		for (int i = 1; i < nodes.size()-1; i++) {
			nogo = new ArrayList<Integer>();
			double[] costs = distanceMatrix.getRow(i+1);
			for (int j = 0; j < numberOfNoGoRoutesPerLocation; j++) {
				double highestCosts = 0;
				int highestCostsIndex = -1;
				for (int k = 1; k < nodes.size()-1; k++) {
					if (costs[k] > highestCosts) {
						highestCosts = costs[k];
						highestCostsIndex = k;
					}
				}
				nogo.add(highestCostsIndex);
				costs[highestCostsIndex] = 0;
			}
			noGoRoutes.add(nogo);
		}
	}
	
	private Path getNextBestPath(ArrayList<Label> labels) {
		double minimalCosts = Double.MAX_VALUE;
		int index = -1;
		for (int i = 0; i < labels.size(); i++) {
			if (labels.get(i).getCosts() < minimalCosts) {
				minimalCosts = labels.get(i).getCosts();
				index = i;
			}
		}
		double reducedCosts = labels.get(index).getCosts();
		shortestPath = new ArrayList<Integer>();
		getShortestPath(labels.get(index));
		ArrayList<Integer> path = new ArrayList<Integer>();		
		for (int i = shortestPath.size() - 1; i >= 0; i--) {
			path.add(shortestPath.get(i));
		}
		labels.remove(index);
		double costs = ModelHelperMethods.getRouteCostsIndexed0(distanceMatrix, path);
		Path result = new Path(path, costs, reducedCosts, distanceMatrix.getDimension());
		// check feasibility
		costs = 0;
		if (path.get(1) == 1 && path.get(2) == 3 && path.get(3) == 5 && path.get(4) == 4) {
			System.out.println();
		}
		for (int i = 0; i < path.size()-1; i++) {
			costs += distanceMatrix.getEntry(path.get(i)+1, path.get(i+1)+1);
			if (costs > nodes.get(path.get(i+1)).getUpperTimeWindow()) {
				System.out.println("Something is wrong here for label " + labels.get(index).getId());
			}
			if (costs < nodes.get(path.get(i+1)).getLowerTimeWindow()) costs = nodes.get(path.get(i+1)).getLowerTimeWindow();
		}
		return result;
	}
	
	private class Node {
		private int upperTimeWindow;
		private int lowerTimeWindow;
		private int demand;
		
		public Node(int lowerTimeWindow, int upperTimeWindow, int demand) {
			this.upperTimeWindow = upperTimeWindow;
			this.lowerTimeWindow = lowerTimeWindow;
			this.demand = demand;
		}
		
		public int getUpperTimeWindow() {
			return upperTimeWindow;
		}
		
		public int getDemand() {
			return demand;
		}

		public int getLowerTimeWindow() {
			return lowerTimeWindow;
		}
	}
	
	private class Label {
		private double costs;
		private int demand;
		private double time;
		private int node;
		private Label predecessor;
		private int id;
		
		public Label(double costs, int demand, double time, int node) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
		}
		
		public Label(double costs, int demand, double time, int node, Label predecessor, int id) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
			this.predecessor = predecessor;
			this.id = id;
		}

		public int getId() {
			return id;
		}
		
		public double getCosts() {
			return costs;
		}

		public void setCosts(double costs) {
			this.costs = costs;
		}

		public int getDemand() {
			return demand;
		}

		public void setDemand(int demand) {
			this.demand = demand;
		}

		public double getTime() {
			return time;
		}

		public void setTime(double time) {
			this.time = time;
		}

		public int getNode() {
			return node;
		}

		public void setNode(int node) {
			this.node = node;
		}

		public Label getPredecessor() {
			return this.predecessor;
		}

		public void setPredecessor(Label predecessor) {
			this.predecessor = predecessor;
		}
	}
}
