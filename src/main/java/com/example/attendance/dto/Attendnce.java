package com.example.attendance.dto;

import java.time.LocalDateTime;



public class Attendnce{
	private String userId;
	private LocalDateTime checkInTime;
	private LocalDateTime checkOutTime;
	
	public Attendnce(String userId) {
		this.userId = userId;
	}
	
	public String getUserId() {
		return userId;
		
	}
	public LocalDateTime getCheckInTime() {
		return checkInTime;
	}
	
	public void setCheckInTime(LocalDateTime checkInTime) {
		this.checkInTime=checkInTime;
	}
	public LocalDateTime getCheckOutTIme() {
		return checkOutTime;
	}
	public void setCheckOutTime(LocalDateTime checkOutTime) {
		this.checkOutTime=checkOutTime;
	}
	
	
	
	
	
	
}