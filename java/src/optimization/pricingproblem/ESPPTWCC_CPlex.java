package optimization.pricingproblem;

import java.util.ArrayList;
import java.util.Random;

import ilog.concert.IloException;
import ilog.concert.IloLinearNumExpr;
import ilog.concert.IloNumVar;
import ilog.cplex.IloCplex;
import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import util.DistanceMatrixImporter;
import util.OrdersImporter;

public class ESPPTWCC_CPlex {
	
	private DistanceMatrix distanceMatrix;
	private DistanceMatrix reducedCostsMatrix;
	private ArrayList<Integer> shortestPath;
	private int currentTime;
	private int nLocations;
	private int nCustomers;
	private ArrayList<Order> orders;

	public static void main(String[] args) throws IloException {
		DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv"));
		 double[] reducedCosts = new double[distmat.getAllEntries().length];
		 for (int i = 0; i < reducedCosts.length; i++) {
			 reducedCosts[i] = distmat.getAllEntries()[i];
		 }
		 Random r = new Random();
		 r.setSeed(0);
		 double[] duals = new double[distmat.getDimension()];
		 duals[0] = 0;
		 for (int i = 0; i < duals.length-1; i++) { 
			 duals[i+1] = r.nextInt(1344) - (1344/2); //1344 highest entry of the distance matrix
			 duals[i+1] += ModelConstants.CUSTOMER_LOADING_TIME;
		 }
		 distmat = distmat.insertDummyDepotAsFinalNode();
		 distmat.addCustomerServiceTimes(ModelConstants.CUSTOMER_LOADING_TIME);
		 distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 // copy distmat
		 double[] entries = distmat.getAllEntries();
		 double[] newEntries = new double[entries.length];
		 for (int i = 0; i < entries.length; i++) {
			 newEntries[i] = entries[i];
		 }
		 DistanceMatrix reducedCostsMat = new DistanceMatrix(newEntries);
		 reducedCostsMat = reducedCostsMat.subtractDuals(duals);
		 
		 // set entry from depot to depot to infinity
		 reducedCostsMat.setEntry(Double.MAX_VALUE, 1, reducedCostsMat.getDimension());
		 /**
		 for (int i = 0; i < reducedCostsMat.getDimension(); i++) {
			 for (int j = 0; j < reducedCostsMat.getDimension(); j++) {
				 System.out.println("i " + i + " j " + j + " value "  + reducedCostsMat.getEntry(i+1, j+1));
			 }
		 }*/
		 
		 ArrayList<Order> orders = OrdersImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\DummyOrders_30.csv");
		 int currentTime = 40*60;
		 ESPPTWCC_CPlex espptwcc_cplex = new ESPPTWCC_CPlex(distmat, reducedCostsMat, orders, currentTime);
		 espptwcc_cplex.getShortestPath();
	}
	
	public ESPPTWCC_CPlex(DistanceMatrix distanceMatrix, DistanceMatrix reducedCostsMatrix, ArrayList<Order> orders,
			int currentTime) {
		nLocations = distanceMatrix.getDimension();
		nCustomers = distanceMatrix.getDimension() - 2;
		this.distanceMatrix = distanceMatrix;
		this.reducedCostsMatrix = reducedCostsMatrix;
		this.orders = orders;
		this.currentTime = currentTime;
	}
	
