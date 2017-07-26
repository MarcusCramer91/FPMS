package optimization;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;

import model.DistanceMatrix;
import model.Order;
import model.Vehicle;
import tsp.TSPExact;
import tsp.TSPExact2;
import tsp.TSPHeuristics;
import util.CSVExporter;

public class PPOptimize {

	/**
	 * Checks if optimization is due for the FP appraoch
	 * @param currentTime
	 * @param vehicles
	 * @param orders
	 * @return
	 */
	public static boolean checkOptimizationNecessity(int currentTime, ArrayList<Order> orders, int waitingTime) {
		for (Order o : orders) {
			if (o.getMET(currentTime) >= waitingTime * 60) {
				return true;
			}
		}
		return false;
	}
	
	public static ArrayList<Order[]> assignRoutes(DistanceMatrix distanceMatrix, DistanceMatrix airDistanceMatrix, 
			ArrayList<Order> orders, int nVehicles, int currentTime, boolean generateOutput, boolean correctMETs) throws Exception {
		// copy orders ArrayList (avoid call by reference updates)
		ArrayList<Order> ordersCopy = new ArrayList<Order>();
		ordersCopy.addAll(orders);
		ArrayList<Order[]> allRoutes = new ArrayList<Order[]>();
		
		// assign distance matrix link to the new cropped distance matrix
		ordersCopy.sort(new OrdersDistanceMatrixLinkSorter());
		for (int i = 0; i < ordersCopy.size(); i++) {
			ordersCopy.get(i).setActualDistanceMatrixLink(ordersCopy.get(i).getDistanceMatrixLink());
			ordersCopy.get(i).setDistanceMatrixLink(i+2);
		}
		
		for (int j = 0; j < nVehicles; j++) {
			int[] tspRoute = null;
			// if no more orders remain
			if (ordersCopy.isEmpty()) break;
			// add oldest order to current route and remove from orders copy
			Order oldestOrder = PPOptimize.getOldestOrder(ordersCopy);
			ordersCopy.remove(oldestOrder);
			Order[] sortedOrders = sortOrders(airDistanceMatrix, ordersCopy, oldestOrder, currentTime);
			ArrayList<Order> route = new ArrayList<Order>();
			route.add(oldestOrder);
			// store previous route as well in case the current route produces a route failure
			int[] previousTspRoute = new int[]{1,2,1};
			if (sortedOrders.length == 0) tspRoute = new int[]{1,2,1};
			for (int i = 0; i < sortedOrders.length; i++) {
				route.add(sortedOrders[i]);

				// use a new distance matrix for solving the tsp (only those elements on the route are of interest)
				DistanceMatrix croppedMatrix = new DistanceMatrix(distanceMatrix.getAllEntries());
				int[] routeIndices = new int[route.size() + 1];
				routeIndices[0] = 1;
				for (int k = 1; k <= route.size(); k++) {
					routeIndices[k] = route.get(k-1).getDistanceMatrixLink();
				}
				
				croppedMatrix = croppedMatrix.getCroppedMatrix(routeIndices);
				tspRoute = CPlexTSP.getRoute(croppedMatrix);
				
				Order[] tspRouteList = ModelHelperMethods.parseTSPOutput(tspRoute, route);
				
				// if time window cannot be kept anymore
				// correctMETs differentiates between: 
				// 1) Routes are set up so the MET of 120 is always kept
				// 2) Routes are set up so that the total route (except for the trip back to the depot) is <= 120
				// The latter is the actual (wrong) Flaschenpost approach
				
				if ((correctMETs && !ModelHelperMethods.checkTimeWindowAdherenceMET(distanceMatrix, tspRouteList, currentTime)) ||
						(!correctMETs && !ModelHelperMethods.checkTimeWindowAdherence(distanceMatrix, tspRouteList, currentTime))) {
					// remove last item from route
					route.remove(route.size()-1);
					// assign this route to the next vehicle in queue
					// tsp route used is the previous tsp route
					tspRoute = previousTspRoute;
					break;
				}
				// else remove this order from the ordersCopy list
				ordersCopy.remove(sortedOrders[i]);
				previousTspRoute = new int[tspRoute.length];
				System.arraycopy(tspRoute, 0, previousTspRoute, 0, tspRoute.length);
			}
			if (tspRoute == null) throw new Exception("Route failure with the current configuration");
			allRoutes.add(ModelHelperMethods.parseTSPOutput(tspRoute, route));
		}
		if (generateOutput) generateOutput(allRoutes);
		return(allRoutes);
	}
	
