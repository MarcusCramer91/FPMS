package optimization;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;

import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import util.DistanceMatrixImporter;
import util.OrdersImporter;

public class FPCalculator {

	public static void main(String[] args) throws Exception {
		for (int i = 20; i <= 90; i += 10) {
			for (int j = 1; j <= 10; j++) {
				String rootPath = new File("").getAbsolutePath();
				String id = "_" + i + "_" + j;
				 rootPath = rootPath.substring(0, rootPath.length() - 5);
				ArrayList<Order> orders = OrdersImporter.importCSV(rootPath + "\\data\\testcases\\Orders_"+i+"_"+j+".csv");
				DistanceMatrix distmat = new DistanceMatrix(
						 DistanceMatrixImporter.importCSV(rootPath + "\\data\\testcases\\TravelTimes_"+i+"_"+j+".csv"));
				DistanceMatrix distmatair = new DistanceMatrix(
						 DistanceMatrixImporter.importCSV(rootPath + "\\data\\testcases\\TravelTimes_"+i+"_"+j+".csv"));
				int currentTime = 30*60;		
				ArrayList<Order[]> initialPathsOrders = FPOptimize.assignRoutes(distmat, distmatair, orders, 99, currentTime, false, true);
				ArrayList<ArrayList<Integer>> initialPathsNodes = new ArrayList<ArrayList<Integer>>();
				double costs = 0;
				distmat = distmat.insertDummyDepotAsFinalNode();
				for (int k = 0; k < initialPathsOrders.size(); k++) {
					Order[] current = initialPathsOrders.get(k);
					ArrayList<Integer> currentList = new ArrayList<Integer>();
					currentList.add(0);
					for (Order o : current) {
						currentList.add(o.getDistanceMatrixLink()-1);
					}
					currentList.add(distmat.getDimension());
					costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, currentList);
					initialPathsNodes.add(currentList);			    
				}
			 FileWriter writer = new FileWriter(rootPath + "\\results\\fp\\fpResults100_tw90.csv", true);
			 writer.write(id + "," + initialPathsNodes.size() + "," + costs + "," + 
			 (costs + (i * ModelConstants.CUSTOMER_LOADING_TIME) + (initialPathsNodes.size() * ModelConstants.DEPOT_LOADING_TIME)) +
			 "\n");
		     writer.close();
			}
		}
	}
}
