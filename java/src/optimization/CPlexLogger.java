package optimization;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.PrintWriter;

import ilog.concert.IloException;
import ilog.cplex.IloCplex.MIPCallback;

public class CPlexLogger extends MIPCallback {
	
	double currentTick = -1;
	private String problemInstance;
	
	public CPlexLogger(String problemInstance) throws FileNotFoundException {
		this.problemInstance = problemInstance;
	}
	
	public CPlexLogger() throws FileNotFoundException {
	}

	@Override
	protected void main() throws IloException {
		double time = getCplexTime();
		/**
		PrintWriter writer = new PrintWriter(new File("C:\\Users\\Marcus\\Documents\\FPMS\\Solomon test instances\\c109Distmat.csv"));
		counter = 0;
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < locationX.size();i++) {
			for (int j = 0; j < locationY.size(); j++) {
				sb.append(distances[counter++]);
				sb.append(",");
			}
			sb.append("\n");
		}
		writer.write(sb.toString());
		writer.close();*/
		
		if (problemInstance == null) {
			if (Math.floor(time) % 10 == 0 && Math.floor(time) > currentTick) {
				System.out.println(Math.floor(time) + "," + getIncumbentObjValue() + "," + getMIPRelativeGap());
				currentTick = (int)Math.floor(time);
			}
		}
		else {
			if (Math.floor(time) % 10 == 0 && Math.floor(time) > currentTick) {
				try {
					FileWriter writer = new FileWriter("C:\\Users\\Marcus\\Documents\\FPMS\\results\\" + problemInstance + "_results.csv", true);
					writer.write(getIncumbentObjValue() + "," + getMIPRelativeGap() + "\n");
					currentTick = (int)Math.floor(time);
					writer.close();
				}
				catch (Exception e) {};
			}
		}
	}
}