	private static Order getOldestOrder(ArrayList<Order> orders) {
		int oldestTime = Integer.MAX_VALUE;
		Order oldestOrder = null;
		for (int i = 0; i < orders.size(); i++) {
			if (orders.get(i).getTime() < oldestTime) {
				oldestTime = orders.get(i).getTime();
				oldestOrder = orders.get(i);
			}
		}
		return oldestOrder;
	}
	
	private static Order[] sortOrders(DistanceMatrix airDistanceMatrix, ArrayList<Order> orders, Order oldestOrder, 
			int currentTime) {
		
		// copy all other orders to a new ArrayList
		Order[] otherOrders = new Order[orders.size()];
		for (int i = 0; i < orders.size(); i++) {
			otherOrders[i] = orders.get(i);
		}
		ArrayIndexComparator comp = new ArrayIndexComparator(airDistanceMatrix, oldestOrder);
		Arrays.sort(otherOrders, comp);
		
		return otherOrders;
	}
	

	
	private static void generateOutput(ArrayList<Order[]> routes) throws Exception {
		ArrayList<Integer> nodeSequence = new ArrayList<Integer>();
		// add a group for plotting
		ArrayList<Integer> groups = new ArrayList<Integer>();
		for (int i = 0; i < routes.size(); i++) {
			// add depot
			nodeSequence.add(1);
			groups.add(i+1);
			for (int j = 0; j < routes.get(i).length; j++) {
				nodeSequence.add(routes.get(i)[j].getDistanceMatrixLink());
				groups.add(i+1);
			}
			// add depot
			nodeSequence.add(1);
			groups.add(i+1);
		}
		CSVExporter.writeNodesWithGroups("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy_30FPApproachSolution.csv", nodeSequence, groups);
		
		String[] cmdarray = new String[6];
		//cmdarray[0] = "Rscript C:\\Users\\Marcus\\Documents\\FPMS\\source\\R\\TSPPlotting.R";
		cmdarray[0] = "\"C:\\Program Files\\R\\R-3.3.2\\bin\\Rscript.exe\"";
		cmdarray[1] = "C:\\Users\\Marcus\\Documents\\FPMS\\source\\R\\TSPPlotting.R";
		cmdarray[2] = "C:/Users/Marcus/Documents/FPMS/data/Dummy30Lonlats.csv";
		cmdarray[3] = "C:/Users/Marcus/Documents/FPMS/data/Dummy_30FPApproachSolution.csv";
		cmdarray[4] = "fpApproach";
		cmdarray[5] = "C:/Users/Marcus/Documents/FPMS/images/autoGenerated/Dummy30_FPApproachSolutionSolution";
		Process p = Runtime.getRuntime().exec(cmdarray);
	}

	// compares two orders based on their air distance (or any other distance measure provided in a distance matrix)
	private static class ArrayIndexComparator implements Comparator<Order> {
		private DistanceMatrix distanceMatrix;
		private Order firstOrder;
		
		public ArrayIndexComparator(DistanceMatrix distanceMatrix, Order firstOrder) {
			this.distanceMatrix = distanceMatrix;
			this.firstOrder = firstOrder;
		}
		
		@Override
		public int compare(Order o1, Order o2) {
			double firstDistance = distanceMatrix.getEntry(firstOrder.getDistanceMatrixLink(), o1.getDistanceMatrixLink());
			double secondDistance = distanceMatrix.getEntry(firstOrder.getDistanceMatrixLink(), o2.getDistanceMatrixLink());			
			if (firstDistance < secondDistance) return -1;
			else return 1;
		}
	}

	// compares two orders based on their air distance (or any other distance measure provided in a distance matrix)
	private static class OrdersDistanceMatrixLinkSorter implements Comparator<Order> {
		
		public OrdersDistanceMatrixLinkSorter() {
		}
		
		@Override
		public int compare(Order o1, Order o2) {
			if (o1.getDistanceMatrixLink() < o2.getDistanceMatrixLink()) return -1;
			else return 1;
		}
	}
}
