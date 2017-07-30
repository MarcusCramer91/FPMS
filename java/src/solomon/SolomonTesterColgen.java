package solomon;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import ilog.concert.IloException;
import ilog.concert.IloLinearNumExpr;
import ilog.concert.IloNumVar;
import ilog.concert.IloRange;
import ilog.cplex.IloCplex;
import model.DistanceMatrix;
import model.ModelConstants;
import model.Order;
import optimization.ModelHelperMethods;
import optimization.testers.ColGenTester;
import util.DistanceMatrixImporter;
import util.OrdersImporter;

public class SolomonTesterColgen {
	
	private DistanceMatrix distmat;
	private ArrayList<Order> orders;
	private int currentTime;
	private ArrayList<Path> paths;
	private double currentRelaxedCosts;
	private double currentMIPCosts;
	private String id;
	private int nPaths = 1;

	public static void main(String[] args) throws Exception {
		/**String[] approaches = {"espptwcc_heur", "spptwcc",
				"spptwcc2", "spptwcc_heur", "spptwcc2_heur"};*/
		
		/**String[] solomonProblems = {"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c101.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c102.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c103.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c104.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c105.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c106.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c107.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c108.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c109.txt"};*/
		String[] solomonProblems = {"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r101.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r102.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r103.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r104.txt", 
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r105.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r106.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r107.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r108.txt",
		"C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\r109.txt"};
		int currentTime = 30*60;
		int compTimeLimit = 180;
		for (int i = 20; i <= 50; i += 10) {
			for (int j = 0; j < solomonProblems.length; j++) {
				String solomonPath = solomonProblems[j];
				String[] approaches = {"espptwcc_heur"};
				for (String approach : approaches) {
					String id = "_" + approach + "_" + i + "_" + (j+1);
					System.out.println("Current problem: " + id);
					ArrayList<Object> solomon = SolomonImporter.importCSV(solomonPath, i);
					@SuppressWarnings("unchecked")
					ArrayList<Order> orders = (ArrayList<Order>)solomon.get(0);
					DistanceMatrix distanceMatrix = (DistanceMatrix)solomon.get(1);
					SolomonTesterColgen tester = new SolomonTesterColgen(distanceMatrix, orders, currentTime, id);
					tester.getRoutes(compTimeLimit, approach, true);
				}
			}
		}
	}	
	
	public SolomonTesterColgen(DistanceMatrix distmat, ArrayList<Order> orders, 
			   int currentTime, String id) {
		this.distmat = distmat;
		this.orders = orders;
		this.currentTime = currentTime;
		this.paths = new ArrayList<Path>();
		this.id = id;
	}
	
	public void getRoutes(int compTimeLimit, String sppAlgorithm, boolean generateOutput) throws IloException, IOException {		 
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		// initialize with trivial paths
		 for (int i = 0; i < nCustomers; i++) {
			 ArrayList<Integer> nodes = new ArrayList<Integer>();
			 nodes.add(0);
			 nodes.add(i+1);
			 nodes.add(nLocations-1);
			 double costs = distmat.getEntry(1, i+2) + distmat.getEntry(i+2, nLocations);
			 Path p = new Path(nodes, costs, 0, nLocations);
			 paths.add(p);
		 }
		 getRoutesInternal(compTimeLimit, sppAlgorithm, generateOutput);
	}
	
