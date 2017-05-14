package optimization;
import java.util.ArrayList;

import ilog.concert.*;
import ilog.cplex.*;
import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import util.CSVExporter;
import util.DistanceMatrixImporter;

public class CPlexConnector {
   
   static void displayResults(IloCplex cplex,
                              IloNumVar[] inside,
                              IloNumVar[] outside) throws IloException {
      System.out.println("cost: " + cplex.getObjValue());
   }
   
   public static void main( String[] args ) {
	   try {
		   
		 int nLocations = 32;
		 int[] timesRemaining = {0, 90,95,85,101,92,102,119,113,111,109,87,115,117,81,92,90,95,85,101,92,102,119,113,111,109,87,
				   111,113,81,92, 200}; // random arbitrary high number
		 int[] demands = {5,4,3,8,5,1,1,2,3,4,5,2,9,5,8,7,1,3,2,1,5,4,1,1,1,2,2,3,3,1};
		 int nCustomers = 30;
		   
		 int nVehicles = 4;
		 int capacity = 100;
		 int timeLimit = 150*60;
		 DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv"));
		 int compTimeLimit = 3600;
		 
		 // crop problem to 20 customers
		 /**
		 nLocations = 22;
		 nCustomers = 20;
		 nVehicles = 3;
		 int[] timesRemainingNew = new int[nLocations];
		 for (int i = 0; i < nLocations; i++) {
			 timesRemainingNew[i] = timesRemaining[i];
		 }
		 timesRemaining = timesRemainingNew;
		 int[] demandsNew = new int[nLocations];
		 for (int i = 0; i < nLocations; i++) {
			 demandsNew[i] = demands[i];
		 }
		 demands = demandsNew;
		 distmat = distmat.getCroppedMatrix(new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21});*/
		 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		 
		 ArrayList<ArrayList<Integer>> routes = CPlexConnector.getRoutes(nVehicles, nCustomers, nLocations, capacity, 
				 timeLimit, distmat, demands, timesRemaining, compTimeLimit, true);
		 
		 // due to distance matrix adaptations in this case, new costs have to be calculated
		 // cplex objective costs are 10920 too high (for 4 vehicles)
		 double costs = 0;
		 for (ArrayList<Integer> route : routes) {
			 for (Integer i : route) System.out.print(i + "\t");
			 costs += ModelHelperMethods.getRouteCosts(distmat, route);
			 System.out.println();
		 }

		 System.out.println("Total costs: " + costs);
		 System.out.println("Computation time: " + compTimeLimit);
		 
		 generateOutput(routes, compTimeLimit);
		 
	   }
	   catch (Exception e) {e.printStackTrace(); }
   }
   
