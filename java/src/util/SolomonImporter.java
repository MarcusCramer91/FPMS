package util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import model.DistanceMatrix;
import model.Order;
import model.Vehicle;

public class SolomonImporter {

	//private static String[] paths = {"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\101"};
	
	public static ArrayList<Object> importCSV(String filename, int numberOfCustomers) {
		BufferedReader reader = null;
		ArrayList<Integer> locationX = new ArrayList<Integer>();
		ArrayList<Integer> locationY = new ArrayList<Integer>();
		ArrayList<Integer> demand = new ArrayList<Integer>();
		ArrayList<Integer> ready = new ArrayList<Integer>();
		ArrayList<Integer> due = new ArrayList<Integer>();
		ArrayList<Object> result = new ArrayList<Object>();
		int serviceTime = 0;
		try {
			reader = new BufferedReader(new FileReader(filename));
			String line = "";
			
			// first 10 lines are problem description
			for (int i = 0; i < 9; i++) {
				reader.readLine();
			}
			int counter = 0;
			while ((line = reader.readLine()) != null) {
				String[] currentLine = line.split(" ");
				ArrayList<Integer> lineElements = new ArrayList<Integer>();
				for (int i = 0; i < currentLine.length; i++) {
					try {
						lineElements.add(Integer.parseInt(currentLine[i]));
					}
					catch(Exception e) {};
				}
				locationX.add(lineElements.get(1));
				locationY.add(lineElements.get(2));
				demand.add(lineElements.get(3));
				ready.add(lineElements.get(4));
				due.add(lineElements.get(5));
				serviceTime = lineElements.get(6);
				counter++;
				if (counter > numberOfCustomers) break;
			}
			
			// compute orders
			ArrayList<Order> orders = new ArrayList<Order>();
			for (int i = 1; i < locationX.size(); i++) {
				Order o = new Order(1, ready.get(i), due.get(i), demand.get(i), i+1);
				orders.add(o);
			}
			result.add(orders);
			
			// compute distance matrix
			counter = 0;
			double[] distances = new double[locationX.size() * locationY.size()];
			for (int i = 0; i < locationX.size(); i++) {
				for (int j = 0; j < locationY.size(); j++) {
					double currentDistance = Math.sqrt(Math.pow(locationX.get(i) - locationX.get(j), 2) + Math.pow(locationY.get(i) - locationY.get(j), 2));
					if (i != 0 && i != j) currentDistance += serviceTime;
					distances[counter++] = currentDistance;
				}
			}
			/**
			PrintWriter writer = new PrintWriter(new File("C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c109Distmat.csv"));
			counter = 0;
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < locationX.size();i++) {
				for (int j = 0; j < locationY.size(); j++) {
					sb.append(distances[counter++]);
					sb.append(",");
				}
				sb.append("\n");
			}
			writer.write(sb.toString());
			writer.close();*/
			DistanceMatrix distmat = new DistanceMatrix(distances);
			result.add(distmat);
			return result;
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		finally {
			if (reader != null) {
				try {
					reader.close();
				}
				catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}
}
