package optimization;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Random;

import model.DistanceMatrix;
import model.ModelConstants;
import util.DistanceMatrixImporter;
import util.OrdersImporter;
import model.Order;

/**
 * Solves an SPPTWCC via dynamic programming labeling approach
 * With elimination of 2-cycles
 * @author Marcus
 *
 */
public class SPPTWCC2Experimental {
	
	private ArrayList<Node> nodes;
	private ArrayList<ArrayList<Label>> labelList;
	private ArrayList<Label> nps;
	private DistanceMatrix distanceMatrix;
	private DistanceMatrix reducedCostsMatrix;
	private ArrayList<Integer> shortestPath;
	private int currentTime;
	private ArrayList<ArrayList<Integer>> noGoRoutes;
	private double[] costRatios;
	private int highestTimeRemaining;
	private double lowestCosts = 0;
	
	private int labelCount;
	
	public static void main(String[] args) throws IOException {
		
		// initialize graph structure
		 DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv"));
		 double[] reducedCosts = new double[distmat.getAllEntries().length];
		 for (int i = 0; i < reducedCosts.length; i++) {
			 reducedCosts[i] = distmat.getAllEntries()[i];
		 }
		 Random r = new Random();
		 r.setSeed(0);
		 double[] duals = new double[distmat.getDimension()];
		 duals[0] = 0;
		 for (int i = 0; i < duals.length-1; i++) { 
			 duals[i+1] = r.nextInt(1344); //1344 highest entry of the distance matrix
			 //duals[i+1] += ModelConstants.CUSTOMER_LOADING_TIME;
		 }
		 distmat = distmat.insertDummyDepotAsFinalNode();
		 distmat.addCustomerServiceTimes(ModelConstants.CUSTOMER_LOADING_TIME);
		 distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 // copy distmat
		 double[] entries = distmat.getAllEntries();
		 double[] newEntries = new double[entries.length];
		 for (int i = 0; i < entries.length; i++) {
			 newEntries[i] = entries[i];
		 }
		 DistanceMatrix reducedCostsMat = new DistanceMatrix(newEntries);
		 reducedCostsMat = reducedCostsMat.subtractDuals(duals);
		 
		 // set entry from depot to depot to infinity
		 reducedCostsMat.setEntry(Double.MAX_VALUE, 1, reducedCostsMat.getDimension());

		 /**
		 for (int i = 0; i < reducedCostsMat.getDimension(); i++) {
			 for (int j = 0; j < reducedCostsMat.getDimension(); j++) {
				 System.out.println("i " + i + " j " + j + " value "  + reducedCostsMat.getEntry(i+1, j+1));
			 }
		 }*/
		 
		 ArrayList<Order> orders = OrdersImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\DummyOrders_30.csv");	
		 SPPTWCC2Experimental spptwcc = new SPPTWCC2Experimental(distmat, reducedCostsMat, orders, 40*60);
		 spptwcc.labelNodes();
	}
	
	public SPPTWCC2Experimental(DistanceMatrix distmat, DistanceMatrix reducedCostsMat, ArrayList<Order> orders, int currentTime) {
		this.nodes = new ArrayList<Node>();
		this.labelList = new ArrayList<ArrayList<Label>>();
		this.nps = new ArrayList<Label>();
		this.shortestPath = new ArrayList<Integer>();
		this.distanceMatrix = distmat;
		this.reducedCostsMatrix = reducedCostsMat;
		this.labelCount = 0;
		// initialize nodes
		// add dummy node for the depots
		nodes.add(new Node(0,0));
		for (Order o : orders) {
			int met = o.getMET(currentTime);
			Node n = new Node(ModelConstants.TIME_WINDOW - o.getMET(currentTime), (int)o.getWeight());
			nodes.add(n);
		}
		nodes.add(new Node(Integer.MAX_VALUE,0));
		
		// initialize labels
		for (Node n : nodes) {
			labelList.add(new ArrayList<Label>());
		}
		this.currentTime = currentTime;
	}
	
	
	public Path labelNodes() throws IOException {
		long time = System.currentTimeMillis();
		// determine a set of no-go routes based on their costs
		determineNoGoRoutes(Math.floor(distanceMatrix.getDimension()/1.7));
		getSortedCostRatios();
		getHighestTimeRemaining();
		
		
		Label initialLabel = new Label(0,0,0,0);
		labelList.get(0).add(initialLabel);
		nps.add(initialLabel);
		while (!nps.isEmpty()) {
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
			Label nextLabel = nps.get(lowestCostsIndex);
			nps.remove(lowestCostsIndex);
			labelNext(nextLabel);
		}
		FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\LabelsGenerated_SPPTWCC2_Standard.csv", true);
		writer.write(labelCount + "\n");
		writer.close();
		System.out.println("Labels created: " + labelCount);
		// compute the shortest path
		ArrayList<Label> allFinalLabels = labelList.get(distanceMatrix.getDimension()-1);
		double minimalCosts = Double.MAX_VALUE;
		int index = -1;
		for (int i = 0; i < allFinalLabels.size(); i++) {
			if (allFinalLabels.get(i).getCosts() < minimalCosts) {
				minimalCosts = allFinalLabels.get(i).getCosts();
				index = i;
			}
		}
		
		getShortestPath(allFinalLabels.get(index));
		ArrayList<Integer> path = new ArrayList<Integer>();
		
		//FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\paths.txt", true);
		
		
		for (int i = shortestPath.size() - 1; i >= 0; i--) {
			path.add(shortestPath.get(i));
			//writer.write(shortestPath.get(i) + "->");
		}
		for (int i = 0; i < path.size()-1; i++) {
			System.out.print(path.get(i) + "->");
		}
		System.out.println(path.get(path.size()-1));
		
		System.out.println("Costs of the shortest path: " + allFinalLabels.get(index).getCosts());
		System.out.println("Number of reduced costs paths: " + allFinalLabels.size());
		System.out.println("Time consumed: " + (System.currentTimeMillis() - time));
		double costs = getPathCosts(path);
		Path result = new Path(path, costs, labelList.get(distanceMatrix.getDimension()-1).get(0).getCosts(), 
				distanceMatrix.getDimension());
		return result;
	}