   public static ArrayList<ArrayList<Integer>> getRoutes(int nVehicles, int nCustomers, int nLocations, int capacity, int timeLimit, 
		   DistanceMatrix distmat, int[] demands, int[] timesRemaining, int compTimeLimit, boolean verbose) {
	  try {

		 double shortestDistance = distmat.getShortestDistance();
		 distmat = distmat.insertDummyDepotAsFinalNode();
		 distmat = distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 distmat = distmat.addCustomerServiceTimes(ModelConstants.REALISTIC_CUSTOMER_LOADING_TIME);
		 double[][] distances = distmat.getTwoDimensionalArray();
		 // multiply times remaining by 60
		 for (int i = 0; i < timesRemaining.length; i++) {
			 timesRemaining[i] = timesRemaining[i] * 60;
		 }
		   
	     IloCplex cplex = new IloCplex();
         if (!verbose) cplex.setOut(null);
	     if (compTimeLimit > 0) cplex.setParam(IloCplex.DoubleParam.TiLim, compTimeLimit);
	     //cplex.setParam(IloCplex.DoubleParam.ObjLLim, Double.MAX_VALUE);
		 // Model according to Kallehauge et al. 2006
		 // build decision variables
	
		 IloNumVar[][][] x = new IloNumVar[nLocations][nLocations][];
		 for (int i = 0; i < nLocations; i++) {
			 for (int j = 0; j < nLocations; j++) {
				 x[i][j] = cplex.boolVarArray(nVehicles);
			 }
		 }
		 IloNumVar[][] s = new IloNumVar[nLocations][];
		 for (int i = 0; i < nLocations; i++) {
			 s[i] = cplex.intVarArray(nVehicles, 0, timeLimit);
		 }
		 
		 // build objective function with all costs and decision variables
		 // 3.1
	     IloLinearNumExpr obj = cplex.linearNumExpr();
		 
	     for (int k = 0; k < nVehicles; k++) {
	    	 for (int i = 0; i < nLocations; i++) {
	    		 for (int j = 0; j < nLocations; j++) {
	            	 obj.addTerm(distances[i][j],x[i][j][k]);
	    		 }
	    	 }
	     }
	     cplex.addMinimize(obj);
	   
	     // ensure that all customers are visited
	     // 3.2
	     for (int i = 1; i < (nCustomers+1); i++) {
	    	 IloLinearNumExpr expr = cplex.linearNumExpr();
	    	 for (int k = 0; k < nVehicles; k++) {
	    		 for (int j = 0; j < nLocations; j++) {
	    			 expr.addTerm(1.0, x[i][j][k]);
	    		 }
	    	 }
	    	 cplex.addEq(1.0, expr);
	     }
	     // ensure that the vehicle capacity is not exceeded
	     // 3.3
	     for (int k = 0; k < nVehicles; k++) {
	    	 IloLinearNumExpr expr = cplex.linearNumExpr();
	    	 for (int i = 1; i < (nCustomers+1); i++) {
	    		 for (int j = 0; j < nLocations; j++) {
	    			 expr.addTerm(demands[i-1], x[i][j][k]);
	    		 }
	    	 }
	    	 cplex.addLe(expr,capacity);
	     }
	
	     // ensure that all vehicles start at the depot
	     // 3.4
	     for (int k = 0; k < nVehicles; k++) {
	    	 IloLinearNumExpr expr = cplex.linearNumExpr();
	    	 for (int j = 1; j < (nCustomers + 1); j++) {
	    		 expr.addTerm(1.0, x[0][j][k]);
	    	 }
	    	 cplex.addEq(1.0, expr);
	     }
	     
	     /**
	     // ensure that vehicles cant to to the same customer again
		 IloLinearNumExpr expr0 = cplex.linearNumExpr();
	     for (int k = 0; k < nVehicles; k++) {
	    	 for (int i = 0; i < nLocations; i++) {
	    		 expr0.addTerm(1.0, x[i][i][k]);
	    	 }
	     }
	     cplex.addEq(0.0, expr0);*/
	
	     // ensure that vehicles leave a customer they arrive at
	     // 3.5
	     for (int h = 1; h < (nCustomers + 1); h++) {
	    	 for (int k = 0; k < nVehicles; k++) {
	        	 IloLinearNumExpr expr = cplex.linearNumExpr();
	        	 for (int i = 0; i < nLocations; i++) {
	        		 expr.addTerm(1.0, x[i][h][k]);
	        	 }
	        	 for (int j = 0; j < nLocations; j++) {
	        		 if (j != h) expr.addTerm(-1.0, x[h][j][k]);
	        	 }
	        	 cplex.addEq(0.0, expr);
	    	 }
	     }
	     // ensure that all vehicles end at the depot
	     // 3.6
	     for (int k = 0; k < nVehicles; k++) {
	    	 IloLinearNumExpr expr = cplex.linearNumExpr();
	    	 for (int i = 1; i < (nCustomers + 1); i++) {
	    		 expr.addTerm(1.0, x[i][nLocations-1][k]);
	    	 }
	    	 cplex.addEq(1.0, expr);
	     }
	     // linear version
	     // establish relationship between vehicle departure time from a customer and its successor
	     // 3.7
		 // determine M_ij
		 double maxValue = 0;
		 for (int p = 0; p < nLocations; p++) {
			 for (int q = 0; q < nLocations; q++) {
				 if (timesRemaining[p] + distances[p][q] > maxValue) maxValue = timesRemaining[p] + distances[p][q];
			 }
		 }
	     for (int i = 0; i < nLocations; i++) {
	    	 for (int j = 0; j < nLocations; j++) {
	        	 for (int k = 0; k < nVehicles; k++) {
	            	 IloLinearNumExpr expr = cplex.linearNumExpr();
	        		 expr.addTerm(1.0, s[i][k]);
	        		 expr.addTerm(-1.0, s[j][k]);
	        		 expr.addTerm(maxValue, x[i][j][k]);
	        		 cplex.addLe(expr, maxValue - distances[i][j]);
	        	 } 
	    	 }
	     }
	     
	     // ensure arrival within time horizon
	     // 3.8/
	     for (int i = 0; i < nLocations; i++) {
			 for (int k = 0; k < nVehicles; k++) {
	        	 IloLinearNumExpr expr = cplex.linearNumExpr();
	        	 expr.addTerm(1.0, s[i][k]);
	        	 cplex.addLe(s[i][k], timesRemaining[i]);
	        	// restrict the search space by setting the earliest arrival time to the corresponding distance to the depot
	        	 if (i != 0 && i != (nLocations-1)) cplex.addGe(s[i][k], distances[0][i]);
			 }
	     }
	          
	     cplex.solve();
	     System.out.println("Total distance: " + cplex.getObjValue());
	     ArrayList<ArrayList<Integer>> routes = buildRoutesFromCplex(nLocations, nVehicles, cplex, x);
	     
	     cplex.end();
	     return routes;
	     
	  }
	  catch (IloException exc) {
	     System.err.println("Concert exception '" + exc + "' caught");
	  }
	  return null;
   }
   
