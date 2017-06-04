package optimization;

import java.io.FileNotFoundException;
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
import util.DistanceMatrixImporter;
import util.OrdersImporter;

public class CPLEXColumnGeneration {
	
	private DistanceMatrix distmat;
	private ArrayList<Order> orders;
	private int currentTime;
	private ArrayList<Path> paths;
	private double currentRelaxedCosts;
	private double currentMIPCosts;
	
	public static void main(String[] args) throws Exception {
		DistanceMatrix distmat = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30TravelTimes.csv"));
		DistanceMatrix distmatair = new DistanceMatrix(
				 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\Dummy30AirDistances.csv"));
		
		ArrayList<Order> orders = OrdersImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\DummyOrders_30.csv");
		int currentTime = 40*60;
		int compTimeLimit = 120;
		CPLEXColumnGeneration colgen = new CPLEXColumnGeneration(distmat, orders, currentTime);
		
		
		String sppAlgorithm = "spptwcc";
		/**colgen.getRoutes(compTimeLimit, sppAlgorithm, true);
		
		sppAlgorithm = "spptwcc2";
		colgen = new CPLEXColumnGeneration(distmat, orders, currentTime);
		colgen.getRoutes(compTimeLimit, sppAlgorithm, true);
		
		sppAlgorithm = "spptwcc_heur";
		colgen = new CPLEXColumnGeneration(distmat, orders, currentTime);
		colgen.getRoutes(compTimeLimit, sppAlgorithm, true);
		
		sppAlgorithm = "spptwcc2_heur";
		colgen = new CPLEXColumnGeneration(distmat, orders, currentTime);
		colgen.getRoutes(compTimeLimit, sppAlgorithm, true);*/
		
		sppAlgorithm = "espptwcc_heur";
		colgen = new CPLEXColumnGeneration(distmat, orders, currentTime);
		colgen.getRoutes(compTimeLimit, sppAlgorithm, true);
		
		// initialize with flaschenpost

		//sppAlgorithm = "espptwcc_heur_fp";
		//sppAlgorithm = "espptwcc_fp";
		//sppAlgorithm = "espptwcc_heur_fp_recomp";
		if (sppAlgorithm.equals("espptwcc_heur_fp") || sppAlgorithm.equals("espptwcc_heur_fp_recomp") ||
				sppAlgorithm.equals("espptwcc_fp")) {
			ArrayList<Order[]> initialPathsOrders = FPOptimize.assignRoutes(distmat, distmatair, orders, 10, currentTime, false, true);
			ArrayList<ArrayList<Integer>> initialPathsNodes = new ArrayList<ArrayList<Integer>>();
			for (int i = 0; i < initialPathsOrders.size(); i++) {
				Order[] current = initialPathsOrders.get(i);
				ArrayList<Integer> currentList = new ArrayList<Integer>();
				currentList.add(0);
				for (Order o : current) {
					currentList.add(o.getDistanceMatrixLink()-1);
				}
				currentList.add(distmat.getDimension());
				initialPathsNodes.add(currentList);
			}
			colgen.getRoutesWithFPInitial(compTimeLimit, initialPathsNodes, sppAlgorithm, true);			
		}
	}
	
	public CPLEXColumnGeneration(DistanceMatrix distmat, ArrayList<Order> orders, 
			   int currentTime) {
		this.distmat = distmat;
		this.orders = orders;
		this.currentTime = currentTime;
		this.paths = new ArrayList<Path>();
	}
	
	public void getRoutesWithFPInitial(int compTimeLimit, ArrayList<ArrayList<Integer>> initialPaths, 
			String sppAlgorithm, boolean generateOutput) throws IloException, IOException {
		 distmat = distmat.insertDummyDepotAsFinalNode();
		 distmat = distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 distmat = distmat.addCustomerServiceTimes(ModelConstants.REALISTIC_CUSTOMER_LOADING_TIME);
		 
		 int nLocations = distmat.getDimension();
		 for (int i = 0; i < initialPaths.size(); i++) {
			 Path p = new Path(initialPaths.get(i), ModelHelperMethods.getRouteCostsIndexed0(distmat, initialPaths.get(i)), 0, 
					 nLocations);
			 paths.add(p);
		 }
		 getRoutesInternal(compTimeLimit, sppAlgorithm, generateOutput);
	}
	
	public void getRoutes(int compTimeLimit, String sppAlgorithm, boolean generateOutput) throws IloException, IOException {
		
		 distmat = distmat.insertDummyDepotAsFinalNode();
		 distmat = distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 distmat = distmat.addCustomerServiceTimes(ModelConstants.REALISTIC_CUSTOMER_LOADING_TIME);
		 
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
		 
		 // column generation 
		 while((System.currentTimeMillis() - time) < compTimeLimit*1000) {
			 iterationCount++;
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
				 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen" + sppAlgorithm + ".csv", true);
				 writer.write((Math.floor(System.currentTimeMillis() - time) / 1000)+  "," + currentMIPCosts + "," + currentRelaxedCosts + "\n");
			     writer.close();
				 FileWriter writer2 = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen" + sppAlgorithm + "_duals.csv", true);
				 String dualsString = "" + (Math.floor(System.currentTimeMillis() - time) / 1000 + ",");
				 for (double d : duals) {			  
					 dualsString += d + ",";
				 }
				 dualsString += "\n";
				 writer2.write(dualsString);		
				 writer2.close();
			     
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
			 if (sppAlgorithm.equals("espptwcc_heur") || sppAlgorithm.equals("espptwcc_heur_fp")) {
				 ESPPTWCC_Heuristic espptwcc_heuristic = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime, 10);
				 newPaths = espptwcc_heuristic.labelNodes();			 
			 }
			 
			 else if (sppAlgorithm.equals("espptwcc_heur_fp_recomp")) {
				 ESPPTWCC_Heuristic_Recomputation espptwcc_heuristic_recomp = 
						 new ESPPTWCC_Heuristic_Recomputation(distmat, reducedCostsMatrix, orders, currentTime, 20);
				 newPaths = espptwcc_heuristic_recomp.labelNodes();			 
			 }
			 
			 else if (sppAlgorithm.equals("espptwcc_fp")) {
				 ESPPTWCC espptwcc = new ESPPTWCC(distmat, reducedCostsMatrix, orders, currentTime);
				 newPath = espptwcc.labelNodes();
			 }
		     
			 else if (sppAlgorithm.equals("spptwcc")) {
				 SPPTWCC spptwcc = new SPPTWCC(distmat, reducedCostsMatrix, orders, currentTime);
				 newPath = spptwcc.labelNodes();			 
			 }
			 
			 // 2-cycle elimination
			 else if (sppAlgorithm.equals("spptwcc2")) {
				 SPPTWCC2 spptwcc2 = new SPPTWCC2(distmat, reducedCostsMatrix, orders, currentTime);
				 newPath = spptwcc2.labelNodes();			 
			 }
			 
			 // 2-cycle elimination with nogo routes
			 else if (sppAlgorithm.equals("spptwcc2_heur")) {
				 double factor = 1.4;
				 SPPTWCC2_Experimental spptwcc2_experimental = new SPPTWCC2_Experimental(distmat, reducedCostsMatrix, orders, currentTime, factor);
				 newPath = spptwcc2_experimental.labelNodes();	 
			 }

			 // spptwcc nogo routes
			 else if (sppAlgorithm.equals("spptwcc_heur")) {
				 double factor = 1.4;
				 SPPTWCC_Experimental spptwcc_experimental = new SPPTWCC_Experimental(distmat, reducedCostsMatrix, orders, currentTime, factor);
				 newPath = spptwcc_experimental.labelNodes();	 
			 }
			 else return;
			 
			 // heuristic for espptwcc
			 //ESPPTWCC_Heuristic spptwcc_heu = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime);
			 //Path newPath = spptwcc_heu.labelNodes();
		     
			 if (!sppAlgorithm.equals("espptwcc_heur") && !sppAlgorithm.equals("espptwcc_heur_fp") && 
					 !sppAlgorithm.equals("espptwcc_heur_fp_recomp")) {
				 // check if path has negative reduced costs, if not exist loop
				 if (newPath.getReducedCosts() >= 0) break;
				 
				 paths.add(newPath);		 
			 }
			 else {
				 if (newPaths == null) {
					 break;
				 }
				 paths.addAll(newPaths);
			 }
		 }
		 
		 /**double[] relaxedValues = solveRelaxation();
		 for (int i = 0; i < relaxedValues.length; i++) {
			 System.out.println(i + " = " + relaxedValues[i]);
		 }*/
		 
		 // now optimize via branch and bound
		 int[] decision = solveMIP();
		 if (generateOutput) {
			 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen" + sppAlgorithm + ".csv", true);
			 writer.write((Math.floor(System.currentTimeMillis() - time) / 1000)+  "," + currentMIPCosts + "," + currentRelaxedCosts + "\n");
		     writer.close(); 
		 }
		 
	     System.out.println("Paths used with overlapping: " );

	     ArrayList<ArrayList<Integer>> routes = new ArrayList<ArrayList<Integer>>();

	     // form paths
	     for (int i = 0; i < paths.size(); i++) {
	    	 if (decision[i] == 1) {
	    		 int[][] arcsUsed = paths.get(i).getArcsUsed();
	    		 ArrayList<Integer> path = paths.get(i).getNodes();
	    		 ArrayList<Integer> newPath = new ArrayList<Integer>();
	    		 // eliminate duplicates except for the depot
	    		 for (Integer j : path) {
	    			 if (!newPath.contains(j) || j == 1) newPath.add(j);
	    		 }
	    		 routes.add(newPath);
	    		 System.out.print("Path id: " + i + " ### ");
	    		 for (int j : newPath) {
	    			 System.out.print(j + "->");
	    		 }
			     System.out.println();
	    	 }
	     }
	     
	     System.out.println("Final paths used: " );

	     // remove duplicate customers
	     routes = eliminateDuplicateCustomers(routes);
	     double costs = 0;
	     for (int i = 0; i < routes.size(); i++) {
	    	 for (int j = 0; j < routes.get(i).size(); j++) {
				 System.out.print(routes.get(i).get(j) + "->");
	    	 }
	    	 System.out.println();
			 costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, routes.get(i));
	     }
	     System.out.println("Final costs: "  + costs);
	     if (generateOutput) {
		     try {
				ModelHelperMethods.generateOutput(routes, compTimeLimit);
			} catch (Exception e) {
				e.printStackTrace();
			}
	     }
	     
	     // restart with current best solution
	     /**
	     paths = new ArrayList<Path>();
	     for (ArrayList<Integer> route : routes) {
	    	 double c = ModelHelperMethods.getRouteCostsIndexed0(distmat, route);
	    	 Path p = new Path(route, c, 0, distmat.getDimension());
	    	 paths.add(p);
	     }
	     
	     getRoutesInternal(compTimeLimit, sppAlgorithm, generateOutput);*/
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
}
