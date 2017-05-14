package model;

public class Vehicle {

	private boolean available = false;
	private int id;
	private int availability;
	private int unavailability;
	private int location;
	
	public Vehicle(int id, int availability, int unavailability) {
		this.id = id;
		this.availability = availability;
		this.unavailability = unavailability;
		location = 1;
		if (availability == 0) available = true;
	}

	public boolean isAvailable() {
		return available;
	}

	public void setAvailable(boolean available) {
		this.available = available;
	}

	public int getLocation() {
		return location;
	}

	public void setLocation(int location) {
		this.location = location;
	}

	public int getAvailability() {
		return availability;
	}

	public void setAvailability(int availability) {
		this.availability = availability;
	}

	public int getUnavailability() {
		return unavailability;
	}

	public void setUnavailability(int unavailability) {
		this.unavailability = unavailability;
	}
	
	
}
