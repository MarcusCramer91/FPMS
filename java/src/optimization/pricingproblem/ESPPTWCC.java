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

/**
 * Solves an SPPTWCC via dynamic programming labeling approach
 * @author Marcus
 *
 */
public class ESPPTWCC {
	
	private ArrayList<Node> nodes;
	private ArrayList<ArrayList<Label>> labelList;
	private ArrayList<Label> nps;
	private DistanceMatrix distanceMatrix;
	private DistanceMatrix reducedCostsMatrix;
	private ArrayList<Integer> shortestPath;
	private int currentTime;
	private int dominanceCheckingTime;
	
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
		 ESPPTWCC spptwcc = new ESPPTWCC(distmat, reducedCostsMat, orders, 40*60);
		 spptwcc.labelNodes();
	}
	
	public ESPPTWCC(DistanceMatrix distmat, DistanceMatrix reducedCostsMat, ArrayList<Order> orders, int currentTime) {
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
		Label initialLabel = new Label(0,0,0,0);
		setReachableNodes(initialLabel);
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
		/**FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\LabelsGeneratedStandard.csv", true);
		writer.write(labelCount + "\n");
		writer.close();*/
		System.out.println("Labels created: " + labelCount);
		// compute the shortest path
		getShortestPath(labelList.get(distanceMatrix.getDimension()-1).get(0));
		ArrayList<Integer> path = new ArrayList<Integer>();
		
		//FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\paths.txt", true);
		
		
		for (int i = shortestPath.size() - 1; i > 0; i--) {
			path.add(shortestPath.get(i));
			//writer.write(shortestPath.get(i) + "->");
		}
		path.add(distanceMatrix.getDimension()-1);
		for (int i = 0; i < path.size()-1; i++) {
			System.out.print(path.get(i) + "->");
		}
		System.out.println(path.get(path.size()-1));
		
		//writer.write(distanceMatrix.getDimension() - 1 + "\n");
		//writer.close();
		
		
		System.out.println("Costs of the shortest path: " + labelList.get(distanceMatrix.getDimension()-1).get(0).getCosts());
		
		System.out.println("Time consumed: " + (System.currentTimeMillis() - time));
		double costs = getPathCosts(path);
		Path result = new Path(path, costs, labelList.get(distanceMatrix.getDimension()-1).get(0).getCosts(), 
				distanceMatrix.getDimension());
		return result;
	}

	private void labelNext(Label currentLabel) {
		
		// for all neighbors of the current label (which are all nodes)
		for (int i = 1; i < distanceMatrix.getDimension(); i++) {
			// skip nogo routes
			boolean[] reachableNodes = currentLabel.getReachableNodes();
			if (!reachableNodes[i]) continue;
			int newTime = (int)(currentLabel.getTime() + distanceMatrix.getEntry(currentLabel.getNode()+1, i+1));
			int newDemand = currentLabel.getDemand() + nodes.get(i).getDemand();
			int newCosts = (int)(currentLabel.getCosts() + reducedCostsMatrix.getEntry(currentLabel.getNode()+1, i+1));
			Label l = new Label(newCosts, newDemand, newTime, i, currentLabel, currentLabel.getReachableNodes(), 
					currentLabel.getNumberOfReachableNodes());
			
			// update reachable nodes
			setReachableNodes(l);

			// check if new label is dominated or dominates a label
			ArrayList<Label> labels = labelList.get(i);
			// different dominance criterion for the final node
			// only depends on the costs
			if (i == distanceMatrix.getDimension()-1) {
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
		// check if l2 has more reachable nodes first
		if (l2.getNumberOfReachableNodes() > l1.getNumberOfReachableNodes()) return false;
		
		// then assess reachable nodes individually
		for (int i = 0; i < l1.getReachableNodes().length; i++) {
			if (!l1.getReachableNodes()[i] && l2.getReachableNodes()[i]) {
				return false;
			}
		}	
		// if that is not the case, check for distances and costs and weight
		if (l1.getCosts() > l2.getCosts() || l1.getDemand() > l2.getDemand() || l1.getTime() > l2.getTime()) return false;
		return true;
	}
	
	private void setReachableNodes(Label currentLabel) {
		boolean[] newReachableNodes = new boolean[distanceMatrix.getDimension()];
		boolean[] previousReachableNodes = currentLabel.getReachableNodes();
		int numberOfReachableNodes = currentLabel.getNumberOfReachableNodes();
		// copy array
		for (int i = 0; i < newReachableNodes.length; i++) {
			newReachableNodes[i] = previousReachableNodes[i];
		}
		newReachableNodes[currentLabel.getNode()] = false;
		numberOfReachableNodes--;
		// update
		for (int i = 0; i < newReachableNodes.length; i++) {
			if (!newReachableNodes[i]) continue;
			// check if new label is feasible wrt time
			int newTime = (int)(currentLabel.getTime() + distanceMatrix.getEntry(currentLabel.getNode()+1, i+1));
			if (newTime > nodes.get(i).getUpperTimeWindow()) {
				newReachableNodes[i] = false;
				numberOfReachableNodes--;
				continue;
			}
			// check if new label is feasible wrt demand
			int newDemand = currentLabel.getDemand() + nodes.get(i).getDemand();
			if (newDemand > ModelConstants.VEHICLE_CAPACITY) {
				newReachableNodes[i] = false;
				numberOfReachableNodes--;
			}
		}
		
		currentLabel.setReachableNodes(newReachableNodes);
		currentLabel.setNumberOfReachableNodes(numberOfReachableNodes);
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
		private int numberOfReachableNodes;
		private boolean[] reachableNodes;
		
		public Label(double costs, int demand, int time, int node) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
			this.setNumberOfReachableNodes(distanceMatrix.getDimension()-1);
			setReachableNodes(new boolean[distanceMatrix.getDimension()]);
			for (int i = 0; i < reachableNodes.length; i++) {
				reachableNodes[i] = true;
			}
		}
		
		public Label(double costs, int demand, int time, int node, Label predecessor,
				boolean[] reachableNodes, int numberOfReachableNodes) {
			this.setCosts(costs);
			this.setDemand(demand);
			this.setTime(time);
			this.setNode(node);
			this.predecessor = predecessor;
			this.setNumberOfReachableNodes(numberOfReachableNodes);
			this.setReachableNodes(reachableNodes);
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

		public boolean[] getReachableNodes() {
			return reachableNodes;
		}

		public void setReachableNodes(boolean[] reachableNodes) {
			this.reachableNodes = reachableNodes;
		}
		
		public void setNumberOfReachableNodes(int n) {
			this.numberOfReachableNodes = n;
		}
		
		public int getNumberOfReachableNodes() {
			return this.numberOfReachableNodes;
		}
	}
}
