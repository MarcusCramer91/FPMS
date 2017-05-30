package model;

public class Order {
	private int time;
	private double weight;
	private int distanceMatrixLink;
	private int id;
	private int status;
	private int earliest;
	private int latest;
	
	public Order(int id, int time, double weight, int distanceMatrixLink) {
		this.time = time;
		this.weight = weight;
		this.distanceMatrixLink = distanceMatrixLink;
		this.id = id;
		this.status = 0;
		earliest = 0;
	}
	
	/**
	 * purely for solomon instances
	 * @param id
	 * @param earliest
	 * @param latest
	 * @param weight
	 * @param distanceMatrixLink
	 */
	public Order(int id, int earliest, int latest, double weight, int distanceMatrixLink) {
		this.weight = weight;
		this.distanceMatrixLink = distanceMatrixLink;
		this.id = id;
		this.status = 0;
		this.earliest = earliest;
		this.latest = latest;
	}

	public int getTime() {
		return time;
	}

	public void setTime(int time) {
		this.time = time;
	}

	public double getWeight() {
		return weight;
	}

	public void setWeight(double weight) {
		this.weight = weight;
	}

	public int getDistanceMatrixLink() {
		return distanceMatrixLink;
	}

	public void setDistanceMatrixLink(int distanceMatrixLink) {
		this.distanceMatrixLink = distanceMatrixLink;
	}
	
	public int getMET(int currentTime) {
		return currentTime - time;
	}
	
	public int getID() {
		return id;
	}
	
	public void setStatus(int status) {
		this.status = status;
	}
	
	public int getStatus() {
		return this.status;
	}
	
	public int getEarliest() {
		return earliest;
	}
	
	public int getLatest() {
		return ModelConstants.TIME_WINDOW - time;
	}
}
