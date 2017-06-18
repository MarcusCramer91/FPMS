package optimization;

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

public class ColGenFrameworkTester {
	
	private DistanceMatrix distmat;
	private ArrayList<Order> orders;
	private int currentTime;
	private ArrayList<Path> paths;
	private double currentRelaxedCosts;
	private double currentMIPCosts;
	private String id;
	private int nPaths = 1;
	private double overallLowerBound = 0;
	private double overallUpperBound = Double.MAX_VALUE;
	private int branchCount = 0;
	private ArrayList<Integer[]> arcsBranchedOn;
	private double overallCosts = Double.MAX_VALUE;
	private ArrayList<ArrayList<Integer>> bestSolution;
	private long startingTime;
	private double initialCosts;
	private int treeDepthCovered = 0;
	private ArrayList<SearchTreeInstance> searchTreeInstances;
	 ArrayList<ArrayList<Double>> relaxedResults = new ArrayList<ArrayList<Double>>();

	public static void main(String[] args) throws Exception {
		//String[] approaches = {"espptwcc_heur", "espptwcc_heur_fp", "espptwcc_heur_fp_recomp", "spptwcc",
		//		"spptwcc2", "spptwcc_heur", "spptwcc2_heur"};
		//String[] approaches = {"espptwcc_heur", "espptwcc_heur_fp_recomp", "spptwcc",
		//		"spptwcc2", "spptwcc_heur", "spptwcc2_heur"};
		int currentTime = 30*60;
		int compTimeLimit = 600;
		int branchTimeLimit = 600;
		for (int i = 40; i <= 40; i += 10) {
			for (int j = 10; j <= 10; j++) {
				String searchMethod = "depth first";
				ArrayList<Order> orders = OrdersImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\Orders_"+i+"_"+j+".csv");
				DistanceMatrix distmat = new DistanceMatrix(
						 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\TravelTimes_"+i+"_"+j+".csv"));
				DistanceMatrix distmatair = new DistanceMatrix(
						 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\TravelTimes_"+i+"_"+j+".csv"));
				
				String id = "_whole_" + branchTimeLimit + searchMethod +  "_" + i + "_" + j;
				System.out.println("Current problem: " + id);
				ColGenFrameworkTester tester = new ColGenFrameworkTester(distmat, orders, currentTime, id);
							
				ArrayList<Order[]> initialPathsOrders = FPOptimize.assignRoutes(distmat, distmatair, orders, 10, currentTime, false, true);
				ArrayList<ArrayList<Integer>> initialPathsNodes = new ArrayList<ArrayList<Integer>>();
				for (int k = 0; k < initialPathsOrders.size(); k++) {
					Order[] current = initialPathsOrders.get(k);
					ArrayList<Integer> currentList = new ArrayList<Integer>();
					currentList.add(0);
					for (Order o : current) {
						currentList.add(o.getDistanceMatrixLink()-1);
					}
					currentList.add(distmat.getDimension());
					initialPathsNodes.add(currentList);
				    
				}
				distmat = distmat.insertDummyDepotAsFinalNode();
				distmat = distmat.addDepotLoadingTime(ModelConstants.DEPOT_LOADING_TIME);
				distmat = distmat.addCustomerServiceTimes(ModelConstants.REALISTIC_CUSTOMER_LOADING_TIME);
			    double costs = 0;
			    for (ArrayList<Integer> route : initialPathsNodes) {
				     costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);
			    }
				if (searchMethod.equals("depth first")) 
					tester.getRoutesWithFPInitial(distmat, branchTimeLimit, compTimeLimit, initialPathsNodes, false, costs);	
				if (searchMethod.equals("breadth first")) 
					tester.getRoutesWithFPInitialBreadthFirst(distmat, branchTimeLimit, compTimeLimit, initialPathsNodes, false, costs);
				
			}
		}
	}
	
	public ColGenFrameworkTester(DistanceMatrix distmat, ArrayList<Order> orders, 
			   int currentTime, String id) {
		this.distmat = distmat;
		this.orders = orders;
		this.currentTime = currentTime;
		this.paths = new ArrayList<Path>();
		this.id = id;
		this.arcsBranchedOn = new ArrayList<Integer[]>();
	}
	
	public void getRoutesWithFPInitial(DistanceMatrix distmat, int branchTimeLimit, int compTimeLimit, 
			ArrayList<ArrayList<Integer>> initialPaths, 
			boolean generateOutput, double initialCosts) throws IloException, IOException {
		 ArrayList<Path> paths = new ArrayList<Path>();
		 this.initialCosts = initialCosts;
		 
		 int nLocations = distmat.getDimension();
		 double costs = 0;
		 for (int i = 0; i < initialPaths.size(); i++) {
			 Path p = new Path(initialPaths.get(i), ModelHelperMethods.getRouteCostsIndexed0(distmat, initialPaths.get(i)), 0, 
					 nLocations);
			 paths.add(p);
			 costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, p.getNodes());
		 }
		 this.startingTime = System.currentTimeMillis();

		 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\framework\\" + id + ".csv", true);
		 writer.write((Math.floor(System.currentTimeMillis() - startingTime) / 1000)+  "," + costs + "," + costs + "\n");
	     writer.close();
	     
		 getRoutesInternal(paths, distmat, branchTimeLimit, compTimeLimit, generateOutput, 0, true);
		 System.out.println();
		 System.out.println("########################################");
		 System.out.println();
		 System.out.println("Search tree branches explored: " + branchCount);
		 System.out.println("Optimal integer costs: " + overallUpperBound);
		 System.out.println("Optimal costs with duplicates eliminated: " + overallCosts);
		 System.out.println("Optimal route configuration");
		 for (ArrayList<Integer> route : bestSolution) {
			 for (int i = 0; i < route.size()-1; i++) {
				 System.out.print(route.get(i) + "->");
			 }
			 System.out.println("1");
		 }
		 System.out.println("Improvement compared to initial: " + (initialCosts-overallUpperBound)/initialCosts + "%");
		 System.out.println("Overall time used: " + Math.round((System.currentTimeMillis() - startingTime) / 1000) + " seconds");
	}

