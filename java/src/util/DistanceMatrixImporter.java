package util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * 
 * @author Marcus
 * Imports a distance matrix containing double elements from a csv file (separated by commas)
 * Does not use any error handling and expects correct formatting of the matrix
 */
public class DistanceMatrixImporter {
	
	public static double[] importCSV(String filename) {
		BufferedReader reader = null;
		ArrayList<Double> entries = new ArrayList<Double>();
		try {
			reader = new BufferedReader(new FileReader(filename));
			String line = "";
			while ((line = reader.readLine()) != null) {
				String[] currentLine = line.split(",");
				for (String s : currentLine) {
					entries.add(Double.parseDouble(s));
				}
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
		
		System.out.println("Successfully imported a distance matrix of dimension " + 
				Math.round(Math.sqrt(entries.size())) + "*" + Math.round(Math.sqrt(entries.size())));
		double[] res = new double[entries.size()];
		for (int i = 0; i < entries.size(); i++) {
			res[i] = entries.get(i);
		}
		return res;
	}
}
