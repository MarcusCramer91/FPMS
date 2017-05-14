package util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/**
 * 
 * @author Marcus
 * Imports longitudes and latitudes from a csv file and stores them in a two-dimensional array
 */
public class LonLatImporter {
	public static ArrayList<double[]> importCSV(String filename) {
		BufferedReader reader = null;
		ArrayList<double[]> entries = new ArrayList<double[]>();
		try {
			reader = new BufferedReader(new FileReader(filename));
			String line = "";
			int lonColumn = -1;
			int latColumn = -1;
			while ((line = reader.readLine()) != null) {
				String[] currentLine = line.split(",");
				
				// determine which column stores longitudes and which one latitudes
				if (lonColumn == - 1) {
					if (currentLine[0].equals("lon")) {
						lonColumn = 0;
						latColumn = 1;
					}
					else {
						lonColumn = 1;
						latColumn = 0;
					}
					continue;
				}
				double[] temp = new double[2];
				temp[0] = Double.parseDouble(currentLine[latColumn]);
				temp[1] = Double.parseDouble(currentLine[lonColumn]);
				entries.add(temp);
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
		return entries;
	}
}
