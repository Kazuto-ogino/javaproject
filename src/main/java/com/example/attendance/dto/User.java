package com.example.attendance.dto;

public class User{
	private String username;
	private String password;
	private String role;
	private boolean enabled;
	
	public User(String username, String password, String role) {
		this(username, password, role, true); 
		}
	public User(String username,String password,String role,boolean enabled) {
		this.username=username;
		this.password=password;
		this.role=role;
		this.enabled=enabled;
	}
	
	public String getUsername(){
		return username;
	}

	
}