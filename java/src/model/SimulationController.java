package model;

import java.util.ArrayList;

import optimization.FPOptimize;
import optimization.ModelHelperMethods;
import util.DistanceMatrixImporter;
import util.OrdersImporter;
import util.VehiclesImporter;

public class SimulationController {

	private int startTime = 0;
	private int lastOrderTime = 720; // simulated from 9 a.m. to 9 p.m. every minute
	private ArrayList<Order> orders;
	private ArrayList<Vehicle> vehicles;
	private DistanceMatrix distanceMatrix;
	private DistanceMatrix airDistanceMatrix;

	private static String distanceMatrixFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv";
	private static String airDistanceMatrixFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30AirDistances.csv";
	private static String ordersFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\DummyOrders_30.csv";
	private static String vehiclesFile = "C:\\Users\\Marcus\\Documents\\FPMS\\data\\DummyVehicles.csv";
	
	private static String mode = "fp";
	
	public static void main(String[] args) throws Exception {
		SimulationController controller = new SimulationController(SimulationController.distanceMatrixFile, SimulationController.airDistanceMatrixFile,
				SimulationController.ordersFile, SimulationController.vehiclesFile);
		controller.testOneIteration(40);
	}
	
	public SimulationController(String distanceMatrixFile, String ordersFile, String vehiclesFile) {
		distanceMatrix = new DistanceMatrix(DistanceMatrixImporter.importCSV(distanceMatrixFile));
		orders = OrdersImporter.importCSV(ordersFile);
		vehicles = VehiclesImporter.importCSV(vehiclesFile);
	}
	
	public SimulationController(String distanceMatrixFile, String airDistanceMatrixFile, String ordersFile, String vehiclesFile) {
		distanceMatrix = new DistanceMatrix(DistanceMatrixImporter.importCSV(distanceMatrixFile));
		airDistanceMatrix = new DistanceMatrix(DistanceMatrixImporter.importCSV(airDistanceMatrixFile));
		orders = OrdersImporter.importCSV(ordersFile);
		vehicles = VehiclesImporter.importCSV(vehiclesFile);
	}
	
	private void testOneIteration(int currentTime) throws Exception {
		
		// Crop problem to 20 customers and 3 vehicles
		distanceMatrix = distanceMatrix.getCroppedMatrix(new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21});
		airDistanceMatrix = airDistanceMatrix.getCroppedMatrix(new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21});
		for (int i = 0; i < 10; i ++) {
			orders.remove(20);
		}
		vehicles.remove(3);
		// +++++++++++++++++++++++++++++++++++++++++++++++++++
		
		for (Order o : orders) {
			o.setStatus(1);
		}
		if (mode.equals("fp")) {
			System.out.println("Routing step due: " + FPOptimize.checkOptimizationNecessity(currentTime, vehicles, orders));
			ArrayList<Order[]> routes = FPOptimize.assignRoutes(distanceMatrix, airDistanceMatrix, orders, vehicles, currentTime, true);
			for (int i = 0; i < routes.size(); i++) {
				System.out.println("Route for vehicle " + i);
				System.out.print("1->");
				for (int j = 0; j < routes.get(i).length-1; j++) {
					System.out.print(routes.get(i)[j].getDistanceMatrixLink() + "->");
				}
				System.out.println(routes.get(i)[routes.get(i).length-1].getDistanceMatrixLink());
			}
			double costs = 0;
			for (Order[] route : routes) {
				costs += ModelHelperMethods.getRouteCosts(distanceMatrix, route);
			}
			System.out.println("Total costs: " + costs);
		}
	}
}
