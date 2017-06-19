package optimization;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
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

public class ColGenFrameworkTesterStabilized {
	
	private DistanceMatrix distmat;
	private ArrayList<Order> orders;
	private int currentTime;
	private ArrayList<Path> paths;
	private double currentRelaxedCosts;
	private double currentMIPCosts;
	private String id;
	private double overallLowerBound = 0;
	private double overallUpperBound = Double.MAX_VALUE;
	private int branchCount = 0;
	private ArrayList<Integer[]> arcsBranchedOn;
	private double overallCosts = Double.MAX_VALUE;
	private ArrayList<ArrayList<Integer>> bestSolution;
	private long startingTime;
	private double initialCosts;
	private int treeDepthCovered = 0;
	private int nVehicles;
	private ArrayList<ArrayList<Double>> relaxedResults = new ArrayList<ArrayList<Double>>();
	private double initialMuValues;
	private double initialMuDepotValue;
	private int[] treeLevelCoverage;

	public static void main(String[] args) throws Exception {
		//String[] approaches = {"espptwcc_heur", "espptwcc_heur_fp", "espptwcc_heur_fp_recomp", "spptwcc",
		//		"spptwcc2", "spptwcc_heur", "spptwcc2_heur"};
		//String[] approaches = {"espptwcc_heur", "espptwcc_heur_fp_recomp", "spptwcc",
		//		"spptwcc2", "spptwcc_heur", "spptwcc2_heur"};
		int currentTime = 30*60;
		int compTimeLimit = 600;
		int branchTimeLimit = 600;
		for (int i = 20; i <= 50; i += 10) {
			for (int j = 1; j <= 10; j++) {
				String searchMethod = "depth first";
				ArrayList<Order> orders = OrdersImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\Orders_"+i+"_"+j+".csv");
				DistanceMatrix distmat = new DistanceMatrix(
						 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\TravelTimes_"+i+"_"+j+".csv"));
				DistanceMatrix distmatair = new DistanceMatrix(
						 DistanceMatrixImporter.importCSV("C:\\Users\\Marcus\\Documents\\FPMS\\data\\testcases\\TravelTimes_"+i+"_"+j+".csv"));
				
				String id = "_whole_" + branchTimeLimit + searchMethod +  "_" + i + "_" + j;
				System.out.println("Current problem: " + id);
				ColGenFrameworkTesterStabilized tester = new ColGenFrameworkTesterStabilized(distmat, orders, currentTime, id);
							
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
				tester.getRoutes(distmat, branchTimeLimit, compTimeLimit, initialPathsNodes, false, costs);	
				
			}
		}
	}
	
	
	public ColGenFrameworkTesterStabilized(DistanceMatrix distmat, ArrayList<Order> orders, 
			   int currentTime, String id) {
		this.id = id;
		this.orders = orders;
		this.currentTime = currentTime;
		this.arcsBranchedOn = new ArrayList<Integer[]>();
		this.startingTime = System.currentTimeMillis();
		treeLevelCoverage = new int[distmat.getDimension()];
	}
	
	public void getRoutes(DistanceMatrix distmat, int compTimeLimit, int branchTimeLimit, 
			ArrayList<ArrayList<Integer>> initialPaths, 
			boolean generateOutput, double initialCosts) throws IloException, IOException {
		// initialize data structured
		
		 ArrayList<Path> paths = new ArrayList<Path>();
		 this.initialCosts = initialCosts;
		 relaxedResults = new ArrayList<ArrayList<Double>>();
		 int nLocations = distmat.getDimension();
		 double fpCosts = 0;
		 for (int i = 0; i < initialPaths.size(); i++) {
			 Path p = new Path(initialPaths.get(i), ModelHelperMethods.getRouteCostsIndexed0(distmat, initialPaths.get(i)), 0, 
					 nLocations);
			 paths.add(p);
			 fpCosts += p.getCosts();
		 }
		 
		 
		// initialize mus with the Flaschenpost solution costs divided by the number of customers
		 //this.initialMuValues = costs / (distmat.getDimension()-2);
		 initialMuValues = 0;
		 initialMuDepotValue = 0;
		 //this.initialMuDepotValue = costs / nVehicles;
		 
		 // initialize mus
		 double[] mus = new double[nLocations];
		 for (int i = 1; i < nLocations-1; i++) {
			 mus[i] = initialMuValues;
		 }
		 mus[nLocations-1] = initialMuDepotValue;
		 
		 getRoutesInternal(distmat, compTimeLimit, branchTimeLimit, mus, 0, false, paths.size(), null);
		 
		 // postprocessing - optimizing the routes via TSPTW
		 double costs = 0;
		 for (ArrayList<Integer> route : bestSolution) costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);

		 ArrayList<ArrayList<Integer>> improvedBestSolution = new ArrayList<ArrayList<Integer>>();
		 for (ArrayList<Integer> route : bestSolution) improvedBestSolution.add(tsptwOptimize(route, distmat, currentTime, orders));
		 costs = 0;
		 for (ArrayList<Integer> route : improvedBestSolution) costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);

		 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\stabilized\\_Summary" + id + ".csv", true);
		 writer.write(paths.size() + "," + improvedBestSolution.size() + "," + overallLowerBound + "," + fpCosts + "," + 
				 (fpCosts - paths.size() * 900 - (distmat.getDimension()-2) * 300) + "," + 
				 costs + "," + (costs - improvedBestSolution.size() * 900 - (distmat.getDimension()-2) * 300) +"\n");
	     writer.close();
	}
		 
	
	private void getRoutesInternal(DistanceMatrix distmat, int compTimeLimit,
			int branchTimeLimit, double[] mus, int treeDepth, 
			boolean vehicleBranchingAllowed, int nVehicles, ArrayList<Integer[]> arcsBranchedOn) 
					throws IOException, IloException {
		if (System.currentTimeMillis() - startingTime > compTimeLimit * 1000) return;
		ArrayList<ArrayList<Path>> pathsPerIteration = new ArrayList<ArrayList<Path>>();
		ArrayList<double[]> dualValuesPerIteration = new ArrayList<double[]>();
		ArrayList<double[]> musPerIteration = new ArrayList<double[]>();
		 long branchingTime = System.currentTimeMillis();
		 branchCount++;
		 treeLevelCoverage[treeDepth]++;

		 // initialize stabilized cutting procedure
		 double trustRegion = 1;
		 
		 // set lambdas = mus
		 double[] lambdas = new double[mus.length];
		 for (int i = 0; i < mus.length; i++) {
			 lambdas[i] = mus[i];
		 }
		 
		 musPerIteration.add(mus);

	     // column generation
	     double delta = Double.MIN_VALUE;
	     double threshold = 1;
	     int iteration = 0;
	     

	     // initial solution of the SPP
	     double[] reducedCosts = new double[distmat.getAllEntries().length];
		 for (int i = 0; i < reducedCosts.length; i++) {
			 reducedCosts[i] = distmat.getAllEntries()[i];
		 }
		 DistanceMatrix reducedCostsMatrix = new DistanceMatrix(reducedCosts);
		 reducedCostsMatrix.subtractDuals(mus);
	     ESPPTWCC_Heuristic subproblem = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime, 50, false);
		 ArrayList<Path> newPaths = subproblem.labelNodes();
	     
	     
	     for (Path p : newPaths) p.setSValue(this.getSValue(p, distmat, nVehicles));
	     double bestDual = solveDual(newPaths, lambdas, nVehicles);
		 dualValuesPerIteration.add(getDualValuesPerPath(newPaths, distmat, mus, nVehicles));
		 pathsPerIteration.add(newPaths);
		 
	     while (System.currentTimeMillis() - branchingTime < branchTimeLimit * 1000 &&
	    		 System.currentTimeMillis() - startingTime < compTimeLimit * 1000) {
	    	 iteration++;
	    	 //System.out.println("Iteration " + iteration);
	    	 // solve lagrangian dual
		     double[] result = solveLagrangianDual(distmat, lambdas, trustRegion, iteration, pathsPerIteration, musPerIteration, 
		    		 dualValuesPerIteration, nVehicles);
		     
		     if (result == null) {
		    	 System.out.println("No solution to Lagrangian dual exists");
		    	 break;
		     }
		    
		     double[] newMus = new double[mus.length];
		     for (int i = 0; i < mus.length; i++) {
		    	 newMus[i] = result[i];
		     }		  
		     
		     /*FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\mus.csv", true);
			 writer.write(iteration + "," + s + "\n");
		     writer.close();*/
		     
		     //System.out.println("Mu sum: " + muSum);
			 musPerIteration.add(newMus);
		     
		     double theta = result[result.length-1];
		     
		     // update delta
		     ArrayList<Path> allPaths = new ArrayList<Path>();
		     for (ArrayList<Path> pathList : pathsPerIteration) allPaths.addAll(pathList);
		     delta = theta - bestDual;
		     // update lower bound
		     //System.out.println("Best dual (lower bound) " + bestDual);
		     //System.out.println("Delta " + delta);
		     //System.out.println("Theta " + theta);
		     
		     // check convergence
		     if (delta < threshold) break;
		     
		     // compute reduced costs for arcs
		     reducedCosts = new double[distmat.getAllEntries().length];
			 for (int i = 0; i < reducedCosts.length; i++) {
				 reducedCosts[i] = distmat.getAllEntries()[i];
			 }
			 reducedCostsMatrix = new DistanceMatrix(reducedCosts);
			 reducedCostsMatrix.subtractDuals(newMus);

		     subproblem = new ESPPTWCC_Heuristic(distmat, reducedCostsMatrix, orders, currentTime, 50, false);
		     newPaths = subproblem.labelNodes();
		     
		     // check for duplicates
		     ArrayList<Path> addList = new ArrayList<Path>();
		     for (Path p : newPaths) {
		    	 if (!pathExists(allPaths, p)) addList.add(p);
		     }
		     
	    	 allPaths.addAll(addList);
	    	 
	    	// logging
	    	 double[] mipResult = solveMIP(distmat, allPaths);
			 if (mipResult != null) {
				 int[] decision = new int[mipResult.length-1];
				 for (int i = 0; i < decision.length; i++) {
					 if (mipResult[i] == 0) decision[i] = 0;
					 else decision[i] = 1;
				 }
				 // calculate costs without overlapping
			     ArrayList<ArrayList<Integer>> routes = computeSolution(distmat, decision, allPaths);
			     double costs = 0;
			     for (ArrayList<Integer> route : routes) {
			    	 if (route.size() == 2) continue;
			    	 costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);
			     }
				 double mipCosts = mipResult[mipResult.length-1];
			     if (mipCosts < overallUpperBound) overallUpperBound = mipCosts;
			     if (costs < overallCosts) {
			    	 overallCosts = costs;
			    	 bestSolution = routes;
			     }
				 FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\stabilized\\" + id + ".csv", true);
				 writer.write((Math.floor(System.currentTimeMillis() - startingTime) / 1000)+  "," + overallLowerBound + "," + overallCosts + "\n");
			     writer.close();
			 }
	    	 
		     // update s values per path
		     for (Path p : addList) p.setSValue(this.getSValue(p, distmat, nVehicles));
		     
	    	 // calculate new dual values per path	    	 
	    	 dualValuesPerIteration.add(getDualValuesPerPath(addList, distmat, newMus, nVehicles));
		     
		     pathsPerIteration.add(addList);
		     // get new best dual
		     double newBestDual = solveDual(allPaths, newMus, nVehicles);
		     if (newBestDual < bestDual) newBestDual = bestDual;
		     
		     // compute gain ratio
		     double gainRatio = (newBestDual - bestDual) / delta;
		     if (newBestDual > bestDual) bestDual = newBestDual;
		     //bestDual = newBestDual;
		     
		     // compute trust region
		     //if (gainRatio < 1.0001 && gainRatio > 0.9999) trustRegion = trustRegion * 1.5;
		     if (gainRatio == 1) trustRegion = trustRegion * 1.5;
		     else if (gainRatio < 0) trustRegion = trustRegion / 1.1;
		     if (gainRatio > 0.01) lambdas = newMus;
		     /*System.out.println("Gain ratio " + gainRatio);
		     System.out.println("Trust region " + trustRegion);
		     System.out.println();*/
	     }
	     

	     // calculate results for this node
	     ArrayList<Path> allPaths = new ArrayList<Path>();
	     for (ArrayList<Path> pathList : pathsPerIteration) allPaths.addAll(pathList);
	     
		 double[] relaxedResult = solveRelaxation(distmat, allPaths);
		 
		 if (relaxedResult == null) {
	    	 // if relaxed result in this branch is higher than the best solution so far with eliminated duplicates
		     // cut off branch
	    	 return;
		 }
	     
		 
		 double relaxedCosts = relaxedResult[relaxedResult.length-1];
		 
	     if (relaxedResults.size() <= treeDepth) relaxedResults.add(new ArrayList<Double>());
		 relaxedResults.get(treeDepth).add(relaxedCosts);

		 // update lower bound if current level of the tree has been explored
	     if (treeLevelCoverage[treeDepth] == Math.pow(2, treeDepth)) {
	    	 // find lowest relaxed result of current tree depth
	    	 ArrayList<Double> currentDepthValues = relaxedResults.get(treeDepth);
	    	 double lowest = Double.MAX_VALUE;
	    	 for (double d : currentDepthValues) {
	    		 if (d < lowest) lowest = d;
	    	 }
	    	 overallLowerBound = lowest;
	     }

	     // calculate mip result
		 double[] mipResult = solveMIP(distmat, allPaths);
		 if (mipResult != null) {

			 double mipCosts = mipResult[mipResult.length-1];

			 int[] decision = new int[mipResult.length-1];
			 for (int i = 0; i < decision.length; i++) {
				 if (mipResult[i] == 0) decision[i] = 0;
				 else decision[i] = 1;
			 }
			 // calculate costs without overlapping
		     ArrayList<ArrayList<Integer>> routes = computeSolution(distmat, decision, allPaths);
		     double costs = 0;
		     for (ArrayList<Integer> route : routes) {
		    	 if (route.size() == 2) continue;
		    	 costs += ModelHelperMethods.getRouteCostsIndexed0(distmat, route);
		     }
		     if (mipCosts < overallUpperBound) overallUpperBound = mipCosts;
		     if (costs < overallCosts) {
		    	 overallCosts = costs;
		    	 bestSolution = routes;
		     }
		 }	 
		 
	     
		 if (relaxedCosts > overallUpperBound) {
	    	 // if relaxed result in this branch is higher than the best solution so far with eliminated duplicates
		     // cut off branch

	    	 return;
		 }
	     
	     
	     // START BRANCHING
		 
		 double[] relaxedDecision = new double[relaxedResult.length-1];
		 double relaxedNVehicles = 0;
		 for (int i = 0; i < relaxedDecision.length; i++) {
			 relaxedDecision[i] = relaxedResult[i];
			 relaxedNVehicles += relaxedResult[i];
		 }
		 
		 // if relaxed decision has a non-integer number of vehicles, branch on this
		 if (vehicleBranchingAllowed && (Math.round(relaxedNVehicles) != relaxedNVehicles)) {
		     // initialize with previous best found mus
		     mus = musPerIteration.get(musPerIteration.size()-1);
		     /*int nLocations = distmat.getDimension();
		     mus = new double[nLocations];
			 for (int i = 1; i < nLocations-1; i++) {
				 mus[i] = initialMuValues;
			 }
			 mus[nLocations-1] = initialMuDepotValue;*/
			 // set to the value it is closer to first
			 if (Math.round(relaxedNVehicles) - relaxedNVehicles > 0) {
			     getRoutesInternal(distmat, compTimeLimit, branchTimeLimit, mus,
			    		 treeDepth, false, (int)Math.ceil(relaxedNVehicles), arcsBranchedOn);
			 }
			 else {
			     getRoutesInternal(distmat, compTimeLimit, branchTimeLimit, mus,
			    		 treeDepth, false, (int)Math.floor(relaxedNVehicles), arcsBranchedOn);
			 }
		 }
		 

		 if (arcsBranchedOn == null) arcsBranchedOn = new ArrayList<Integer[]>();
	     int[] branchingVariable = findBranchVariable(distmat, relaxedDecision, allPaths, arcsBranchedOn);
	     
	     // if no more branching can be done return
	     if (branchingVariable[0] == -1) {
	    	 return;
	     }
	     
	     // initialize with previous best found mus
	     mus = musPerIteration.get(musPerIteration.size()-1);
	     int nLocations = distmat.getDimension();
	     mus = new double[nLocations];
		 for (int i = 1; i < nLocations-1; i++) {
			 mus[i] = initialMuValues;
		 }
		 mus[nLocations-1] = initialMuDepotValue;
		 
		 
		 ArrayList<Integer[]> newArcsBranchedOn = new ArrayList<Integer[]>();
		 for (int i = 0; i < arcsBranchedOn.size(); i++) {
			 Integer[] newArc = new Integer[2];
			 newArc[0] = arcsBranchedOn.get(i)[0];
			 newArc[1] = arcsBranchedOn.get(i)[1];
			 newArcsBranchedOn.add(newArc);
		 }
		 Integer[] temp = new Integer[2];
		 temp[0] = branchingVariable[0];
		 temp[1] = branchingVariable[1];
		 newArcsBranchedOn.add(temp);

	     // branch with set to 1
	     DistanceMatrix distmat1 = penalizeArcsInDistanceMatrix(distmat, branchingVariable[0], branchingVariable[1], true);
	     getRoutesInternal(distmat1, compTimeLimit, branchTimeLimit, mus,
	    		 treeDepth + 1, false, nVehicles, newArcsBranchedOn);
	     
	     // branch with set to 0
	     DistanceMatrix distmat0 = penalizeArcsInDistanceMatrix(distmat, branchingVariable[0], branchingVariable[1], false);
	     getRoutesInternal(distmat0, compTimeLimit, branchTimeLimit, mus,
	    		 treeDepth + 1, false, nVehicles, newArcsBranchedOn);
	}
	
	private double[] solveLagrangianDual(DistanceMatrix distmat, 
			double[] lambdas, double trustRegion, int iteration,
			ArrayList<ArrayList<Path>> pathsPerIteration, ArrayList<double[]> musPerIteration,
			ArrayList<double[]> dualValuesPerIteration, int nVehicles) throws IloException {
	     int nLocations = distmat.getDimension();
		 // Initialize cplex
		 IloCplex cplex = new IloCplex();
		 cplex.setOut(null);
		 IloNumVar theta = cplex.numVar(Double.MIN_VALUE, Double.MAX_VALUE);
		 IloLinearNumExpr obj = cplex.linearNumExpr();
	     obj.addTerm(1.0, theta);
	     cplex.addMaximize(obj);
		 IloNumVar[] decisionMus = cplex.numVarArray(nLocations, 0.0, Double.MAX_VALUE);
	     
	     // build all constraints
		 // cumulative theta constraints 
	     for (int q = 0; q < iteration; q++) {
	    	 for (int p = 0; p < pathsPerIteration.get(q).size(); p++) {
	    		Path currentPath = pathsPerIteration.get(q).get(p);
		    	double[] sValues = currentPath.getSValue();
	 			IloLinearNumExpr expr = cplex.linearNumExpr();
	 			expr.setConstant(nVehicles * currentPath.getCosts());
		    	for (int i = 0; i < nLocations; i++) {
		    		expr.addTerm(decisionMus[i], sValues[i]);
		    	}
		    	
		        cplex.addLe(theta, expr);
	    	 }
	     }
	    
	     // trust region constraints
	    for (int i = 0; i < nLocations; i++) {
			cplex.addLe(decisionMus[i], lambdas[i] + trustRegion);
	    }
	    for (int i = 0; i < nLocations; i++) {
			cplex.addGe(decisionMus[i], lambdas[i] - trustRegion);
	    }
	    
	    if(!cplex.solve()) return null;
     
	    double[] result = new double[nLocations+1];
	    for (int i = 0; i < nLocations; i++) {
	    	result[i] = cplex.getValue(decisionMus[i]);
	    }
	    result[nLocations] = cplex.getObjValue();
	    cplex.end();
	    return result;
	}
	
	private double[] getDualValuesPerPath(ArrayList<Path> paths, DistanceMatrix distmat, double[] mus,
			int nVehicles) {
		double[] res = new double[paths.size()];
		for (int p = 0; p < paths.size(); p++) {
			Path path = paths.get(p);
			double sum = 0;
			for (int i = 0; i < distmat.getDimension(); i++) {
				sum += path.getSValue()[i] * mus[i];
			}
			res[p] = sum + nVehicles * path.getCosts();
		}
		return res;
	}
	
	private double[] getSValue(Path path, DistanceMatrix distmat, int nVehicles) {
		double[] result = new double[distmat.getDimension()];
		result[0] = 1 - nVehicles;
		//TODO ATTENTION: THIS DEVIATES FROM KALLEHAUGE ET AL
		for (int i = 0; i < distmat.getDimension()-1; i++) {
			int sum = 0;
			
			for (int j = 1; j < distmat.getDimension()-1; j++) {
				sum+= path.getArcsUsed()[i][j];
			}
			result[i] = 1 - nVehicles * sum;
		}
		result[distmat.getDimension()-1] = 1 - nVehicles;
		return result;
	}
	
	private double solveDual(ArrayList<Path> paths, double[] lambdas, int nVehicles) {
		double lowest = Double.MAX_VALUE;
		for (int p = 0; p < paths.size(); p++) {
			Path path = paths.get(p);
			double sum = nVehicles * path.getCosts();
			//if (sum == 0) continue;
			for (int i = 0; i < lambdas.length; i++) {
				sum += path.getSValue()[i] * lambdas[i];
			}
			if (sum < lowest) lowest = sum;
		}
		return lowest;
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
	     
	     if (!cplex.solve()) return null;
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
	     
	     double[] result = new double[paths.size()+1];
	     for (int p = 0; p < paths.size(); p++) {
	    	 result[p] = cplex.getValue(y[p]);
	    	 //System.out.println("pi_" + i + "=" + duals[i]);
	     }
	     result[result.length-1] = cplex.getObjValue();
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
	private int[] findBranchVariable(DistanceMatrix distmat, double[] relaxedDecision, ArrayList<Path> paths,
			ArrayList<Integer[]> arcsBranchedOn) {
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
						if (arcsBranchedOn.get(j)[0] == nodes.get(i) || arcsBranchedOn.get(j)[1] == nodes.get(i+1)) {
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
	
	private boolean pathExists(ArrayList<Path> allPaths, Path path) {
		for (Path p : allPaths) {
			boolean same = true;
			if (p.getNodes().size() != path.getNodes().size()) {
				same = false;
				continue;
			}
			for (int i = 0; i< path.getNodes().size(); i++) {
				if (path.getNodes().get(i) != p.getNodes().get(i)) {
					same = false;
					break;
				}
			}
			if (same) return same;
		}
		return false;
	}
	
	private ArrayList<Integer> postProcess(DistanceMatrix distmat, ArrayList<Order> route) {
		DistanceMatrix croppedMatrix = new DistanceMatrix(distmat.getAllEntries());
		int[] routeIndices = new int[route.size() + 1];
		routeIndices[0] = 1;
		for (int k = 1; k <= route.size(); k++) {
			routeIndices[k] = route.get(k-1).getDistanceMatrixLink();
		}
		
		croppedMatrix = croppedMatrix.getCroppedMatrix(routeIndices);

		int[] tspRoute = CPlexTSP.getRoute(croppedMatrix);
		return null;
	}
	
	private ArrayList<Integer> tsptwOptimize(ArrayList<Integer> route, DistanceMatrix distmat, int currentTime,
			ArrayList<Order> orders) {
		DistanceMatrix croppedMatrix = new DistanceMatrix(distmat.getAllEntries());
		int[] routeIndices = new int[route.size()];
		for (int i = 0; i < route.size(); i++) routeIndices[i] = route.get(i)+1;		
		Arrays.sort(routeIndices);		
		ArrayList<Order> relevantOrders = new ArrayList<Order>();
		
		for (int i = 1; i < routeIndices.length-1; i++) {
			relevantOrders.add(orders.get(routeIndices[i]-2));
		}
		croppedMatrix = croppedMatrix.getCroppedMatrix(routeIndices);

		int[] tspRoute = CPlexTSPTW.getRoute(croppedMatrix, relevantOrders, currentTime);
		
		ArrayList<Integer> tspRouteList = ModelHelperMethods.parseTSPOutput2(tspRoute, route);
		return tspRouteList;
	}
}
