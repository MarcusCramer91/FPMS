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
	private int nVehicles;
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
		int compTimeLimit = 300;
		CPLEXColumnGeneration colgen = new CPLEXColumnGeneration(distmat, orders, distmat.getDimension()-1, currentTime);
		// initialize with flaschenpost
		/**
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
		colgen.getRoutesWithFPInitial(compTimeLimit, initialPathsNodes);*/
		
		colgen.getRoutes(compTimeLimit);
	}
	
	public CPLEXColumnGeneration(DistanceMatrix distmat, ArrayList<Order> orders, int nVehicles, 
			   int currentTime) {
		this.distmat = distmat;
		this.orders = orders;
		this.nVehicles = nVehicles;
		this.currentTime = currentTime;
		this.paths = new ArrayList<Path>();
	}
	
	public void getRoutesWithFPInitial(int compTimeLimit, ArrayList<ArrayList<Integer>> initialPaths) throws IloException, IOException {
		 distmat = distmat.insertDummyDepotAsFinalNode();
		 distmat = distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
		 distmat = distmat.addCustomerServiceTimes(ModelConstants.REALISTIC_CUSTOMER_LOADING_TIME);
		 
		 int nLocations = distmat.getDimension();
		 for (int i = 0; i < initialPaths.size(); i++) {
			 Path p = new Path(initialPaths.get(i), ModelHelperMethods.getRouteCostsIndexed0(distmat, initialPaths.get(i)), 0, 
					 nLocations);
			 paths.add(p);
		 }
		 getRoutesInternal(compTimeLimit);
	}
	
	public void getRoutes(int compTimeLimit) throws IloException, IOException {
		
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
		 getRoutesInternal(compTimeLimit);
	}
	
	private void getRoutesInternal(int compTimeLimit) throws IloException, IOException {
		 long time = System.currentTimeMillis();
		 int iterationCount = 0;
		 
		 // column generation 
		 while((System.currentTimeMillis() - time) < compTimeLimit*1000) {
			 iterationCount++;
			 if (iterationCount == 215) {
				 System.out.println("halo");
			 }
			 System.out.println(iterationCount);
		     
		     // log information
		     int decision[] = solveMIP();
		     ArrayList<ArrayList<Integer>> routes = computeSolution(decision);
		     double costs = 0;
		     System.out.println("Decision in this iteration");
		     for (int i = 0; i < routes.size(); i++) {
		    	 for (int j = 0; j < routes.get(i).size(); j++) {
					 System.out.print(routes.get(i).get(j) + "->");
		    	 }
		    	 System.out.println();
				 costs += ModelHelperMethods.getRouteCosts(distmat, routes.get(i));
		     }
		     solveRelaxation();
			 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen_spptwcc_heuristic.csv", true);
			 writer.write((Math.floor(System.currentTimeMillis() - time) / 1000)+  "," + costs + "," + currentRelaxedCosts + "\n");
		     writer.close();
		     
		     // get duals
		     double[] duals = solveDual();
		     //double[] duals = solveDualWithIntegerDecision(decision);
		     
		     
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
			 
			 //SPPTWCC spptwcc = new SPPTWCC(distmat, reducedCostsMatrix, orders, currentTime);
			 //Path newPath = spptwcc.labelNodes();
			 
			 // 2-cycle elimination
			 //SPPTWCC2 spptwcc2 = new SPPTWCC2(distmat, reducedCostsMatrix, orders, currentTime);
			 // Path newPath = spptwcc2.labelNodes();
			 
			 // heuristic for espptwcc
			 ESPPTWCC_Heuristic spptwcc_heu = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime);
			 Path newPath = spptwcc_heu.labelNodes();
		     
			 // check if path has negative reduced costs, if not exist loop
			 if (newPath.getReducedCosts() >= 0) break;
			 
			 paths.add(newPath);
		 }
		 
		 solveRelaxation();
		 
		 // now optimize via branch and bound
		 int[] decision = solveMIP();
		 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen_spptwcc_heuristic.csv", true);
		 writer.write((Math.floor(System.currentTimeMillis() - time) / 1000)+  "," + currentMIPCosts + "," + currentRelaxedCosts + "\n");
	     writer.close(); 
		 
	     System.out.println("Paths used with overlapping: " );

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
			 costs += ModelHelperMethods.getRouteCosts(distmat, routes.get(i));
	     }
	     System.out.println("Final costs: "  + costs);
	     
	     try {
			ModelHelperMethods.generateOutput(routes, compTimeLimit);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private double[] solveDual() throws IloException {
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 IloCplex cplex = new IloCplex();
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
		    	 for (int j = 0; j < nLocations; j++) {
		    		 expr.addTerm(paths.get(p).getArcsUsed()[i][j], y[p]);
		    	 }
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
	
	private int[] solveMIPAlternative() throws IloException {
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 IloCplex cplex = new IloCplex();
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
		    	 for (int j = 0; j < nLocations; j++) {
		    		 expr.addTerm(1.0, y[p]);
		    	 }
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
		     constraints.add(cplex.addEq(1.0, expr));
	     }
	     cplex.solve();
	     /**
	     for (int p = 0; p < paths.size(); p++) {
	    	 System.out.println("Decision for path " + p + " = " + cplex.getValue(y[p]));
	     }*/
	     
	     //System.out.println("Relaxed costs = " + cplex.getObjValue());
	     
	     double[] duals = new double[y.length];
	     for (int i = 0; i < nCustomers; i++) {
	    	 duals[i] = cplex.getDual(constraints.get(i));
	    	 //System.out.println("pi_" + i + "=" + duals[i]);
	     }
	     currentRelaxedCosts = cplex.getObjValue();
	     cplex.end();
	     return duals;
	}
	
	private double[] solveRelaxationWithConstraints(int[] decision) throws IloException {
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 IloCplex cplex = new IloCplex();
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
		     constraints.add(cplex.addEq(1.0, expr));
	     }
	     
	     // add constraints
	     for (int p = 0; p < Math.floor(paths.size()/2); p++) {
	    	 if (decision[p] == 1) {
	    		 IloLinearNumExpr expr = cplex.linearNumExpr();
	    		 expr.addTerm(1.0, y[p]);
	    		 cplex.addGe(expr, 0.5);
	    	 }
	     }
	     
	     cplex.solve();
	     
	     
	     
	     double[] duals = new double[y.length];
	     for (int i = 0; i < nCustomers; i++) {
	    	 duals[i] = cplex.getDual(constraints.get(i));
	    	 System.out.println("pi_" + i + "=" + duals[i]);
	     }
	     cplex.end();
	     return duals;
	}

	private double[] solveDualWithIntegerDecision(int[] decision) throws IloException {
		 int nLocations = distmat.getDimension();
		 int nCustomers = nLocations - 2;
		 IloCplex cplex = new IloCplex();
		 cplex.setOut(null);
		 
		 // determine number of decisions = 1 for fixing constraints
		 int nDecisions = 0;
	     for (int i = 0; i < decision.length; i++) {
	    	 nDecisions += decision[i];
	     }
		 
		 IloNumVar[] pi = cplex.numVarArray(nCustomers+nDecisions, 0.0, Double.MAX_VALUE);
			
		 // build objective function
	     IloLinearNumExpr obj = cplex.linearNumExpr();	
	     for (int i = 0; i < nCustomers; i++) {
	         obj.addTerm(1.0, pi[i]);
	     }
	     
	     // add PIs for fixing integer decisions
	     for (int i = nCustomers; i < pi.length; i++) {
	    	 if (decision[i] == 1) obj.addTerm(1.0, pi[i]);
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
	    	 //System.out.println("pi_"+ (i+2) + "=" + cplex.getValue(pi[i]));
	     }
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
			for (int j = 0; j < route.size()-1; j++) {
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
			
			// calculate costs
			double totalCosts = 0;
			for (int j = 0; j < newRoutes.size(); j++) {
				totalCosts += ModelHelperMethods.getRouteCosts(distmat, newRoutes.get(i));
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