	public void getShortestPath() throws IloException {
		IloCplex cplex = new IloCplex();
		IloNumVar[][] x = new IloNumVar[nLocations][];
		for (int i = 0; i < nLocations; i++) {
			x[i] = cplex.boolVarArray(nLocations);
		}
		IloNumVar[] s = cplex.intVarArray(nLocations, 0, ModelConstants.TIME_WINDOW+30*60);
		
		// build objective
	    IloLinearNumExpr obj = cplex.linearNumExpr();
		for (int i = 0; i < nLocations; i++) {
			for (int j = 0; j < nLocations; j++) {
				obj.addTerm(reducedCostsMatrix.getEntry(i+1, j+1), x[i][j]);
			}
			obj.addTerm(0.00001, s[i]);
		}
		cplex.addMinimize(obj);

		// capacity constraint
		IloLinearNumExpr expr = cplex.linearNumExpr();
		for (int i = 0; i < nCustomers; i++) {
	    	for (int j = 0; j < nLocations; j++) {
	    		expr.addTerm(orders.get(i).getWeight(), x[i+1][j]);
	    	}
		}
	   	cplex.addLe(expr, ModelConstants.VEHICLE_CAPACITY);

		// vehicles start in the depot
		IloLinearNumExpr expr1 = cplex.linearNumExpr();
		for (int j = 0; j < nLocations; j++) {
			expr1.addTerm(1.0, x[0][j]);
		}
		cplex.addEq(1.0, expr1);
		
		// vehicles must leave a node they arrive at
		for (int h = 0; h < nCustomers; h++) {
			IloLinearNumExpr expr2 = cplex.linearNumExpr();
			for (int i = 0; i < nLocations; i++) {
				expr2.addTerm(1.0, x[i][h+1]);
			}
			for (int j = 0; j < nLocations; j++) {
				expr2.addTerm(-1.0, x[h+1][j]);
			}
			cplex.addEq(0.0, expr2);
		}
		
		// vehicles must end at the depot
		IloLinearNumExpr expr3 = cplex.linearNumExpr();
		for (int i = 0; i < nLocations; i++) {
			expr3.addTerm(1.0, x[i][nLocations-1]);
		}
		cplex.addEq(1.0, expr3);
		
		
		 int[] timesRemaining = new int[nLocations];
	     timesRemaining[0] = 0;
	     for (int i = 1; i < nCustomers+1; i++) {
	    	 timesRemaining[i] = ModelConstants.TIME_WINDOW - orders.get(i-1).getMET(currentTime);
	     }
	     timesRemaining[timesRemaining.length-1] = ModelConstants.TIME_WINDOW + 30*60;
		 double maxValue = 0;
		 for (int p = 0; p < nLocations; p++) {
			 for (int q = 0; q < nLocations; q++) {
				 if (p == 0 && q == nLocations-1) continue;
				 if (timesRemaining[p] == ModelConstants.TIME_WINDOW + 30*60) continue;
				 if (timesRemaining[p] + distanceMatrix.getEntry(p+1, q+1) > maxValue) maxValue = timesRemaining[p] + 
						 distanceMatrix.getEntry(p+1, q+1);
			 }
		 }
	     for (int i = 0; i < nLocations-1; i++) {
	    	 for (int j = 0; j < nLocations-1; j++) {
            	 IloLinearNumExpr expr4 = cplex.linearNumExpr();
            	 expr4.addTerm(1.0, s[i]);
            	 expr4.addTerm(-1.0, s[j]);
            	 expr4.addTerm(maxValue, x[i][j]);
        		 cplex.addLe(expr4, maxValue - distanceMatrix.getEntry(i+1, j+1));
	    	 }
	     }
	     
	     // ensure arrival within time horizon
	     for (int i = 0; i < nLocations; i++) {
        	 IloLinearNumExpr expr5 = cplex.linearNumExpr();
        	 expr5.addTerm(1.0, s[i]);
	    	 cplex.addLe(expr5, timesRemaining[i]);
	     }
	     
	     // every location can only be visited once
	     for (int i = 0; i < nLocations; i++) {
        	 IloLinearNumExpr expr5 = cplex.linearNumExpr();
	    	 for (int j = 0; j < nLocations; j++) {
	    		 expr5.addTerm(1.0, x[i][j]);
	    	 }
	    	 cplex.addLe(expr5, 1.0);
	     }
	     
	     // prevent loops to the same location
	     for (int i = 0; i < nLocations; i++) {
        	 IloLinearNumExpr expr5 = cplex.linearNumExpr();
        	 expr5.addTerm(1.0, x[i][i]);
        	 cplex.addEq(expr5, 0.0);
	     }
	     
	     cplex.solve();
	     ArrayList<Integer> result = buildRoutesFromCplex(nLocations, cplex, x);
	     for (int i = 0; i < result.size() - 1; i++) System.out.print(result.get(i) + "->");
	     System.out.println(result.get(result.size()-1));
	     for (int i = 0; i < nLocations; i++) {
	    	 System.out.println(cplex.getValue(s[i]));
	     }
	     cplex.end();
	}
	
	private static ArrayList<Integer> buildRoutesFromCplex(int nLocations, IloCplex cplex, IloNumVar[][] x) {
	   try {
		   int edgeCount = 0;
		   boolean[][] decision = new boolean[nLocations][nLocations];
		     for (int i = 0; i < nLocations; i++) {
		    	 for (int j = 0; j < nLocations; j++) {
	    			 if (cplex.getValue(x[i][j]) > 0) {
	    				 System.out.println(i + " " + j);
	    				 decision[i][j] = true;
	    				 edgeCount++;
	    			 }
		    	 }
		     }
	    	 int[][] edges = new int[2][edgeCount];
	    	 int counter = 0;
	    	 for (int i = 0; i < nLocations; i++) {
	    		 for (int j = 0; j < nLocations; j++) {
	    			 if (decision[i][j]) {
	    				 edges[0][counter] = i;
	    				 edges[1][counter] = j;
	    				 counter++;
	    			 }
	    		 }
	    	 }
	    	 // now connect the edges 
	    	 int[][] sortedEdges = new int[2][edgeCount];
	    	 // insert first connection
	    	 sortedEdges[0][0] = 0;
	    	 sortedEdges[1][0] = edges[1][0];
    		 int currentSuccessor = edges[1][0];
	    	 for (int i = 0; i < edgeCount-1; i++) {
	    		 for (int j = 1; j < edgeCount; j++) {
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
		     return route;
	     }
	   catch (Exception e) {e.printStackTrace();}
	   return null;
   }
}
