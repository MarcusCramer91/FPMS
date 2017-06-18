package optimization;
import java.util.ArrayList;

import ilog.concert.*;
import ilog.cplex.*;
import model.DistanceMatrix;
import model.Order;
import model.ModelConstants;
import util.DistanceMatrixImporter;
import util.OrdersImporter;

public class CPlexTSPTW {   
   
   public static void main(String[] args) {
		ArrayList<Order> orders = OrdersImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\DummyOrders_30.csv");
		DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv"));
		ArrayList<Order> relevantOrders = new ArrayList<Order>();
		relevantOrders.add(orders.get(18));
		relevantOrders.add(orders.get(12));
		relevantOrders.add(orders.get(15));
		relevantOrders.add(orders.get(16));
		relevantOrders.add(orders.get(13));
		relevantOrders.add(orders.get(19));
		relevantOrders.add(orders.get(11));
		relevantOrders.add(orders.get(14));
		int[] routeIndices = new int[relevantOrders.size() + 1];
		routeIndices[0] = 1;
		for (int k = 1; k <= relevantOrders.size(); k++) {
			routeIndices[k] = relevantOrders.get(k-1).getDistanceMatrixLink();
		}
		ArrayList<Integer> route = new ArrayList<Integer>();
		route.add(0);
		route.add(19);
		route.add(13);
		route.add(16);
		route.add(17);
		route.add(14);
		route.add(20);
		route.add(12);
		route.add(15);
		route.add(31);
		
		DistanceMatrix croppedMatrix = new DistanceMatrix(distmat.getAllEntries());
		croppedMatrix = croppedMatrix.getCroppedMatrix(routeIndices);

		croppedMatrix = croppedMatrix.insertDummyDepotAsFinalNode();
		int[] tspRoute = getRoute(croppedMatrix, relevantOrders, 30*60);
		for (int i : tspRoute) System.out.print(i + "->");
		ArrayList<Integer> tspRouteList = ModelHelperMethods.parseTSPOutput2(tspRoute, route);
		System.out.println();
		for (int i : tspRouteList) System.out.print(i + "->");
   }
   
   public static int[] getRoute(DistanceMatrix distmat, ArrayList<Order> orders, int currentTime) {
		  try {
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations-2;
		 double[][] distances = distmat.getTwoDimensionalArray();

	     IloCplex cplex = new IloCplex();
	     cplex.setOut(null);
		
	
		 IloNumVar[][] x = new IloNumVar[nLocations][];
		 for (int i = 0; i < nLocations; i++) {
			 x[i] = cplex.boolVarArray(nLocations);
		 }
		 
		 IloNumVar[] s = cplex.intVarArray(nLocations, 0, ModelConstants.TIME_WINDOW+30*60);
		 
		 // build objective function with all costs and decision variables
		 // 3.1
	     IloLinearNumExpr obj = cplex.linearNumExpr();
		 
    	 for (int i = 0; i < nLocations; i++) {
    		 for (int j = 0; j < nLocations; j++) {
            	 obj.addTerm(distances[i][j],x[i][j]);
    		 }
    	 }
	     cplex.addMinimize(obj);

	     // ensure that all customers are visited
	     // 3.2
	     for (int i = 1; i < (nCustomers+1); i++) {
	    	 IloLinearNumExpr expr = cplex.linearNumExpr();
    		 for (int j = 0; j < nLocations; j++) {
    			 expr.addTerm(1.0, x[i][j]);
	    	 }
	    	 cplex.addEq(1.0, expr);
	     }
	     
	     // ensure that all vehicles start at the depot
	     // 3.4
    	 IloLinearNumExpr expr = cplex.linearNumExpr();
    	 for (int j = 1; j < (nCustomers + 1); j++) {
    		 expr.addTerm(1.0, x[0][j]);
    	 }
    	 cplex.addEq(1.0, expr);
	     
	     //TODO allow vehicles to go to the end depot directly
	     // ensure that vehicles leave a customer they arrive at
	     // 3.5
	     for (int h = 1; h < (nCustomers + 1); h++) {
        	 IloLinearNumExpr expr1 = cplex.linearNumExpr();
        	 for (int i = 0; i < nLocations; i++) {
        		 expr1.addTerm(1.0, x[i][h]);
        	 }
        	 for (int j = 0; j < nLocations; j++) {
        		 if (j != h) expr1.addTerm(-1.0, x[h][j]);
        	 }
        	 cplex.addEq(0.0, expr1);
	     }
	     
	     // ensure that all vehicles end at the depot
	     // 3.6
    	 IloLinearNumExpr expr2 = cplex.linearNumExpr();
    	 for (int i = 1; i < (nCustomers + 1); i++) {
    		 expr2.addTerm(1.0, x[i][nLocations-1]);
    	 }
    	 cplex.addEq(1.0, expr2);
    	 
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
            	 IloLinearNumExpr expr3 = cplex.linearNumExpr();
            	 expr3.addTerm(1.0, s[i]);
            	 expr3.addTerm(-1.0, s[j]);
        		 expr3.addTerm(maxValue, x[i][j]);
        		 cplex.addLe(expr3, maxValue - distances[i][j]);
	    	 }
	     }
	     
	     // ensure arrival within time horizon
	     // 3.8/
	     for (int i = 1; i < nLocations-1; i++) {
        	 cplex.addLe(s[i], timesRemaining[i]);
	     }
	     
		 // ensure that no tour arrives at node 0
		 IloLinearNumExpr expr5 = cplex.linearNumExpr();
		 for (int i = 0; i < nLocations; i++) {
			 expr5.addTerm(1.0, x[i][0]);
		 }
		 cplex.addEq(0.0, expr5);
		 
		 // ensure that no tour leaves the last node
		 IloLinearNumExpr expr6 = cplex.linearNumExpr();
		 for (int i = 0; i < nLocations; i++) {
			 expr6.addTerm(1.0, x[nLocations-1][i]);
		 }
		 cplex.addEq(0.0, expr6);
         
         cplex.solve();
         
		 
         int[] result = parseCplexOutput(cplex, x, nLocations);
         
         cplex.end();
		 return result;
      }
      catch (IloException exc) {
         System.err.println("Concert exception '" + exc + "' caught");
      }
		  return null;
   }
   
   public static int[] parseCplexOutput(IloCplex cplex, IloNumVar[][] x, int n) {
	   try {
		   int[] result = new int[n];
		   result[0] = 1;
		   // get edges first
		   int[][] edges = new int[2][n-1];
		   int counter = 0;
	       for (int i = 0; i < n; i++) {
	      	 for (int j = 0; j < n; j++) {
	      		 if (i == j) continue;
	      		 if (Math.round(cplex.getValue(x[i][j])) == 1) {
	      			 edges[0][counter] = i+1;
	      			 edges[1][counter] = j+1;
	      			 counter++;
	      		 }
	      	 }
	       }
		   counter = 1;
		   result[0] = 1;
		   int currentSuccessor = edges[1][0];
		   for (int i = 1; i < n-1; i++) {
			   for (int j = 0; j < n-1; j++) {
				   if (edges[0][j] == currentSuccessor) {
					   currentSuccessor = edges[1][j];
					   result[counter] = edges[0][j];
					   counter++;
					   break;
				   }
			   }
		   }
		   result[counter] = n;
		   return result;
	   }
	   catch (Exception e) {e.printStackTrace();}
	   return null;
   }
}
