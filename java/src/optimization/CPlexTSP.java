package optimization;
import ilog.concert.*;
import ilog.cplex.*;
import model.DistanceMatrix;
import model.ModelConstants;
import util.DistanceMatrixImporter;

public class CPlexTSP {
   
   static int nCustomers = 14;
   
   static void displayResults(IloCplex cplex,
                              IloNumVar[] inside,
                              IloNumVar[] outside) throws IloException {
      System.out.println("cost: " + cplex.getObjValue());
   }
   
   public static void main( String[] args ) {
	  try {
		 int n = 15;
		 DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy15TravelTimes.csv"));
		 double[][] distances = distmat.getTwoDimensionalArray();
		   
         IloCplex cplex = new IloCplex();
		 IloNumVar[][] x = new IloNumVar[n][];
		 for (int i = 0; i < n; i++) {
			 x[i] = cplex.boolVarArray(n);
		 }
         IloNumVar[] u = cplex.numVarArray(n, 0, Double.MAX_VALUE);
         
         // objectives
         IloLinearNumExpr obj = cplex.linearNumExpr();
         for (int i = 0; i < n; i++) {
        	 for (int j = 0; j < n; j++) {
        		 if (j != i) {
        			 obj.addTerm(distances[i][j], x[i][j]);
        		 }
        	 }
         }
         cplex.addMinimize(obj);
         
         // constraints
         for (int j = 0; j < n; j++) {
        	 IloLinearNumExpr expr = cplex.linearNumExpr();
        	 for (int i = 0; i < n; i++) {
        		 if (i != j) {
        			 expr.addTerm(1.0, x[i][j]);
        		 }
        	 }
        	 cplex.addEq(expr, 1.0);
         }
         
         for (int i = 0; i < n; i++) {
        	 IloLinearNumExpr expr = cplex.linearNumExpr();
        	 for (int j = 0; j < n; j++) {
        		 if (j != i) {
        			 expr.addTerm(1.0, x[i][j]);
        		 }
        	 }
        	 cplex.addEq(expr, 1.0);
         }
         for (int i = 1; i < n; i++) {
        	 for (int j = 1; j < n; j++) {
        		 if (i != j) {
        			 IloLinearNumExpr expr = cplex.linearNumExpr();
        			 expr.addTerm(1.0, u[i]);
        			 expr.addTerm(-1.0, u[j]);
        			 expr.addTerm(n-1, x[i][j]);
        			 cplex.addLe(expr, n-2);
        		 }
        	 }
         }
         cplex.solve();
         /**System.out.println("Total distance: " + cplex.getObjValue());
         for (int i = 0; i < n; i++) {
        	 for (int j = 0; j < n; j++) {
        		 if (i == j) continue;
        		 if (cplex.getValue(x[i][j]) > 0) System.out.println(i + "->" + j);
        	 }
         }*/
		 
         cplex.end();
      }
      catch (IloException exc) {
         System.err.println("Concert exception '" + exc + "' caught");
      }
   }
   
   public static int[] getRoute(DistanceMatrix distmat) {
		  try {
		 distmat = distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 distmat = distmat.addCustomerServiceTimes(ModelConstants.CUSTOMER_LOADING_TIME);
		 double[][] distances = distmat.getTwoDimensionalArray();
		 int n = distmat.getDimension();
         IloCplex cplex = new IloCplex();
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Feasibility, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Optimality, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Markowitz, 0.999);
         cplex.setOut(null);
		 IloNumVar[][] x = new IloNumVar[n][];
		 for (int i = 0; i < n; i++) {
			 x[i] = cplex.boolVarArray(n);
		 }
         IloNumVar[] u = cplex.numVarArray(n, 0, Double.MAX_VALUE);
         
         // objectives
         IloLinearNumExpr obj = cplex.linearNumExpr();
         for (int i = 0; i < n; i++) {
        	 for (int j = 0; j < n; j++) {
        		 if (j != i) {
        			 obj.addTerm(distances[i][j], x[i][j]);
        		 }
        	 }
         }
         cplex.addMinimize(obj);
         
         // constraints
         for (int j = 0; j < n; j++) {
        	 IloLinearNumExpr expr = cplex.linearNumExpr();
        	 for (int i = 0; i < n; i++) {
        		 if (i != j) {
        			 expr.addTerm(1.0, x[i][j]);
        		 }
        	 }
        	 cplex.addEq(expr, 1.0);
         }
         
         for (int i = 0; i < n; i++) {
        	 IloLinearNumExpr expr = cplex.linearNumExpr();
        	 for (int j = 0; j < n; j++) {
        		 if (j != i) {
        			 expr.addTerm(1.0, x[i][j]);
        		 }
        	 }
        	 cplex.addEq(expr, 1.0);
         }
         for (int i = 1; i < n; i++) {
        	 for (int j = 1; j < n; j++) {
        		 if (i != j) {
        			 IloLinearNumExpr expr = cplex.linearNumExpr();
        			 expr.addTerm(1.0, u[i]);
        			 expr.addTerm(-1.0, u[j]);
        			 expr.addTerm(n-1, x[i][j]);
        			 cplex.addLe(expr, n-2);
        		 }
        	 }
         }
         cplex.solve();
         /**System.out.println("Total distance: " + cplex.getObjValue());
         for (int i = 0; i < n; i++) {
        	 for (int j = 0; j < n; j++) {
        		 if (i == j) continue;
        		 if (cplex.getValue(x[i][j]) > 0) System.out.println(i + "->" + j);
        	 }
         }*/
         int[] result = parseCplexOutput(cplex, x, n);
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
		   int[] result = new int[n+1];
		   result[0] = 1;
		   // get edges first
		   int[][] edges = new int[2][n];
		   int counter = 0;
	       for (int i = 0; i < n; i++) {
	      	 for (int j = 0; j < n; j++) {
	      		 if (i == j) continue;
	      		 if (cplex.getValue(x[i][j]) > 0) {
	      			 edges[0][counter] = i+1;
	      			 edges[1][counter] = j+1;
	      			 counter++;
	      		 }
	      	 }
	       }
		   counter = 1;
		   result[0] = 1;
		   int currentSuccessor = edges[1][0];
		   for (int i = 1; i < n; i++) {
			   for (int j = 0; j < n; j++) {
				   if (edges[0][j] == currentSuccessor) {
					   currentSuccessor = edges[1][j];
					   result[counter] = edges[0][j];
					   counter++;
					   break;
				   }
			   }
		   }
		   result[counter] = 1;
		   return result;
	   }
	   catch (Exception e) {e.printStackTrace();}
	   return null;
   }
}
