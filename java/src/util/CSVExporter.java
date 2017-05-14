package util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class CSVExporter {

	public static void writeEdges(String filepath, int[][] edges) throws FileNotFoundException {
		PrintWriter pw = new PrintWriter(new File(filepath));
        StringBuilder sb = new StringBuilder();
        sb.append("from");
        sb.append(",");
        sb.append("to");
        sb.append("\n");
        for (int i = 0; i < edges[0].length; i++) {
        	sb.append(edges[0][i]);
            sb.append(",");
        	sb.append(edges[1][i]);
            sb.append("\n");
        }
        
        pw.write(sb.toString());
        pw.close();
        System.out.println("Edges successfully written to file");
	}

	public static void writeNodes(String filepath, int[] nodes) throws FileNotFoundException {
		PrintWriter pw = new PrintWriter(new File(filepath));
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < nodes.length; i++) {
        	sb.append(nodes[i]);
            sb.append("\n");
        }
        
        pw.write(sb.toString());
        pw.close();
        System.out.println("Nodes successfully written to file");
	}

	public static void writeNodesWithGroups(String filepath, ArrayList<Integer> nodes, ArrayList<Integer> groups) throws FileNotFoundException {
		PrintWriter pw = new PrintWriter(new File(filepath));
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < nodes.size(); i++) {
        	sb.append(nodes.get(i));
        	sb.append(",");
        	sb.append(groups.get(i));
            sb.append("\n");
        }
        
        pw.write(sb.toString());
        pw.close();
        System.out.println("Nodes successfully written to file");
	}
}