	public void getRoutesWithFPInitialBreadthFirst(DistanceMatrix distmat, int branchTimeLimit, int compTimeLimit, 
			ArrayList<ArrayList<Integer>> initialPaths, 
			boolean generateOutput, double initialCosts) throws IloException, IOException {
		 ArrayList<Path> paths = new ArrayList<Path>();
		 this.initialCosts = initialCosts;
		 
		 int nLocations = distmat.getDimension();
		 for (int i = 0; i < initialPaths.size(); i++) {
			 Path p = new Path(initialPaths.get(i), ModelHelperMethods.getRouteCostsIndexed0(distmat, initialPaths.get(i)), 0, 
					 nLocations);
			 paths.add(p);
		 }
		 searchTreeInstances = new ArrayList<SearchTreeInstance>();
		 double relaxedResult = getRoutesInternalBreadthFirst(paths, distmat, branchTimeLimit, generateOutput, 0);
		 // stores the lower bound per tree level
		 ArrayList<ArrayList<Double>> relaxedResults = new ArrayList<ArrayList<Double>>();
		 overallLowerBound = relaxedResult;
		 relaxedResults.add(new ArrayList<>());
		 relaxedResults.get(0).add(relaxedResult);
		 relaxedResults.add(new ArrayList<>());
		 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\framework\\" + id + ".csv", true);
		 writer.write((Math.floor(System.currentTimeMillis() - startingTime) / 1000)+  "," + overallLowerBound + "," + overallUpperBound + "\n");
	     writer.close();

		 int currentLevel = 1;
		 while(searchTreeInstances.get(0) != null && (System.currentTimeMillis() - startingTime) < compTimeLimit * 1000) {
			 SearchTreeInstance sti = searchTreeInstances.get(0);
			 searchTreeInstances.remove(0);
			 
			 // update lower bound
			 if (sti.getTreeDepth() > currentLevel) {
				 relaxedResults.add(new ArrayList<Double>());
				 // find lowest relaxed result from the current level of the tree
				 double lowest = Double.MAX_VALUE;
				 for (double d : relaxedResults.get(currentLevel)) {
					 if (lowest > d) lowest = d;
				 }
				 overallLowerBound = lowest;
				 currentLevel++;
			 }
			 
			 relaxedResult = getRoutesInternalBreadthFirst(sti.getPaths(), sti.getDistmat(), sti.getBranchTimeLimit(), sti.isGenerateOutput(),
					 sti.getTreeDepth());

			 writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\framework\\" + id + ".csv", true);
			 writer.write((Math.floor(System.currentTimeMillis() - startingTime) / 1000)+  "," + overallLowerBound + "," + overallUpperBound + "\n");
		     writer.close();
			 if (relaxedResult != -1) relaxedResults.get(currentLevel).add(relaxedResult);
		 }
	}
	
