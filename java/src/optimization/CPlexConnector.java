package optimization;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

import ilog.concert.*;
import ilog.cplex.*;
import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import model.Vehicle;
import util.CSVExporter;
import util.DistanceMatrixImporter;

public class CPlexConnector {
   
   static void displayResults(IloCplex cplex,
                              IloNumVar[] inside,
                              IloNumVar[] outside) throws IloException {
      System.out.println("cost: " + cplex.getObjValue());
   }
   
   /**
   public static void main( String[] args ) {
	   try {
		   
		 int nLocations = 32;
		 int[] timesRemaining = {0, 90,95,85,101,92,102,119,113,111,109,87,115,117,81,92,90,95,85,101,92,102,119,113,111,109,87,
				   111,113,81,92,200}; // random arbitrary high number

		 // multiply times remaining by 60
		 for (int i = 0; i < timesRemaining.length; i++) {
			 timesRemaining[i] = timesRemaining[i] * 60;
		 }
		   
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
		 distmat = distmat.getCroppedMatrix(new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21});
		 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		 
		 ArrayList<ArrayList<Integer>> routes = CPlexConnector.getRoutes(nVehicles, nCustomers, nLocations, capacity, 
				 timeLimit, distmat, demands, timesRemaining, compTimeLimit, false);
		 
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
 * @throws FileNotFoundException */
   
   
   public static ArrayList<ArrayList<Integer>> getRoutes(DistanceMatrix distmat, ArrayList<Order> orders, int nVehicles, 
		   int currentTime, int compTimeLimit, boolean verbose, 
		   double[][][] initial, double upperBound, boolean useMaxRoute, boolean useEarliestArrival) throws FileNotFoundException {
	  try {

		 distmat = distmat.insertDummyDepotAsFinalNode();
		 distmat = distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 distmat = distmat.addCustomerServiceTimes(ModelConstants.REALISTIC_CUSTOMER_LOADING_TIME);
		 double[][] distances = distmat.getTwoDimensionalArray();
		 
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 
	     IloCplex cplex = new IloCplex();
	     cplex.use(new CPlexLogger("CramerInstance_30_4"));
		 //cplex.setParam(IloCplex.Param.MIP.Strategy.NodeSelect, 1); //0 = depth first, 1 = best-bound, 2 = best-estimate, 3 = alternative
		 //cplex.setParam(IloCplex.Param.MIP.Strategy.Branch,1); //-1 = down branch selected first, 0 let CPLEX choose, 1 = up branch selected fist
         if (!verbose) cplex.setOut(null);
	     if (compTimeLimit > 0) cplex.setParam(IloCplex.DoubleParam.TiLim, compTimeLimit);
	     if (upperBound > 0) {
	    	 upperBound += nCustomers * ModelConstants.CUSTOMER_LOADING_TIME;
	    	 upperBound += nVehicles * ModelConstants.DEPOT_LOADING_TIME;
	    	 cplex.setParam(IloCplex.DoubleParam.CutUp, upperBound);
	    	 System.out.println("Starting with an upper bound of " + upperBound);
	     }
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
			 s[i] = cplex.intVarArray(nVehicles, 0, ModelConstants.TIME_WINDOW+30*60);
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
	     	     
	     if (initial != null) {
		     // add starting solution
		     IloNumVar[] helper = new IloNumVar[nLocations * nLocations * nVehicles];
			 double[] flattenedInitial = new double[nLocations * nLocations * nVehicles];
			 // flatten initial solution
			 int counter = 0;
		        for (int i = 0; i < nLocations; i++) {
		            for (int j = 0; j < nLocations; j++) {
		                for (int k = 0; k < nVehicles; k++) {
		                    helper[counter] = x[i][j][k];
		                    flattenedInitial[counter] = initial[i][j][k];
		                    counter++;
		                }
		            }
		        }
		        cplex.addMIPStart(helper, flattenedInitial);
	     }
	     
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
	    			 expr.addTerm(orders.get(i-1).getWeight(), x[i][j][k]);
	    		 }
	    	 }
	    	 cplex.addLe(expr,ModelConstants.VEHICLE_CAPACITY);
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
	     
