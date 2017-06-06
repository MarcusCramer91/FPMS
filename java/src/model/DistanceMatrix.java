package model;

import java.util.ArrayList;
import java.util.Arrays;

public class DistanceMatrix {

	private double[] entries;
	private int dimension;
	
	public DistanceMatrix(int dimension) {
		entries = new double[dimension*dimension];
		this.dimension = dimension;
	}
	
	public DistanceMatrix(double[] entries) {
		this.entries = entries;
		this.dimension = (int)Math.round(Math.sqrt(entries.length));
	}
	
	public double getEntry(int row, int column) {
		int dimension = this.getDimension();
		return entries[(row-1) * dimension + column - 1]; // subtract 1 as arrays start with index 0
	}
	
	public double[] getRow(int row) {
		double[] result = new double[this.getDimension()];
		int counter = 0;
		for (int i = (row - 1) * this.getDimension(); i < row * this.getDimension(); i++) {
			result[counter] = entries[i];
			counter++;
		}
		return result;
	}
	
	public double getShortestDistance() {
		double shortest = Double.MAX_VALUE;
		int counter = 0;
		for (int i = 0; i < this.getDimension(); i++) {
			for (int j = 0; j < this.getDimension(); j++) {
				if (i != j && entries[counter] < shortest) shortest = entries[counter];
				counter++;
			}
		}
		return shortest;
	}
	
	public double[] getColumn(int column) {
		double[] result = new double[this.getDimension()];
		int counter = 0;
		for (int i = (column-1); i < this.getDimension()*this.getDimension(); i = i + this.getDimension()) {
			result[counter] = entries[i];
			counter++;
		}
		return result;
	}
	
	
	public DistanceMatrix getCroppedMatrix(int[] relevantEntries) {
		int[] sortedRelevantEntries = new int[relevantEntries.length];
		for (int i = 0; i < relevantEntries.length; i++) {
			sortedRelevantEntries[i] = relevantEntries[i];
		}
		Arrays.sort(sortedRelevantEntries);
		double[] newEntries = new double[sortedRelevantEntries.length * sortedRelevantEntries.length];
		int counter = 0;
		for (int i = 0; i < sortedRelevantEntries.length; i++) {
			for (int j = 0; j < sortedRelevantEntries.length; j++) {
				newEntries[counter] = this.getEntry(sortedRelevantEntries[i], sortedRelevantEntries[j]);
				counter++;
			}
		}
		DistanceMatrix res = new DistanceMatrix(newEntries);
		return res;
	}
	
	/**
	 * counting from 1
	 * @param entry
	 * @param row
	 * @param column
	 */
	public void setEntry(double entry, int row, int column) {
		int dimension = this.getDimension();
		if (row == column) new Exception("Row index must not be equal to column index"); // diagonal zero
		else {
			entries[(row-1) * dimension + column - 1] = entry; // subtract 1 as arrays start with index 0
		}
	}
	
	public double[] getAllEntries() {
		return this.entries;
	}
	
	public int getDimension() {
		return this.dimension;
	}
	
	/**
	 * Removes all row and column elements of the entry to be cut
	 * @param entry
	 * @return
	 */
	public DistanceMatrix cutEntry(int entry) {
		int dimension = this.getDimension();
		DistanceMatrix result = new DistanceMatrix(dimension-1);
		ArrayList<Double> newEntries = new ArrayList<Double>();
		for (int i = 0; i < entries.length; i++) {
			if ((i % dimension != (entry+1)) && ((i < ((entry-1) * dimension)) || (i >= entry * dimension))) newEntries.add(entries[i]);
		}
		double[] newEntriesArray = new double[newEntries.size()];
		for (int i = 0; i < newEntries.size(); i++) {
			newEntriesArray[i] = newEntries.get(i);
		}
		return new DistanceMatrix(newEntriesArray);
	}
	
	public int getNumberOfPotentialPaths() {
        int fact = 1; // this  will be the result
        for (int i = 1; i < this.dimension; i++) {
            fact *= i;
        }
        return fact;
    }
	
	public double[][] getTwoDimensionalArray() {
		double[][] res = new double[this.dimension][this.dimension];
		int counter = 0;
		for (int i = 0; i < dimension; i++) {
			for (int j = 0; j < dimension; j++) {
				res[i][j] = this.entries[counter];
				counter++;
			}
		}
		return res;
	}
	
	public DistanceMatrix insertDummyDepotAsFinalNode() {
		double[] newDistances = new double[(dimension+1)*(dimension+1)];
		int counter = 0;
		int counter2 = 0;
		int i;
		for (i = 0; i < newDistances.length-(dimension+1); i++) {
			if ((i+1) % (dimension+1) == 0) {
				newDistances[i] = entries[counter2];
				counter2 += dimension;
			}
			else newDistances[i] = entries[counter++];
		}
		counter = 0;
		for (; i < newDistances.length-1; i++) {
			newDistances[i] = entries[counter++];
		}
		newDistances[newDistances.length-1] = 0;
		return new DistanceMatrix(newDistances);
	}
	
	public DistanceMatrix addDepotLoadingTime(int loadingTime) {
		for (int i = 0; i < dimension; i++) {
			entries[i] = entries[i] + loadingTime;
		}
		return new DistanceMatrix(entries);
	}
	
	public DistanceMatrix addCustomerServiceTimes (int serviceTime) {
		for (int i = dimension; i < dimension * dimension; i++) {
			entries[i] = entries[i] + serviceTime;
		}
		return new DistanceMatrix(entries);
	}
	
	public double getShortestTripFromDepot() {
		double shortest = Double.MAX_VALUE;
		for (double d : entries) {
			if (d < shortest) shortest = d;
		}
		return shortest;
	}
	
	public double getLongestTripFromDepot() {
		double longest = 0;
		for (double d : entries) {
			if (d > longest) longest = d;
		}
		return longest;
	}
	
	public void setDiagonalToInfinity() {
		int counter = 0;
		for (int i = 0; i < dimension; i++) {
			for (int j = 0; j < dimension; j++) {
				if (i == j) entries[counter] = Double.MAX_VALUE;
				counter++;
			}
		}
	}
	
	public DistanceMatrix subtractDuals(double[] duals) {
		for (int i = 0; i < duals.length; i++) {
			for (int j = i; j < entries.length; j += dimension) {
				entries[j] -= duals[i];
			}
		}
		DistanceMatrix distmat = new DistanceMatrix(entries);
		return distmat;
	}
	
}