	@SuppressWarnings("unused")
	private void getRoutesInternal(ArrayList<Path> paths, DistanceMatrix distmat, int branchTimeLimit, int compTimeLimit, 
			boolean generateOutput, int treeDepth, 
			boolean currentTreeLevelSearched) throws IloException, IOException {
		 if (System.currentTimeMillis() - startingTime > compTimeLimit * 1000) return;
		 long time = System.currentTimeMillis();
		 branchCount++;
		 int iterationCount = 0;
		 double[] duals = null;
		 double currentRelaxedResult = 99999;
		 ArrayList<Integer> previousBestPath = null;
		 
		 // track convergence: how often did the best returned path equal
		 // if this exceeds 5 times, break
		 int convergenceCount = 0;
		 double[] dualResult = null;
		 // column generation 
		 while((System.currentTimeMillis() - time) < branchTimeLimit*1000 &&
	    		 System.currentTimeMillis() - startingTime < compTimeLimit * 1000) {
			 iterationCount++;
		     // get duals
			 dualResult = solveDual(distmat, paths);
			 
			 if (dualResult == null) break;
			 
			 // save current lower bound
			 currentRelaxedResult = dualResult[dualResult.length-1];
			 duals = new double[dualResult.length-1];
			 for (int i = 0; i < duals.length; i++) {
				 duals[i] = dualResult[i];
			 }
		     
		     // compute reduced costs for arcs
		     double[] reducedCosts = new double[distmat.getAllEntries().length];
			 for (int i = 0; i < reducedCosts.length; i++) {
				 reducedCosts[i] = distmat.getAllEntries()[i];
			 }
			 DistanceMatrix reducedCostsMatrix = new DistanceMatrix(reducedCosts);
			 reducedCostsMatrix.subtractDuals(duals);
			 
			 // solve pricing problem
			 ESPPTWCC_Heuristic espptwcc_heuristic = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime, nPaths, true);
			 ArrayList<Path> newPaths = espptwcc_heuristic.labelNodes();
			 //System.out.println("Reduced costs of the best found new path in iteration " + iterationCount +": "+ newPaths.get(0).getReducedCosts());
			 
			 
			 
			 // if no new paths returned break
			 if (newPaths == null) break;
			 
			 // print the best found new path
			 /**for (int i = 0; i < newPaths.get(0).getNodes().size(); i++) {
				 System.out.print(newPaths.get(0).getNodes().get(i) + "->");
			 }
			 System.out.println();
			 System.out.println("Costs for new path: " + newPaths.get(0).getCosts());*/
			 
			 if (previousBestPath == null || !ModelHelperMethods.samePath(previousBestPath, newPaths.get(0).getNodes())) {
				 previousBestPath = newPaths.get(0).getNodes();
				 convergenceCount = 0;
			 }
			 else break;
			 
			 paths.addAll(newPaths);
			 
			 
			 // LOGGING

			 // store current upper bound 
			 double[] mipResult = solveMIP(distmat, paths);
			 double currentMIPResult = mipResult[mipResult.length-1];
			 int[] decision = new int[mipResult.length-1];
			 for (int i = 0; i < decision.length; i++) {
				 if (mipResult[i] == 0) decision[i] = 0;
				 else decision[i] = 1;
			 }
			 
		     ArrayList<ArrayList<Integer>> routes = computeSolution(distmat, decision, paths);
		     double costs = 0;
		     //System.out.println("Integer solution:");
		     for (ArrayList<Integer> route : routes) {
		    	 //for (int i : route) System.out.print(i + "->");
			     //System.out.println();
			     costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);
		     }
		     
