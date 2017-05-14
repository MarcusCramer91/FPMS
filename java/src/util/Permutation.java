package util;

import java.util.ArrayList;

public class Permutation {
	private ArrayList<int[]> permutations;
	private int[] entries;
	
	public Permutation(int[] entries) {
		permutations = new ArrayList<int[]>();
		this.entries = entries;
	}
	
	public void generatePermutations(int[] currentPermutations, int[] currentEntries) {
		if (currentEntries.length == 1) {
			currentPermutations[currentPermutations.length-1] = currentEntries[0];
			permutations.add(currentPermutations);
		}
		else {
			for (int i = 0; i < currentEntries.length; i++) {
				
				// copy new element to permutations
				int[] newCurrentPermutations = new int[entries.length];
				int counter = 0;
				int j;
				for (j = 0; j < currentPermutations.length; j++) {
					if (currentPermutations[j] == 0) break;
					newCurrentPermutations[counter] = currentPermutations[j];
					counter++;
				}
				newCurrentPermutations[j] = currentEntries[i];
				
				// remove current element from current entries
				int[] newCurrentEntries = new int[currentEntries.length-1];
				counter = 0;
				for (j = 0; j < currentEntries.length; j++) {
					if (currentEntries[j] != currentEntries[i]) {
						newCurrentEntries[counter] = currentEntries[j];
						counter++;
					}
				}
				generatePermutations(newCurrentPermutations, newCurrentEntries);
			}
		}
	}
	
	public ArrayList<int[]> getPermutations() {
		return this.permutations;
	}
}
