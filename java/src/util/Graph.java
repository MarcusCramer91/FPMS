package util;

import java.util.ArrayList;

public class Graph {

	private int[][] edges;
	private Node[] nodes;
	
	public Graph(int[][] edges) {
		this.edges = edges;
		ArrayList<Integer> nodeIndices = new ArrayList<Integer>();
		for (int i = 0; i < edges[0].length; i++) {
			if (!nodeIndices.contains(edges[0][i])) nodeIndices.add(edges[0][i]);
			if (!nodeIndices.contains(edges[1][i])) nodeIndices.add(edges[1][i]);
		}
		
		// generate all nodes
		nodes = new Node[nodeIndices.size()];
		for (int i = 0; i < nodes.length; i++) {
			Node node = new Node(nodeIndices.get(i));
			nodes[i] = node;
		}
		
		// generate neighbor structure
		for (int i = 0; i < nodes.length; i++) {
			ArrayList<Integer> temp = this.getNeighbors(nodes[i].getIndex());
			Node[] neighbors = new Node[temp.size()];
			int counter = 0;
			for (int j = 0; j < neighbors.length; j++) {
				for (int k = 0; k < nodes.length; k++) {
					if (nodes[k].getIndex() == temp.get(j)) {
						neighbors[counter] = nodes[k];
						counter++;
					}
				}
			}
		}
	}
	
	public ArrayList<Integer> getNeighbors(int nodeIndex) {
		ArrayList<Integer> neighbors = new ArrayList<Integer>();
		for (int i = 0; i < edges[0].length; i++) {
			if (edges[0][i] == nodeIndex) neighbors.add(edges[1][i]);
		}
		return neighbors;
	}
	
	private class Node {
		Node[] neighbors;
		int index;

		public Node(int index) {
			this.index = index;
		}
		
		public Node(Node[] neighbors, int index) {
			this.neighbors = neighbors;
			this.index = index;
		}
		
		public int getIndex() {
			return index;
		}
		
		@Override
		public boolean equals(Object other) {
			if (!(other instanceof Node)) return false;
			if (((Node)other).getIndex() == this.getIndex()) return true;
			return false;
		}
	}
}
