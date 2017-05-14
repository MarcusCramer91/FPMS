package util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import model.Order;
import model.Vehicle;

/**
 * 
 * @author Marcus
 * Imports longitudes and latitudes from a csv file and stores them in a two-dimensional array
 */
public class VehiclesImporter {
	public static ArrayList<Vehicle> importCSV(String filename) {
		BufferedReader reader = null;
		ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
		try {
			reader = new BufferedReader(new FileReader(filename));
			String line = "";
			line = reader.readLine();
			while ((line = reader.readLine()) != null) {
				String[] currentLine = line.split(",");
				int id = Integer.parseInt(currentLine[0]);
				int availability = Integer.parseInt(currentLine[1]);
				int unavailability = Integer.parseInt(currentLine[1]);
				Vehicle v = new Vehicle(id, availability, unavailability);
				vehicles.add(v);
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
		return vehicles;
	}
}
