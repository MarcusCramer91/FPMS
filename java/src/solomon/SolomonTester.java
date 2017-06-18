package solomon;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;

import model.DistanceMatrix;
import model.Order;
import model.Vehicle;
import optimization.CPlexConnector;
import optimization.ModelHelperMethods;

public class SolomonTester {

	public static void main(String[] args) throws IOException {
		/**String[] solomonProblems = {"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c101.txt", 
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c102.txt", 
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c103.txt", 
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c104.txt", 
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c105.txt",
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c106.txt",
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c107.txt",
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c108.txt",
				"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c109.txt"};*/
		String[] solomonProblems = {"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r101.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r102.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r103.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r104.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r105.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r106.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r107.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r108.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r109.txt"};
		int[] problemSizes = {20,30,40,50};
		int[] vehicleNumbers = {2,3,4,5,6};
		
		for (String solomonPath : solomonProblems) {
			
			for (int nCustomers : problemSizes) {
				ArrayList<Object> solomon = SolomonImporter.importCSV(solomonPath, nCustomers);
				@SuppressWarnings("unchecked")
				ArrayList<Order> orders = (ArrayList<Order>)solomon.get(0);
				DistanceMatrix distanceMatrix = (DistanceMatrix)solomon.get(1);
				
				for (int nVehicles : vehicleNumbers) {
					ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
					for (int i = 0; i < nVehicles; i++) {
						Vehicle v = new Vehicle(i, 0, 9999);
						vehicles.add(v);
					}
					
					String problemInstance = solomonPath.split("\\\\")[solomonPath.split("\\\\").length-1];
					
					problemInstance = problemInstance.split("\\.")[0];
					System.out.println("Solving the following Solomon instance:" );
					System.out.println("Instance: " + problemInstance + "; number of customers: " + nCustomers + "; number of vehicles: " + nVehicles);
					
					int compTimeLimit = 300;
					int capacity = 200;
					
					ArrayList<ArrayList<Integer>> routes = CPlexConnector.getRoutesSolomon(distanceMatrix, orders, vehicles, 30, capacity,
							compTimeLimit, false, problemInstance);
					 // due to distance matrix adaptations in this case, new costs have to be calculated
					 // cplex objective costs are 10920 too high (for 4 vehicles)
					 //double costs = 0;
					 if (routes == null) continue;
					 for (ArrayList<Integer> route : routes) {
						 for (Integer i : route) System.out.print(i + "\t");
						 //int serviceTime = 90;
						 //costs += ModelHelperMethods.getRouteCostsSolomon(distanceMatrix, route, serviceTime);
						 System.out.println();
					 }
					 //System.out.println("Total costs: " + costs);
					 //System.out.println("Computation time: " + compTimeLimit);*/
				}
			}
		}
	}
}
