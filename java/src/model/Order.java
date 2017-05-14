package model;

public class Order {
	private int time;
	private double weight;
	private int distanceMatrixLink;
	private int id;
	private int status;
	
	public Order(int id, int time, double weight, int distanceMatrixLink) {
		this.time = time;
		this.weight = weight;
		this.distanceMatrixLink = distanceMatrixLink;
		this.id = id;
		this.status = 0;
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
}
