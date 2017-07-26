package optimization.pricingproblem;

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
public class ESPPTWCC_Heuristic_Recomputation {
	
	private ArrayList<Node> nodes;
	private ArrayList<ArrayList<Label>> labelList;
	private ArrayList<Label> nps;
	private DistanceMatrix distanceMatrix;
	private DistanceMatrix distmatCopy;
	private DistanceMatrix reducedCostsMatrix;
	private DistanceMatrix reducedCostsMatCopy;
	private ArrayList<Integer> shortestPath;
	private int currentTime;
	private ArrayList<ArrayList<Integer>> noGoRoutes;
	private boolean returnOnlyNegative;
	
	private int labelCount;
	
	public static void main(String[] args) throws IOException {
		
		// initialize graph structure
		 DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv"));
		 double[] reducedCosts = new double[distmat.getAllEntries().length];
		 for (int i = 0; i < reducedCosts.length; i++) {
			 reducedCosts[i] = distmat.getAllEntries()[i];
		 }

		 double[] duals = new double[]{0, 3381, 3697, 3922, 3594, 3691, 3536, 3334, 3517,3445,3442,3006,3056,2863,3262, 2915, 
			 3128, 3149, 2916, 2831, 3089, 3414, 3406, 3464, 3159, 3801, 3739, 3508, 3515, 3406, 3387};
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
		 ESPPTWCC_Heuristic_Recomputation spptwcc = new ESPPTWCC_Heuristic_Recomputation(distmat, reducedCostsMat, orders, 40*60, true);
		 spptwcc.labelNodes();
	}
	
	public ESPPTWCC_Heuristic_Recomputation(DistanceMatrix distmat, DistanceMatrix reducedCostsMat, ArrayList<Order> orders, 
			int currentTime, boolean returnOnlyNegative) {
		this.returnOnlyNegative = returnOnlyNegative;
		this.nodes = new ArrayList<Node>();
		this.labelList = new ArrayList<ArrayList<Label>>();
		this.nps = new ArrayList<Label>();
		this.distanceMatrix = distmat;
		this.reducedCostsMatrix = reducedCostsMat;
		// initialize nodes
		// add dummy node for the depots
		nodes.add(new Node(0,0));
		for (Order o : orders) {
			Node n = new Node(ModelConstants.TIME_WINDOW - o.getMET(currentTime), (int)o.getWeight());
			nodes.add(n);
		}
		nodes.add(new Node(Integer.MAX_VALUE,0));
		
		// initialize labels
		for (@SuppressWarnings("unused") Node n : nodes) {
			labelList.add(new ArrayList<Label>());
		}
		this.currentTime = currentTime;
	}
	