	private void labelNext(Label currentLabel) {
		
		// for all neighbors of the current label (which are all nodes)
		boolean breakLater = false;
		for (int i = 1; i < distanceMatrix.getDimension(); i++) {
			if (breakLater) break;
			// skip nogo routes
			if (noGoRoutes.get(currentLabel.getNode()).contains(i)) continue;
			
			if (i == currentLabel.getNode()) continue;
			// if strongly dominant and current node is predecessor, continue
			if (currentLabel.getPredecessor() != null && 
					(currentLabel.getType() == 0 && currentLabel.getPredecessor().getNode() == i)) continue;
			
			// if semi-strongly dominant and current node is predecessor, continue
			if (currentLabel.getPredecessor() != null && 
					(currentLabel.getType() == 1 && currentLabel.getPredecessor().getNode() == i)) continue;
			
			// if weakly dominant can only extend to the successor of the dominating label
			if (currentLabel.getType() == 2) {
				i = currentLabel.getDominatingLabel().getPredecessor().getNode();
				breakLater = true;
			}
			
			// check if new label is feasible wrt time
			int newTime = (int)(currentLabel.getTime() + distanceMatrix.getEntry(currentLabel.getNode()+1, i+1));
			if (newTime > nodes.get(i).getUpperTimeWindow()) continue;
			// check if new label is feasible wrt demand
			int newDemand = currentLabel.getDemand() + nodes.get(i).getDemand();
			if (newDemand > ModelConstants.VEHICLE_CAPACITY) continue;
		
			int newCosts = (int)(currentLabel.getCosts() + reducedCostsMatrix.getEntry(currentLabel.getNode()+1, i+1));
			Label l = new Label(newCosts, newDemand, newTime, i, currentLabel, 1);
			
			// check if from this label the goal of negative reduced costs can still be reached
			if (!checkCostsInfeasibility(l)) continue;

			// check if new label is dominated or dominates a label
			ArrayList<Label> labels = labelList.get(i);
			// different dominance criterion for the final node
			// only depends on the costs
			/**if (i == distanceMatrix.getDimension()-1) {
				if (labels.size() == 0) {
					labels.add(l);
				}
				else {
					Label lab = labels.get(0);
					if (l.getCosts() < lab.getCosts()) {
						labels.remove(0);
						labels.add(l);
						labelCount++;
					}
				}
			}*/
			
			if (i == distanceMatrix.getDimension()-1 && l.getCosts() < 0) {
				/**for (int j = 0; j < labels.size(); j++) {
					Label lab = labels.get(j);
					if (dominates(lab, l)) continue;
					if (dominates(l, lab)) labels.remove(lab);
				}*/
				labelCount++;
				labels.add(l);
				//if (l.getCosts() < lowestCosts) lowestCosts = l.getCosts();
			}
			
			// check dominance
			else if (i != distanceMatrix.getDimension()-1) {
				boolean dominated = false;
				for (int j = 0; j < labels.size(); j++) {
					Label lab = labels.get(j);
					if (dominates(lab, l)) {
						// case 1
						if (lab.getType() != 1) {
							dominated = true;
							break;
						}
						// case 2
						else if (l.getPredecessor().getNode() == lab.getPredecessor().getNode()) {
							dominated = true;
							break;
						}
						// case 3
						boolean dominatedByTwo = false;
						for (int k = 0; k < labels.size(); k++) {
							if (j == k) continue;
							Label lab1 = labels.get(k);
							if (dominates(lab1, l) && lab1.getPredecessor().getNode() != lab.getPredecessor().getNode()) {
								dominatedByTwo = true;
								break;
							}
						}
						if (dominatedByTwo) {
							dominated = true;
							break;
						}
						// case 4
						if (((l.getDemand() + nodes.get(l.getNode()).getDemand()) > ModelConstants.VEHICLE_CAPACITY) ||
								(l.getTime() + distanceMatrix.getEntry(l.getNode()+1, lab.getPredecessor().getNode()+1) >
								nodes.get(lab.getPredecessor().getNode()).getUpperTimeWindow())) {
							dominated = true;
							break;
						}
						
						// set weakly dominant and add dominating label
						l.setType(2);
						l.setDominatingLabel(lab);
					}
				}
				// check if strongly dominant
				if (!dominated) {
					if (nodes.get(l.getPredecessor().getNode()).getDemand() + l.getDemand() > ModelConstants.VEHICLE_CAPACITY ||
							l.getTime() + distanceMatrix.getEntry(l.getNode()+1, l.getPredecessor().getNode()+1) >
					nodes.get(l.getPredecessor().getNode()).getUpperTimeWindow()) l.setType(0);
				}
				
				// check if existing labels are dominated
				for (int j = 0; j < labels.size(); j++) {
					Label lab = labels.get(j);
					// case 1
					if (dominates(l, lab)) {
						if (l.getType() != 1) {
							labels.remove(j);
							if (nps.contains(lab)) nps.remove(lab);
						}
						// case 2
						else if (l.getPredecessor().getNode() == lab.getPredecessor().getNode()) {
							labels.remove(j);
							if (nps.contains(lab)) nps.remove(lab);
						}
						// case 3
						else {
							boolean dominatedByTwo = false;
							for (int k = 0; k < labels.size(); k++) {
								if (j == k) continue;
								Label lab1 = labels.get(k);
								if (dominates(lab1, lab) && l.getPredecessor().getNode() != lab1.getPredecessor().getNode()) {
									dominatedByTwo = true;
									break;
								}
							}
							if (dominatedByTwo) {
								labels.remove(j);
								if (nps.contains(lab)) nps.remove(lab);
							}
						}
						
						// case 4 can be skipped
					}
					
				}
				
				// add only if non-dominated
				if (!dominated) {
					labelCount++;
					labels.add(l);
					nps.add(l);
				}
			}
			if (currentLabel.getType() == 2) break;
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
	
	/**
	 * Checks for the given label whether the goal of negative reduced costs can still be reached
	 * @param label
	 */
	private boolean checkCostsInfeasibility(Label label) {
		int timeRemaining = highestTimeRemaining - label.getTime();
		if (label.getCosts() + (timeRemaining * costRatios[0]) >= lowestCosts) return false;
		return true;
	}
	
	/**
	 * Gets the lowest reduced costs divided by actual travel times
	 * @param number
	 */
	private void getSortedCostRatios() {
		double[] entries = new double[reducedCostsMatrix.getDimension() * reducedCostsMatrix.getDimension()];
		
		// find the shortest path between two all pair-wise combinations of customers
		int counter = 0;
		for (int i = 0; i < reducedCostsMatrix.getDimension(); i++) {
			for (int j = 0; j < reducedCostsMatrix.getDimension(); j++) {
				entries[counter++] = reducedCostsMatrix.getEntry(i+1, j+1)/distanceMatrix.getEntry(i+1, j+1);
			}
		}
		
		Arrays.sort(entries);
		costRatios = entries;
	}
	
	private void getHighestTimeRemaining() {
		highestTimeRemaining = 0;
		for (int i = 0; i < nodes.size()-1; i++) {
			if (nodes.get(i).getUpperTimeWindow() > highestTimeRemaining) highestTimeRemaining = nodes.get(i).getUpperTimeWindow();
		}
	}
	
	private class Node {
		private int upperTimeWindow;
		private int demand;
		
		public Node(int upperTimeWindow, int demand) {
			this.upperTimeWindow = upperTimeWindow;
			this.demand = demand;
		}
		
		public int getUpperTimeWindow() {
			return upperTimeWindow;
		}
		public void setUpperTimeWindow(int upperTimeWindow) {
			this.upperTimeWindow = upperTimeWindow;
		}
		public int getDemand() {
			return demand;
		}
		public void setDemand(int demand) {
			this.demand = demand;
		}	
	}
	
	private class Label {
		private double costs;
		private int demand;
		private int time;
		private int node;
		private Label predecessor;
		private Label dominatingLabel; // only filled if current label type is 2
		private int type; // 0 = strongly dominant, 1 = semi-strongly dominant, 2 = weakly dominant
		
		public Label(double costs, int demand, int time, int node) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
		}
		
		public Label(double costs, int demand, int time, int node, Label predecessor, int type) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
			this.predecessor = predecessor;
			this.type = type;
		}
		
		public Label(double costs, int demand, int time, int node, Label predecessor, int type, Label dominatingLabel) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
			this.predecessor = predecessor;
			this.type = type;
			this.setDominatingLabel(dominatingLabel);
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

		public int getTime() {
			return time;
		}

		public void setTime(int time) {
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

		public int getType() {
			return type;
		}

		public void setType(int type) {
			this.type = type;
		}

		public Label getDominatingLabel() {
			return dominatingLabel;
		}

		public void setDominatingLabel(Label dominatingLabel) {
			this.dominatingLabel = dominatingLabel;
		}

		
	}
}
