package day;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

public class RouteLengthsAnalyzer {

	public static void main(String[]args) throws IOException {
		// import route lengths
		String rootPath = new File("").getAbsolutePath();
		rootPath = rootPath.substring(0, rootPath.length() - 5);
		String filename = rootPath + "/results/days/RouteLengths.csv";
		
		BufferedReader reader = null;
		ArrayList<ArrayList<Double>> routeLengths = new ArrayList<ArrayList<Double>>();
		ArrayList<Double> timePoints = new ArrayList<Double>();
		try {
			reader = new BufferedReader(new FileReader(filename));
			String line = "";
			while ((line = reader.readLine()) != null) {
				String[] currentLine = line.split(",");
				timePoints.add(Double.parseDouble(currentLine[0]));
				ArrayList<Double> currentRouteLengths = new ArrayList<Double>();
				for (int i = 1; i < currentLine.length; i++) {
					currentRouteLengths.add(Double.parseDouble(currentLine[i]));
				}
				routeLengths.add(currentRouteLengths);
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
		
		ArrayList<Double> remainingRouteLengths = new ArrayList<Double>();

		FileWriter writer = new FileWriter(rootPath + "/results/days/nCars.csv", true);
		// now analyze the number of vehicles required
		for (int i = 0; i <= 43200+150*60; i+=60) {
			int counter = 0;
			int listLength = remainingRouteLengths.size();
			
			// decrement routes
			while (true) {
				if (counter == listLength) break;
				double j = remainingRouteLengths.get(0);
				remainingRouteLengths.remove(0);
				j -= 60;
				if (j > 0) remainingRouteLengths.add(j);
				counter++;
			}
			
			// add new routes
			if (timePoints.size() > 0  && timePoints.get(0) == i) {
				timePoints.remove(0);
				ArrayList<Double> currentRoutes = routeLengths.get(0);
				routeLengths.remove(0);
				for (double j : currentRoutes) remainingRouteLengths.add(j);
			}
			
			int nCars = remainingRouteLengths.size();
			writer.write(i + "," + nCars + "\n");		
		}
		writer.close();
	}	
}