		     if (isValidSolution(routes, distmat) && costs < overallCosts) {
		    	 overallCosts = costs;
		    	 bestSolution = routes;
		     }
		     
		     if (costs < overallUpperBound) overallUpperBound = costs;
		     
			 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\framework\\" + id + ".csv", true);
			 writer.write((Math.floor(System.currentTimeMillis() - startingTime) / 1000)+  "," + overallLowerBound + "," + overallUpperBound + "\n");
		     writer.close();
		 }
		 
		 if (relaxedResults.size() <= treeDepth) relaxedResults.add(new ArrayList<Double>());
		 relaxedResults.get(treeDepth).add(currentRelaxedResult);
		 
		 double[] relaxedDecision = solveRelaxation(distmat, paths);
		 if (relaxedDecision == null) {
			 return;
		 }
	     /**System.out.println("Relaxed solution:");
		 for (int i = 0; i < relaxedDecision.length; i++) {
			 if (relaxedDecision[i] > 0) System.out.println("Decision for path " + i + ": " + relaxedDecision[i]);
		 }*/
		 
		 // now optimize via branch and bound
		 double[] mipResult = solveMIP(distmat, paths);
		 
		 // store current upper bound 
		 double currentMIPResult = mipResult[mipResult.length-1];
		 int[] decision = new int[mipResult.length-1];
		 for (int i = 0; i < decision.length; i++) {
			 if (mipResult[i] == 0) decision[i] = 0;
			 else decision[i] = 1;
		 }
		 
	     ArrayList<ArrayList<Integer>> routes = computeSolution(distmat, decision, paths);
	     double costs = 0;
	     //System.out.println("Integer solution:");
	     for (ArrayList<Integer> route : routes) {
	    	 //for (int i : route) System.out.print(i + "->");
		     //System.out.println();
		     costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);
	     }
	     
	     if (isValidSolution(routes, distmat) && costs < overallCosts) {
	    	 overallCosts = costs;
	    	 bestSolution = routes;
	     }

	     // update best bounds
	     if (currentTreeLevelSearched) {
	    	 // find lowest relaxed result of current tree depth
	    	 ArrayList<Double> currentDepthValues = relaxedResults.get(treeDepth);
	    	 double lowest = Double.MAX_VALUE;
	    	 for (double d : currentDepthValues) {
	    		 if (d < lowest) lowest = d;
	    	 }
	    	 overallLowerBound = lowest;
	    	 currentTreeLevelSearched = false;
	     }
	     if (costs < overallUpperBound) overallUpperBound = costs;
	     
	     // check convergence of this branch
	     // this branch is obsolete if its lower bound is higher than the best upper bound
	     // floor because cplex solutions apparently have rounding errors
	     if (Math.floor(currentRelaxedResult) > overallUpperBound) {
	    	 return;
	     }
	     // do depth first with variables set to 1
	     int[] branchingVariable = findBranchVariable(distmat, relaxedDecision, paths);

	     
	     // if no more branching can be done return
	     if (branchingVariable[0] == -1) return;
	     // branch with set to 1
	     ArrayList<Path> paths1 = removeConflictingColumns(distmat, branchingVariable[0], branchingVariable[1], true, paths);
	     DistanceMatrix distmat1 = penalizeArcsInDistanceMatrix(distmat, branchingVariable[0], branchingVariable[1], true);
	     getRoutesInternal(paths1, distmat1, branchTimeLimit, compTimeLimit, generateOutput, treeDepth + 1, currentTreeLevelSearched);
		    
	     // checks whether the overallLowerBound can be updated
	     if (this.treeDepthCovered == treeDepth) {
	    	 this.treeDepthCovered++;
	    	 currentTreeLevelSearched = true;
	     }
	     
	     // branch with set to 0
	     ArrayList<Path> paths0 = removeConflictingColumns(distmat, branchingVariable[0], branchingVariable[1], false, paths);
	     DistanceMatrix distmat0 = penalizeArcsInDistanceMatrix(distmat, branchingVariable[0], branchingVariable[1], false);
	     getRoutesInternal(paths0, distmat0, branchTimeLimit, compTimeLimit, generateOutput, treeDepth + 1, currentTreeLevelSearched);  
	}
	
	@SuppressWarnings("unused")
	private double getRoutesInternalBreadthFirst(ArrayList<Path> paths, DistanceMatrix distmat, int branchTimeLimit, 
			boolean generateOutput, int treeDepth) throws IloException, IOException {
		 long time = System.currentTimeMillis();
		 branchCount++;
		 int iterationCount = 0;
		 double[] duals = null;
		 double currentRelaxedResult = 99999;
		 ArrayList<Integer> previousBestPath = null;
		 
		 // track convergence: how often did the best returned path equal
		 // if this exceeds 5 times, break
		 int convergenceCount = 0;
		 double[] dualResult = null;
		 // column generation 
		 while((System.currentTimeMillis() - time) < branchTimeLimit*1000) {
			 iterationCount++;
		     // get duals
			 dualResult = solveDual(distmat, paths);
			 
			 if (dualResult == null) break;
			 
			 // save current lower bound
			 currentRelaxedResult = dualResult[dualResult.length-1];
			 duals = new double[dualResult.length-1];
			 for (int i = 0; i < duals.length; i++) {
				 duals[i] = dualResult[i];
			 }
		     
		     if ((System.currentTimeMillis() - time) > branchTimeLimit *1000) break;
		     
		     // compute reduced costs for arcs
		     double[] reducedCosts = new double[distmat.getAllEntries().length];
			 for (int i = 0; i < reducedCosts.length; i++) {
				 reducedCosts[i] = distmat.getAllEntries()[i];
			 }
			 DistanceMatrix reducedCostsMatrix = new DistanceMatrix(reducedCosts);
			 reducedCostsMatrix.subtractDuals(duals);
			 
			 // solve pricing problem
			 ESPPTWCC_Heuristic espptwcc_heuristic = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime, nPaths, true);
			 ArrayList<Path> newPaths = espptwcc_heuristic.labelNodes();
			 //System.out.println("Reduced costs of the best found new path in iteration " + iterationCount +": "+ newPaths.get(0).getReducedCosts());
			 
			 
			 
			 // if no new paths returned break
			 if (newPaths == null) break;
			 
			 // print the best found new path
			 /**for (int i = 0; i < newPaths.get(0).getNodes().size(); i++) {
				 System.out.print(newPaths.get(0).getNodes().get(i) + "->");
			 }
			 System.out.println();
			 System.out.println("Costs for new path: " + newPaths.get(0).getCosts());*/
			 
			 if (previousBestPath == null || !ModelHelperMethods.samePath(previousBestPath, newPaths.get(0).getNodes())) {
				 previousBestPath = newPaths.get(0).getNodes();
				 convergenceCount = 0;
			 }
			 else break;
			 
			 paths.addAll(newPaths);
		 }
		 
		 // if dual has no result, final node is reached
		 if (dualResult == null)  return -1;
		 
		 double[] relaxedDecision = solveRelaxation(distmat, paths);
		 if (relaxedDecision == null) {
			 System.out.println("FINAL NODE REACHED IN THIS BRANCH");
			 return -1;
		 }
	     /**System.out.println("Relaxed solution:");
		 for (int i = 0; i < relaxedDecision.length; i++) {
			 if (relaxedDecision[i] > 0) System.out.println("Decision for path " + i + ": " + relaxedDecision[i]);
		 }*/
		 
		 // now optimize via branch and bound
		 double[] mipResult = solveMIP(distmat, paths);
		 
		 // store current upper bound 
		 double currentMIPResult = mipResult[mipResult.length-1];
		 int[] decision = new int[mipResult.length-1];
		 for (int i = 0; i < decision.length; i++) {
			 if (mipResult[i] == 0) decision[i] = 0;
			 else decision[i] = 1;
		 }
		 
	     ArrayList<ArrayList<Integer>> routes = computeSolution(distmat, decision, paths);
	     double costs = 0;
	     //System.out.println("Integer solution:");
	     for (ArrayList<Integer> route : routes) {
	    	 //for (int i : route) System.out.print(i + "->");
		     //System.out.println();
		     costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);
	     }
	     
	     if (isValidSolution(routes, distmat) && costs < overallCosts) {
	    	 overallCosts = costs;
	    	 bestSolution = routes;
	     }

	     if (currentMIPResult < overallUpperBound) overallUpperBound = currentMIPResult;
	     
	     // check convergence of this branch
	     // this branch is obsolete if its lower bound is higher than the best upper bound
	     // floor because cplex solutions apparently have rounding errors
	     if (Math.floor(currentRelaxedResult) > overallUpperBound) {
	    	 return currentRelaxedResult;
	     }

	     // do depth first with variables set to 1
	     int[] branchingVariable = findBranchVariable(distmat, relaxedDecision, paths);
	     
	     // if no more branching can be done return
	     if (branchingVariable[0] == -1) return -1;
	     
	     // branch with set to 1
	     ArrayList<Path> paths1 = removeConflictingColumns(distmat, branchingVariable[0], branchingVariable[1], true, paths);
	     DistanceMatrix distmat1 = penalizeArcsInDistanceMatrix(distmat, branchingVariable[0], branchingVariable[1], true);
	     
	     SearchTreeInstance sti = new SearchTreeInstance(paths1, distmat1, branchTimeLimit, generateOutput, treeDepth+1);
	     searchTreeInstances.add(sti);
	     
	     // branch with set to 0
	     ArrayList<Path> paths0 = removeConflictingColumns(distmat, branchingVariable[0], branchingVariable[1], false, paths);
	     DistanceMatrix distmat0 = penalizeArcsInDistanceMatrix(distmat, branchingVariable[0], branchingVariable[1], false);
	     SearchTreeInstance sti2 = new SearchTreeInstance(paths0, distmat0, branchTimeLimit, generateOutput, treeDepth+1);
	     searchTreeInstances.add(sti2);
	     return currentRelaxedResult;
	}

	private double[] solveDual(DistanceMatrix distmat, ArrayList<Path> paths) throws IloException {
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

	     if (!cplex.solve()) return null;
	     double[] result = new double[nCustomers+2];
	     result[0] = 0;
	     for (int i = 0; i < nCustomers; i++) {
	    	 result[i+1] = cplex.getValue(pi[i]);
	    	 // System.out.println("pi_"+ (i+2) + "=" + cplex.getValue(pi[i]));
	     }
	     
	     // log objective value
	     result[nCustomers+1] = cplex.getObjValue();
	     cplex.end();
	     return result;
	}
	
	private double[] solveMIP(DistanceMatrix distmat, ArrayList<Path> paths) throws IloException {
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
	     double[] decision = new double[y.length+1];
	     for (int i = 0; i < y.length; i++) {
	    	 if (Math.round(cplex.getValue(y[i])) == 1) decision[i] = 1;
	     }
	     decision[y.length] = cplex.getObjValue();
	     //System.out.println("Costs: " + cplex.getObjValue());
	     cplex.end();
	     return decision;
	}
	
	private double[] solveRelaxation(DistanceMatrix distmat, ArrayList<Path> paths) throws IloException {
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
	     if (!cplex.solve()) return null;
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
	     cplex.end();
	     return result;
	}
	
	private ArrayList<ArrayList<Integer>> eliminateDuplicateCustomers(DistanceMatrix distmat, ArrayList<ArrayList<Integer>> routes) {
		
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
		return eliminateDuplicateCustomersBranchingStep(distmat, routes, duplicatesMap);
	}
	
	private ArrayList<ArrayList<Integer>> eliminateDuplicateCustomersBranchingStep(DistanceMatrix distmat, ArrayList<ArrayList<Integer>> routes,
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
			ArrayList<ArrayList<Integer>> newRoutes = eliminateDuplicateCustomersBranchingStep(distmat, routesCopy, mapCopy);
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
	
	private ArrayList<ArrayList<Integer>> computeSolution(DistanceMatrix distmat, int[] decision, ArrayList<Path> paths) {
		ArrayList<ArrayList<Integer>> routes = new ArrayList<ArrayList<Integer>>();

	     // form paths
	     for (int i = 0; i < paths.size(); i++) {
	    	 if (decision[i] == 1) {
	    		 ArrayList<Integer> path = paths.get(i).getNodes();
	    		 ArrayList<Integer> newPath = new ArrayList<Integer>();
	    		 // eliminate duplicates except for the depot
	    		 for (Integer j : path) {
	    			 if (!newPath.contains(j) || j == 1) newPath.add(j);
	    		 }
	    		 routes.add(newPath);
	    	 }
	     }
	     // remove duplicate customers
	     routes = eliminateDuplicateCustomers(distmat, routes);
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
	
	/**
	 * Penalizes column (paths) that violate a 0 or 1 restriction applied in the branching scheme
	 * @param from
	 * @param to
	 * @param active
	 */
	private ArrayList<Path> removeConflictingColumns(DistanceMatrix distmat, int from, int to, boolean active, ArrayList<Path> paths) {
		if (branchCount == 4) {
			System.out.println();
		}
		// copy paths
		ArrayList<Path> pathCopy = new ArrayList<Path>();
		for (Path p : paths) {
			Path p2 = new Path(p.getNodes(), p.getCosts(), p.getReducedCosts(), distmat.getDimension());
			pathCopy.add(p2);
		}
		int removalCounter = 0;
		for (int p = 0; p < pathCopy.size(); p++) {
			// if the arc is set to inactive, all paths that use this arc are penalized
			ArrayList<Integer> nodes = pathCopy.get(p).getNodes();
			if (!active) {
				for (int i = 1; i < nodes.size()-2; i++) {
					if (nodes.get(i) == from && nodes.get(i+1) == to) {
						pathCopy.remove(p);
						p--;
						removalCounter++;
						break;
					}
				}		
			}
			// if the arc is set to active, all paths that contain either "from" or "to" but not in direct
			// succeeding order are penalized
			else {
				for (int i = 1; i < nodes.size()-2; i++) {
					if (nodes.get(i) == from && nodes.get(i+1) != to) {
						pathCopy.remove(p);
						p--;
						removalCounter++;
						break;
					}
					else if (i > 0 && nodes.get(i) == to && nodes.get(i-1) != from) {
						pathCopy.remove(p);
						p--;
						removalCounter++;
						break;
					}
				}
			}
		}
		return pathCopy;
	}
	
	/**
	 * "Disables" arcs in the distance matrix by setting their entry very high
	 * This results in infeasible paths whenever this arc is taken
	 * @param from
	 * @param to
	 * @param active
	 */
	private DistanceMatrix penalizeArcsInDistanceMatrix(DistanceMatrix distmat, int from, int to, boolean active) {
		double penaltyCosts = 100000;
		// copy distance matrix
		double[] entries = distmat.getAllEntries();
		double[] newEntries = new double[entries.length];
		for (int i = 0; i < entries.length; i++) {
			newEntries[i] = entries[i];
		}
		DistanceMatrix distmatCopy = new DistanceMatrix(newEntries);
		// if inactive, set c_from,to very high
		if (!active) {
			distmatCopy.setEntry(penaltyCosts, from+1, to+1);
			return distmatCopy;
		}
		// if active penalize all outgoing arcs of "from" except to "to"
		// and all incoming arcs to "to" except from "from"
		else {
			for (int i = 1; i < distmat.getDimension()-1; i++) {
				if (i != from) distmatCopy.setEntry(penaltyCosts, i+1, to+1);
				if (i != to) distmatCopy.setEntry(penaltyCosts, from+1, i+1);
			}
		}
		return distmatCopy;
	}
	
	/**
	 * Finds the flow variable to branch on based on the score proposed by Kallehauge et al. 2006
	 * @param distmat
	 * @return
	 */
	private int[] findBranchVariable(DistanceMatrix distmat, double[] relaxedDecision, ArrayList<Path> paths) {
		double maxScore = 0;
		int maxScoreFrom = -1;
		int maxScoreTo = -1;
		for (int p = 0; p < paths.size(); p++) {
			// if dual is positive and not integer
			if (relaxedDecision[p] > 0 && relaxedDecision[p] != Math.floor(relaxedDecision[p])) {
				ArrayList<Integer> nodes = paths.get(p).getNodes();
				for (int i = 1; i < nodes.size()-2; i++) {
					// check if this arc has already been branched on
					boolean branchedOn = false;
					for (int j = 0; j < arcsBranchedOn.size(); j++) {
						if (arcsBranchedOn.get(j)[0] == nodes.get(i) && arcsBranchedOn.get(j)[1] == nodes.get(i+1)) {
							branchedOn = true;
							break;
						}
					}
					if (branchedOn) continue;
					double score = Math.min(relaxedDecision[p], 1-relaxedDecision[p]) * distmat.getEntry(nodes.get(i)+1, nodes.get(i+1)+1);
					if (score > maxScore) {
						maxScore = score;
						maxScoreFrom = nodes.get(i);
						maxScoreTo = nodes.get(i+1);
					}
				}
			}
		}
		arcsBranchedOn.add(new Integer[]{maxScoreFrom, maxScoreTo});
		return new int[]{maxScoreFrom, maxScoreTo};
	}
	
	/**
	 * Required because cplex is buggy apparently
	 * @return
	 */
	private boolean isValidSolution(ArrayList<ArrayList<Integer>> solution, DistanceMatrix distmat) {
		int count = 0;
		for (ArrayList<Integer> list : solution) count += list.size()-2;
		if (count == distmat.getDimension()-2) return true;
		else return false;
	}
	
	private class SearchTreeInstance {
		ArrayList<Path> paths;

		DistanceMatrix distmat;
		int branchTimeLimit;
		boolean generateOutput;
		int treeDepth;
		
		SearchTreeInstance(ArrayList<Path> paths, DistanceMatrix distmat, int branchTimeLimit, 
			boolean generateOutput, int treeDepth) {
			this.paths = paths;
			this.distmat = distmat;
			this.branchTimeLimit = branchTimeLimit;
			this.generateOutput = generateOutput;
			this.treeDepth = treeDepth;
		}
		public ArrayList<Path> getPaths() {
			return paths;
		}

		public void setPaths(ArrayList<Path> paths) {
			this.paths = paths;
		}

		public DistanceMatrix getDistmat() {
			return distmat;
		}

		public void setDistmat(DistanceMatrix distmat) {
			this.distmat = distmat;
		}

		public int getBranchTimeLimit() {
			return branchTimeLimit;
		}

		public void setBranchTimeLimit(int branchTimeLimit) {
			this.branchTimeLimit = branchTimeLimit;
		}

		public boolean isGenerateOutput() {
			return generateOutput;
		}

		public void setGenerateOutput(boolean generateOutput) {
			this.generateOutput = generateOutput;
		}

		public int getTreeDepth() {
			return treeDepth;
		}

		public void setTreeDepth(int treeDepth) {
			this.treeDepth = treeDepth;
		}

	}
}

