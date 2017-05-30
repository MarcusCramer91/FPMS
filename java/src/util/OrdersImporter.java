package util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import model.Order;

/**
 * 
 * @author Marcus
 * Imports longitudes and latitudes from a csv file and stores them in a two-dimensional array
 */
public class OrdersImporter {
	public static ArrayList<Order> importCSV(String filename) {
		BufferedReader reader = null;
		ArrayList<Order> orders = new ArrayList<Order>();
		try {
			reader = new BufferedReader(new FileReader(filename));
			String line = "";
			line = reader.readLine();
			while ((line = reader.readLine()) != null) {
				String[] currentLine = line.split(",");
				int id = Integer.parseInt(currentLine[0]);
				double weight = Double.parseDouble(currentLine[1]);
				int time = Integer.parseInt(currentLine[2]) * 60;
				int locationID = Integer.parseInt(currentLine[3]);
				Order o = new Order(id, time, weight, locationID);
				orders.add(o);
			}
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
		return orders;
	}
}