	     //TODO allow vehicles to go to the end depot directly
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
	     int[] timesRemaining = new int[nLocations];
	     timesRemaining[0] = 0;
	     for (int i = 1; i < nCustomers+1; i++) {
	    	 timesRemaining[i] = ModelConstants.TIME_WINDOW - orders.get(i-1).getMET(currentTime);
	     }
	     timesRemaining[timesRemaining.length-1] = ModelConstants.TIME_WINDOW + 30*60;
		 double maxValue = 0;
		 for (int p = 0; p < nLocations; p++) {
			 for (int q = 0; q < nLocations; q++) {
				 if (timesRemaining[p] == ModelConstants.TIME_WINDOW + 30*60) continue;
				 if (timesRemaining[p] + distances[p][q] > maxValue) maxValue = timesRemaining[p] + distances[p][q];
			 }
		 }
	     for (int i = 0; i < nLocations-1; i++) {
	    	 for (int j = 0; j < nLocations-1; j++) {
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
	     for (int i = 1; i < nLocations-1; i++) {
			 for (int k = 0; k < nVehicles; k++) {
	        	 IloLinearNumExpr expr = cplex.linearNumExpr();
	        	 expr.addTerm(1.0, s[i][k]);
	        	 cplex.addLe(s[i][k], timesRemaining[i]);
	        	// restrict the search space by setting the earliest arrival time to the corresponding distance to the depot
	        	if (useEarliestArrival) cplex.addGe(s[i][k], distances[0][i]);
			 }
	     }
	     
	     if (useMaxRoute) {
		     // set the maximum tour length to the following:
		     // compute the longest tour possible in terms of customers visited (take those with the shortest distances for that)
		     // and the time limit and the smallest MET
		     // and set the sum of decision variables for all vehicles to that number
		     int maximumTourLength = ModelHelperMethods.getMaximumNumberOfCustomers(distmat, orders) + 1; // add one for the final trip back to the depot
		     for (int k = 0; k < nVehicles; k++) {
	        	 IloLinearNumExpr expr = cplex.linearNumExpr();
		    	 for (int i = 0; i < nLocations; i++) {
		    		 for (int j = 0; j < nLocations; j++) {
		            	 expr.addTerm(x[i][j][k], 1.0);
		    		 }
		    	 }
		    	 cplex.addLe(expr, maximumTourLength);
		     } 
	     }
	     
		 // ensure that no tour arrives at node 0
		 for (int k = 0; k < nVehicles; k++) {
			 IloLinearNumExpr expr = cplex.linearNumExpr();
			 for (int i = 0; i < nLocations; i++) {
				 expr.addTerm(1.0, x[i][0][k]);
			 }
			 cplex.addEq(0.0, expr);
		 }
		 
		 // ensure that no tour leaves the last node
		 for (int k = 0; k < nVehicles; k++) {
			 IloLinearNumExpr expr = cplex.linearNumExpr();
			 for (int i = 0; i < nLocations; i++) {
				 expr.addTerm(1.0, x[nLocations-1][i][k]);
			 }
			 cplex.addEq(0.0, expr);
		 }
	          
	     cplex.solve();
	     ArrayList<ArrayList<Integer>> routes = buildRoutesFromCplex(nLocations, nVehicles, cplex, x);
	     
	     cplex.end();
	     return routes;
	     
	  }
	  catch (IloException exc) {
	     System.err.println("Concert exception '" + exc + "' caught");
	  }
	  return null;
   }
   
   public static ArrayList<ArrayList<Integer>> getRoutesSolomon(DistanceMatrix distmat, ArrayList<Order> orders, 
		   ArrayList<Vehicle> vehicles, int currentTime, int vehicleCapacity, int compTimeLimit, boolean verbose,
		   String problemInstancePath) throws IOException {
	  try {

		 double shortestDistance = distmat.getShortestDistance();
		 
		 
		 distmat = distmat.insertDummyDepotAsFinalNode();
		 double[][] distances = distmat.getTwoDimensionalArray();
		 
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 int nVehicles = 0;
		 for (Vehicle v : vehicles) if (v.isAvailable()) nVehicles++;
		 
	     IloCplex cplex = new IloCplex();
	     cplex.use(new CPlexLogger("solomon/" + problemInstancePath + "_" + nLocations + "_" + nVehicles));
		 cplex.setParam(IloCplex.Param.MIP.Strategy.NodeSelect, 1);
		 cplex.setParam(IloCplex.Param.MIP.Strategy.Branch,1);
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
			 s[i] = cplex.intVarArray(nVehicles, 0, Integer.MAX_VALUE);
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
	    			 expr.addTerm(orders.get(i-1).getWeight(), x[i][j][k]);
	    		 }
	    	 }
	    	 cplex.addLe(expr,vehicleCapacity);
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
	     int[] timesRemaining = new int[nLocations-1];
	     timesRemaining[0] = 0;
	     for (int i = 1; i < nCustomers+1; i++) {
	    	 timesRemaining[i] = orders.get(i-1).getLatest();
	     }

	     int[] earliestArrival = new int[nLocations-1];
	     earliestArrival[0] = 0;
	     for (int i = 1; i < nCustomers+1; i++) {
	    	 earliestArrival[i] = orders.get(i-1).getEarliest();
	     }
	    
		 double maxValue = 0;
		 for (int p = 0; p < nLocations-1; p++) {
			 for (int q = 0; q < nLocations-1; q++) {
				 if (timesRemaining[p] + distances[p][q] > maxValue) maxValue = timesRemaining[p] + distances[p][q];
			 }
		 }
	     for (int i = 0; i < nLocations-1; i++) {
	    	 for (int j = 0; j < nLocations-1; j++) {
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
	     for (int i = 1; i < nLocations-1; i++) {
			 for (int k = 0; k < nVehicles; k++) {
	        	 IloLinearNumExpr expr = cplex.linearNumExpr();
	        	 expr.addTerm(1.0, s[i][k]);
	        	 cplex.addLe(s[i][k], timesRemaining[i]);
	        	 cplex.addLe(earliestArrival[i], s[i][k]);
			 }
	     }
	     
	     cplex.solve();
	     ArrayList<ArrayList<Integer>> routes = buildRoutesFromCplex(nLocations, nVehicles, cplex, x);
	     FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\" + problemInstancePath + "_" + nLocations + "_" + nVehicles +
	    		 "_results.csv", true);
			writer.write(cplex.getObjValue() + "," + 0.0 + "\n");
			writer.close();
	     
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
		    		 if (sortedEdges[1][i] == 0) break;
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
}