	private void getRoutesInternal(int compTimeLimit, String sppAlgorithm, boolean generateOutput) throws IloException, IOException {
		 long time = System.currentTimeMillis();
		 int iterationCount = 0;
		 ArrayList<Integer> previousBestPath = null;
		 
		 // column generation 
		 while((System.currentTimeMillis() - time) < compTimeLimit*1000) {
			 iterationCount++;
			 //System.out.println(iterationCount);
		     // get duals
		     double[] duals = solveDual();
		     
		     // log information
			 if (generateOutput) {
			     int decision[] = solveMIP();
			     /**for (int i = 0; i < decision.length; i++) {
			    	 if (decision[i] == 1) System.out.println("Route: " + i);
			     }*/
			     ArrayList<ArrayList<Integer>> routes = computeSolution(decision);
			     
			     solveRelaxation();
				 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\solomon\\" + id + ".csv", true);
				 writer.write((Math.floor(System.currentTimeMillis() - time) / 1000)+  "," + currentMIPCosts + "," + currentRelaxedCosts + "\n");
			     writer.close();
			     
			     ArrayList<Integer> customersContained = new ArrayList<Integer>();
			     for (int i = 1; i < 30 + 1; i++) {
			    	 for (int p = 0; p < routes.size(); p++) {
			    		 if (routes.get(p).contains(i)) {
			    			 if (!customersContained.contains(i)) customersContained.add(i);
			    		 }
			    	 }
			     }
			 }
		     
		     
		     if ((System.currentTimeMillis() - time) > compTimeLimit*1000) break;
		     
		     // compute reduced costs for arcs
		     double[] reducedCosts = new double[distmat.getAllEntries().length];
			 for (int i = 0; i < reducedCosts.length; i++) {
				 reducedCosts[i] = distmat.getAllEntries()[i];
			 }
			 DistanceMatrix reducedCostsMatrix = new DistanceMatrix(reducedCosts);
			 reducedCostsMatrix.subtractDuals(duals);
			 
			 // solve pricing problem
			 // use espptwcc only for problems with tight bounds
			 //ESPPTWCC espptwcc = new ESPPTWCC(distmat, reducedCostsMatrix, orders, currentTime);
			 //Path newPath = espptwcc.labelNodes();
			 Path newPath = null;
			 ArrayList<Path> newPaths = null;
			 if (sppAlgorithm.equals("espptwcc_heur")) {
				 ESPPTWCC_Heuristic espptwcc_heuristic = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime, 50, true);
				 newPaths = espptwcc_heuristic.labelNodes();			 
			 }
		     
			 else if (sppAlgorithm.equals("spptwcc")) {
				 SPPTWCC spptwcc = new SPPTWCC(distmat, reducedCostsMatrix, orders, currentTime, true);
				 newPath = spptwcc.labelNodes().get(0);			 
			 }
			 else return;
			 
			 // check if new path has negative costs/exists
			 if (!sppAlgorithm.equals("espptwcc_heur")) {
				 if (newPath == null) break;
				 if (previousBestPath == null || !ModelHelperMethods.samePath(previousBestPath, newPath.getNodes())) {
					 previousBestPath = newPath.getNodes();
				 }
				 else break;
				 // print the best found new path
				 /**for (int i = 0; i < newPath.getNodes().size(); i++) {
					 System.out.print(newPath.getNodes().get(i) + "->");
				 }
				 System.out.println();
				 System.out.println("Costs for new path: " + newPath.getCosts());*/
				 // check if path has negative reduced costs, if not exist loop
				 if (newPath.getReducedCosts() >= 0) break;
				 if (checkConvergence(newPath.getNodes())) break;
				 paths.add(newPath);		 
			 }
			 else {
				 if (newPaths == null)  break;
				 if (previousBestPath == null || !ModelHelperMethods.samePath(previousBestPath, newPaths.get(0).getNodes())) {
					 previousBestPath = newPaths.get(0).getNodes();
				 }
				 else break;
				 // print the best found new path
				 /**for (int i = 0; i < newPaths.get(0).getNodes().size(); i++) {
					 System.out.print(newPaths.get(0).getNodes().get(i) + "->");
				 }
				 System.out.println();
				 System.out.println("Costs for new path: " + newPaths.get(0).getCosts());*/
				 if (checkConvergence(newPaths.get(0).getNodes())) break;
				 paths.addAll(newPaths);
			 }
		 }
		 
		 /**double[] relaxedValues = solveRelaxation();
		 for (int i = 0; i < relaxedValues.length; i++) {
			 System.out.println(i + " = " + relaxedValues[i]);
		 }*/
		 
		 // now optimize via branch and bound
		 int[] decision = solveMIP();

	     ArrayList<ArrayList<Integer>> routes = computeSolution(decision);
	    		 
		 if (generateOutput) {
			 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\solomon\\" + id + ".csv", true);
			 writer.write((Math.floor(System.currentTimeMillis() - time) / 1000)+  "," + currentMIPCosts + "," + currentRelaxedCosts + "\n");
		     writer.close(); 
		 }
		 