   private static ArrayList<ArrayList<Integer>> buildRoutesFromCplex(int nLocations, int nVehicles, IloCplex cplex, IloNumVar[][][] x) {
	   try {
		   ArrayList<ArrayList<Integer>> routes = new ArrayList<ArrayList<Integer>>();
		   boolean[][][] decision = new boolean[nLocations][nLocations][nVehicles];
		   int[] nodeCounts = new int[nVehicles];
		     for (int i = 0; i < nLocations; i++) {
		    	 for (int j = 0; j < nLocations; j++) {
		    		 for (int k = 0; k < nVehicles; k++) {
		    			 if (cplex.getValue(x[i][j][k]) > 0) {
		    				 decision[i][j][k] = true;
		    				 nodeCounts[k]++;
		    			 }
		    		 }
		    	 }
		     }
		     for (int k = 0; k < nVehicles; k++) {
		    	 // if empty trip from depot to depot is included, skip
		    	 //if (nodeCounts[k] == 2) continue;
		    	 // else get all the edges for this vehicle in the first step
		    	 int[][] edges = new int[2][nodeCounts[k]];
		    	 int counter = 0;
		    	 for (int i = 0; i < nLocations; i++) {
		    		 for (int j = 0; j < nLocations; j++) {
		    			 if (i == 19) {
		    				 int a = 0;
		    				 a++;
		    			 }
		    			 if (decision[i][j][k]) {
		    				 edges[0][counter] = i;
		    				 edges[1][counter] = j;
		    				 counter++;
		    			 }
		    		 }
		    	 }
		    	 // now connect the edges 
		    	 int[][] sortedEdges = new int[2][nodeCounts[k]];
		    	 // insert first connection
		    	 sortedEdges[0][0] = 0;
		    	 sortedEdges[1][0] = edges[1][0];
	    		 int currentSuccessor = edges[1][0];
		    	 for (int i = 0; i < nodeCounts[k]-1; i++) {
		    		 for (int j = 1; j < nodeCounts[k]; j++) {
		    			 if (edges[0][j] == currentSuccessor) {
		    				 sortedEdges[0][i+1] = currentSuccessor;
		    				 sortedEdges[1][i+1] = edges[1][j];
		    				 currentSuccessor = edges[1][j];
		    				 break;
		    			 }
		    		 }
		    	 }
		    	 // now take the first entry of the edges to build the route
		    	 ArrayList<Integer> route = new ArrayList<Integer>();
		    	 for (int i = 0; i < sortedEdges[0].length; i++) {
		    		 route.add(sortedEdges[0][i]+1);
		    	 }
		    	 
		    	 // add the final depot
		    	 route.add(1);
			     routes.add(route);
		     }
		     return routes;
	   }
	   catch (Exception e) {e.printStackTrace();}
	   return null;
   }
   
	
	private static void generateOutput(ArrayList<ArrayList<Integer>> routes, int compTimeLimit) throws Exception {
		ArrayList<Integer> nodeSequence = new ArrayList<Integer>();
		// add a group for plotting
		ArrayList<Integer> groups = new ArrayList<Integer>();
		for (int i = 0; i < routes.size(); i++) {
			for (int j = 0; j < routes.get(i).size(); j++) {
				nodeSequence.add(routes.get(i).get(j));
				groups.add(i+1);
			}
		}
		CSVExporter.writeNodesWithGroups("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy_30ExactSolution" + compTimeLimit + 
				"s.csv", nodeSequence, groups);
		
		String[] cmdarray = new String[6];
		//cmdarray[0] = "Rscript C:\\Users\\Marcus\\Documents\\FPMS\\source\\R\\TSPPlotting.R";
		cmdarray[0] = "\"C:\\Program Files\\R\\R-3.3.2\\bin\\Rscript.exe\"";
		cmdarray[1] = "C:\\Users\\Marcus\\Documents\\FPMS\\source\\R\\TSPPlotting.R";
		cmdarray[2] = "C:/Users/Marcus/Documents/FPMS/data/Dummy30Lonlats.csv";
		cmdarray[3] = "C:/Users/Marcus/Documents/FPMS/data/Dummy_30ExactSolution" + compTimeLimit + 
				"s.csv";
		cmdarray[4] = "fpApproach";
		cmdarray[5] = "C:/Users/Marcus/Documents/FPMS/images/autoGenerated/Dummy30_ExactSolution" + compTimeLimit + 
				"s";
		Process p = Runtime.getRuntime().exec(cmdarray);
	}
}