	public ArrayList<Path> labelNodes() throws IOException {
		ArrayList<Path> result = new ArrayList<Path>();
		ArrayList<Integer> indexList = new ArrayList<Integer>();
		
		// copy distance matrices
		double[] entries = distanceMatrix.getAllEntries();
		double[] newEntries = new double[entries.length];
		for (int i = 0; i < entries.length; i++) {
			newEntries[i] = entries[i];
		}
		distmatCopy = new DistanceMatrix(newEntries);
		
		for (int i = 0; i < distanceMatrix.getDimension(); i++) {
			indexList.add(i);
		}
		
		double[] entriesReducedCosts = reducedCostsMatrix.getAllEntries();
		double[] newEntriesReducesCosts = new double[entriesReducedCosts.length];
		for (int i = 0; i < entriesReducedCosts.length; i++) {
			newEntriesReducesCosts[i] = entriesReducedCosts[i];
		}
		reducedCostsMatCopy = new DistanceMatrix(newEntriesReducesCosts);
		
		// return shortest paths
		while (indexList.size() > 2) {
			this.labelCount = 0;
			this.shortestPath = new ArrayList<Integer>();
			this.labelList = new ArrayList<ArrayList<Label>>();
			for (@SuppressWarnings("unused") Node n : nodes) {
				labelList.add(new ArrayList<Label>());
			}
			this.nps = new ArrayList<Label>();
			
			// get the path
			Path p = labelNodesInternal();
			
			// if first path has positive reduced costs, return null
			if (result.size() == 0 && p.getReducedCosts() >= 0) {
				ArrayList<Integer> nodes = new ArrayList<Integer>();
				nodes.add(0);
				nodes.add(distanceMatrix.getDimension()-1);
				p = new Path(nodes, 0, 0, distanceMatrix.getDimension());
				result.add(p);
				return result;
			}
			
			// if any path has contains only the depot and is not the first path, break
			if (result.size() > 0 && p.getNodes().size() == 2) break;
			
			// reconvert the path 
			ArrayList<Integer> nodes = p.getNodes();
			ArrayList<Integer> newNodes = new ArrayList<Integer>();
			for (int i = 0; i < nodes.size(); i++) {
				newNodes.add(indexList.get(nodes.get(i)));
			}
			p = new Path(newNodes, p.getCosts(), p.getReducedCosts(), distanceMatrix.getDimension());
			result.add(p);
			//for (int i : p.getNodes()) System.out.print(i + "->");
			//System.out.println();
			
			// crop matrices
			int[] relevantEntries = new int[indexList.size() - nodes.size() + 2];
			int counter = 0;
			relevantEntries[counter++] = 1;
			for (int i = 0; i < indexList.size()-1; i++) {
				if (!nodes.contains(i) && i != 0) relevantEntries[counter++] = i+1;
			}
			relevantEntries[relevantEntries.length-1] = distmatCopy.getDimension();
			distmatCopy = distmatCopy.getCroppedMatrix(relevantEntries);
			
			int[] relevantEntriesReducedCosts = new int[indexList.size() - nodes.size() + 2];
			counter = 0;
			relevantEntriesReducedCosts[counter++] = 1;
			for (int i = 0; i < indexList.size()-1; i++) {
				if (!nodes.contains(i) && i != 0) relevantEntriesReducedCosts[counter++] = i+1;
			}
			relevantEntriesReducedCosts[relevantEntriesReducedCosts.length-1] = distmatCopy.getDimension();
			reducedCostsMatCopy = reducedCostsMatCopy.getCroppedMatrix(relevantEntriesReducedCosts);
			
			// crop index list 
			for (int i = 0; i < indexList.size(); i++) {
				if (newNodes.contains(indexList.get(i)) && indexList.get(i) != 0 
						&& indexList.get(i) != (distanceMatrix.getDimension()-1)) {
					indexList.remove(i);
					i--;
				}
			}
			
			// crop nodes list
			for (int i = 0; i < this.nodes.size(); i++) {
				if (nodes.contains(this.nodes.get(i))) {
					this.nodes.remove(i);
					i--;
				}
			}
		}
		return result;
	}
	
	
	private Path labelNodesInternal() throws IOException {
		long time = System.currentTimeMillis();
		//determineNoGoRoutes(Math.floor(distanceMatrix.getDimension()/3));
		Label initialLabel = new Label(0,0,0,0);
		labelList.get(0).add(initialLabel);
		nps.add(initialLabel);
		while (!nps.isEmpty()) {
			
			// find label with the lowest costs that is not assigned to the final node
			double lowestCosts = Double.MAX_VALUE;
			int lowestCostsIndex = -1;
			for (int i = 0; i < nps.size(); i++) {
				if (nps.get(i).getNode() == distmatCopy.getDimension()-1) continue;
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
		
		
		// compute the shortest path
		ArrayList<Label> allFinalLabels = labelList.get(distmatCopy.getDimension()-1);
		if (allFinalLabels.size() == 0) return null;
		
		// get n best routes
		
		if (allFinalLabels.size() == 0) return null;
		Path path = getNextBestPath(allFinalLabels);
		return path;
	}

	private void labelNext(Label currentLabel) {
		
		// for all neighbors of the current label (which are all nodes)
		for (int i = 1; i < distmatCopy.getDimension(); i++) {
			if (i == currentLabel.getNode()) continue;
			
			// check elementary constraint
			if (checkNodeRepetition(currentLabel,i)) continue;
			
			// check if new label is feasible wrt time
			int newTime = (int)(currentLabel.getTime() + distmatCopy.getEntry(currentLabel.getNode()+1, i+1));
			if (newTime > nodes.get(i).getUpperTimeWindow()) continue;
			// check if new label is feasible wrt demand
			int newDemand = currentLabel.getDemand() + nodes.get(i).getDemand();
			if (newDemand > ModelConstants.VEHICLE_CAPACITY) continue;
			int newCosts = (int)(currentLabel.getCosts() + reducedCostsMatCopy.getEntry(currentLabel.getNode()+1, i+1));
			Label l = new Label(newCosts, newDemand, newTime, i, currentLabel);

			// check if new label is dominated or dominates a label
			ArrayList<Label> labels = labelList.get(i);
			// different dominance criterion for the final node
			// only depends on the costs
			if (i == distmatCopy.getDimension()-1) {
				ArrayList<Label> finalLabel = labelList.get(distmatCopy.getDimension()-1);
				if (finalLabel.size() == 0) finalLabel.add(l);
				else if (finalLabel.get(0).getCosts() > l.getCosts()) {
					finalLabel.remove(0);
					finalLabel.add(l);
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
		getShortestPath(labels.get(index));
		ArrayList<Integer> path = new ArrayList<Integer>();		
		for (int i = shortestPath.size() - 1; i >= 0; i--) {
			path.add(shortestPath.get(i));
		}
		labels.remove(index);
		double costs = ModelHelperMethods.getRouteCostsIndexed0(distmatCopy, path);
		Path result = new Path(path, costs, reducedCosts, distmatCopy.getDimension());
		return result;
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
		
		public Label(double costs, int demand, int time, int node) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
		}
		
		public Label(double costs, int demand, int time, int node, Label predecessor) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
			this.predecessor = predecessor;
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
	}
}