	     //System.out.println("Paths used with overlapping: " );
	}
	
	
	private double[] solveDual() throws IloException {
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 IloCplex cplex = new IloCplex();
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Feasibility, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Optimality, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Markowitz, 0.999);
		 cplex.setOut(null);
		 IloNumVar[] pi = cplex.numVarArray(nCustomers, 0.0, Double.MAX_VALUE);
			
		 // build objective function
	     IloLinearNumExpr obj = cplex.linearNumExpr();	
	     for (int i = 0; i < nCustomers; i++) {
	         obj.addTerm(1.0, pi[i]);
	     }
	     cplex.addMaximize(obj);
	     
	     // build constraints
	     for (int p = 0; p < paths.size(); p++) {
		     IloLinearNumExpr expr = cplex.linearNumExpr();
	    	 for (int i = 1; i < nCustomers + 1; i++) {
	    		 for (int j = 0; j < nLocations; j++) {
	    			 expr.addTerm(paths.get(p).getArcsUsed()[i][j], pi[i-1]);
	    		 }
	    	 }
	    	 cplex.addLe(expr, paths.get(p).getCosts());
	     }

	     cplex.solve();
	     double[] result = new double[nCustomers+1];
	     result[0] = 0;
	     for (int i = 0; i < nCustomers; i++) {
	    	 result[i+1] = cplex.getValue(pi[i]);
	    	 // System.out.println("pi_"+ (i+2) + "=" + cplex.getValue(pi[i]));
	     }
	     cplex.end();
	     return result;
	}
	
	private int[] solveMIP() throws IloException {
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 IloCplex cplex = new IloCplex();
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Feasibility, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Optimality, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Markowitz, 0.999);
		 cplex.setOut(null);
		 IloNumVar[] y = cplex.boolVarArray(paths.size());
		
		 // build objective function
	     IloLinearNumExpr obj = cplex.linearNumExpr();	
	     for (int p = 0; p < paths.size(); p++) {
	         obj.addTerm(paths.get(p).getCosts(), y[p]);
	     }
	     cplex.addMinimize(obj);
	     
	     // constraint 1
	     for (int i = 1; i < nCustomers + 1; i++) {
	    	 IloLinearNumExpr expr = cplex.linearNumExpr();
		     for (int p = 0; p < paths.size(); p++) {
		    	 if (paths.get(p).getNodes().contains(i)) expr.addTerm(1.0, y[p]);
		     }
		     cplex.addGe(expr, 1.0);
	     }	     
	     
	     cplex.solve();
	     int[] decision = new int[y.length];
	     for (int i = 0; i < y.length; i++) {
	    	 if (cplex.getValue(y[i]) == 1) decision[i] = 1;
	     }
	     currentMIPCosts = cplex.getObjValue();
	     //System.out.println("Costs: " + cplex.getObjValue());
	     cplex.end();
	     return decision;
	}
	
	private double[] solveRelaxation() throws IloException {
		int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 IloCplex cplex = new IloCplex();
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Feasibility, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Optimality, 1e-9);
		 cplex.setParam(IloCplex.Param.Simplex.Tolerances.Markowitz, 0.999);
		 cplex.setOut(null);
		 IloNumVar[] y = cplex.numVarArray(paths.size(), 0, 1);
		
		 // build objective function
	     IloLinearNumExpr obj = cplex.linearNumExpr();	
	     for (int p = 0; p < paths.size(); p++) {
	         obj.addTerm(paths.get(p).getCosts(), y[p]);
	     }
	     cplex.addMinimize(obj);
	     
	     // constraint 1
	     ArrayList<IloRange> constraints = new ArrayList<IloRange>();
	     for (int i = 1; i < nCustomers + 1; i++) {
	    	 IloLinearNumExpr expr = cplex.linearNumExpr();
		     for (int p = 0; p < paths.size(); p++) {
		    	 for (int j = 0; j < nLocations; j++) {
		    		 expr.addTerm(paths.get(p).getArcsUsed()[i][j], y[p]);
		    	 }
		     }
		     constraints.add(cplex.addGe(expr, 1.0));
	     }
	     cplex.solve();
	     /**
	     for (int p = 0; p < paths.size(); p++) {
	    	 System.out.println("Decision for path " + p + " = " + cplex.getValue(y[p]));
	     }*/
	     
	     //System.out.println("Relaxed costs = " + cplex.getObjValue());
	     
	     double[] result = new double[paths.size()];
	     for (int p = 0; p < paths.size(); p++) {
	    	 result[p] = cplex.getValue(y[p]);
	    	 //System.out.println("pi_" + i + "=" + duals[i]);
	     }
	     currentRelaxedCosts = cplex.getObjValue();
	     cplex.end();
	     return result;
	}
	
	private ArrayList<ArrayList<Integer>> eliminateDuplicateCustomers(ArrayList<ArrayList<Integer>> routes) {
		
		// find all duplicates first
		ArrayList<Integer> nodes = new ArrayList<Integer>();
		ArrayList<Integer> duplicates = new ArrayList<Integer>();
		HashMap<Integer, ArrayList<Integer>> duplicatesMap = new HashMap<Integer, ArrayList<Integer>>();
		for (int i = 0; i < routes.size(); i++) {
			ArrayList<Integer> route = routes.get(i);
			for (int j = 1; j < route.size()-1; j++) {
				if (route.get(j) == 1) continue;
				if (nodes.contains(route.get(j))) {
					if (!duplicates.contains(route.get(j))) duplicates.add(route.get(j));
					
				}
				else nodes.add(route.get(j));
			}
		}
		
		for (int i = 0; i < duplicates.size(); i++) {
			for (int j = 0; j < routes.size(); j++) {
				ArrayList<Integer> route = routes.get(j);
				if (route.contains(duplicates.get(i))) {
					if (duplicatesMap.containsKey(duplicates.get(i))) duplicatesMap.get(duplicates.get(i)).add(j);
					else {
						ArrayList<Integer> temp = new ArrayList<Integer>();
						temp.add(j);
						duplicatesMap.put(duplicates.get(i),temp);
					}
				}
			}
		}
		
		// find the cheapest route configuration achievable by removing all duplicates
		return eliminateDuplicateCustomersBranchingStep(routes, duplicatesMap);
	}
	
	private ArrayList<ArrayList<Integer>> eliminateDuplicateCustomersBranchingStep(ArrayList<ArrayList<Integer>> routes,
			HashMap<Integer, ArrayList<Integer>> duplicatesMap) {
		if (duplicatesMap.size() == 0) return routes;
		int duplicate = duplicatesMap.keySet().iterator().next();
		ArrayList<Integer> duplicateRoutes = duplicatesMap.get(duplicate);
		int minimumCost = Integer.MAX_VALUE;
		ArrayList<ArrayList<Integer>> minimumCostsConfiguration = null;
		
		// branch scheme
		for (int i = 0; i < duplicateRoutes.size(); i++) {
			ArrayList<ArrayList<Integer>> routesCopy = new ArrayList<ArrayList<Integer>>();
			for (int j = 0; j < routes.size(); j++) {
				ArrayList<Integer> temp = new ArrayList<Integer>(routes.get(j));
				routesCopy.add(temp);
			}
			HashMap<Integer, ArrayList<Integer>> mapCopy = new HashMap<Integer, ArrayList<Integer>>(duplicatesMap);
			mapCopy.remove(duplicate);
			
			// remove the duplicate from all but the i'th route
			for (int j = 0; j < duplicateRoutes.size(); j++) {
				if (i == j) continue;
				routesCopy.get(duplicateRoutes.get(j)).remove(new Integer(duplicate));
			}
			ArrayList<ArrayList<Integer>> newRoutes = eliminateDuplicateCustomersBranchingStep(routesCopy, mapCopy);
			/**for (int j = 0; j < newRoutes.size(); j++) {
				for (int k = 0; k < newRoutes.get(j).size(); k++) {
					System.out.print(newRoutes.get(j).get(k) + "->");
				}
				System.out.println();
			}*/
			
			// calculate costs
			double totalCosts = 0;
			for (int j = 0; j < newRoutes.size(); j++) {
				totalCosts += ModelHelperMethods.getRouteCostsIndexed0(distmat, newRoutes.get(j));
			}
			if (totalCosts < minimumCost) minimumCostsConfiguration = newRoutes;
		}
		
		return minimumCostsConfiguration;
	}
	
	/** 
	 * Computes a solution without duplicate node visits
	 * @param decision
	 * @return
	 */
	private ArrayList<ArrayList<Integer>> computeSolution(int[] decision) {
		ArrayList<ArrayList<Integer>> routes = new ArrayList<ArrayList<Integer>>();

	     // form paths
	     for (int i = 0; i < paths.size(); i++) {
	    	 if (decision[i] == 1) {
	    		 int[][] arcsUsed = paths.get(i).getArcsUsed();
	    		 ArrayList<Integer> path = ModelHelperMethods.convertArcsUsedToPath(arcsUsed);
	    		 ArrayList<Integer> newPath = new ArrayList<Integer>();
	    		 // eliminate duplicates except for the depot
	    		 for (Integer j : path) {
	    			 if (!newPath.contains(j) || j == 1) newPath.add(j);
	    		 }
	    		 routes.add(newPath);
	    	 }
	     }
	     // remove duplicate customers
	     routes = eliminateDuplicateCustomers(routes);
	     return routes;
	}
	
	/**
	 * Checks whether the current path equals the previous path
	 * @param currentPath
	 * @return
	 */
	private boolean checkConvergence(ArrayList<Integer> currentPath) {
		for (int j = paths.size()-1; j <= paths.size() - 1 - nPaths; j--) {
			ArrayList<Integer> previousPath = paths.get(paths.size()-1).getNodes();
			boolean converged = true;
			if (previousPath.size() != currentPath.size()) continue;
			else {
				for (int i = 0; i < currentPath.size(); i++) {
					if (previousPath.get(i) != currentPath.get(i)) converged = false;
				}
			}
			if (converged) return true;
		}	
		return false;
	}
}

