package com.example.attendance.dao;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

import com.example.attendance.dto.Attendance;

 

public class AttendanceDAO {
	private static final List<Attendance> attendanceRecords = new CopyOnWriteArrayList<>();
	
	public void checkIn(String userId) {
		Attendance attendnce = new Attendance(userId);
		attendnce.setCheckInTime(LocalDateTime.now());
		attendanceRecords.add(attendnce);
	}
	public void checkOut(String userId) {
		attendanceRecords.stream()
			.filter(att -> userId.equals(att.getUserId()) && att.getCheckOutTime() == null)
			.findFirst()
			.ifPresent(att -> att.setCheckOutTime(LocalDateTime.now()));
	}
	public List<Attendance> findByUserId(String userId) {
		return attendanceRecords.stream()
				.filter(att -> userId.equals(att.getUserId()))
				.collect(Collectors.toList());
	}
	public List<Attendance> findAll() {
		return new ArrayList<>(attendanceRecords);
	}
	
	public List<Attendance> findFilteredRecords(String userId, LocalDate startDate,LocalDate endDate) {
		return attendanceRecords.stream()
				.filter(att -> (userId == null ||userId.isEmpty() || att.getUserId().equals(userId)))
				.filter(att -> (startDate == null || (att.getCheckInTime() !=null
&& !att.getCheckInTime().toLocalDate().isBefore(startDate))))
				.filter(att -> (endDate == null || (att.getCheckInTime() !=null
&& !att.getCheckInTime().toLocalDate().isAfter(endDate))))
				.collect(Collectors.toList());
	}
	
	public long dailyWorkingHours(LocalDateTime checkIn,LocalDateTime checkOut) {
		if (checkIn == null || checkOut == null) {
			return 0L;
		}
		long wokingHours = ChronoUnit.HOURS.between(checkIn, checkOut);
		if (wokingHours >= 9 ) {
			return wokingHours - 1;
		}
		return wokingHours;
	}
	
	private long overWorkingHours(LocalDateTime checkIn,LocalDateTime checkOut) {
		if (checkIn == null || checkOut == null) {
			return 0L;
		}
		long overWorkingTime = ChronoUnit.HOURS.between(checkIn, checkOut);
		if (overWorkingTime >= 9) {
			overWorkingTime -= 1;
		}
		if (overWorkingTime >=8 ) {
			return overWorkingTime -8;
		}
		return 0L;
	}
	
	public Map<YearMonth,Long> getMonthlyWorkingHours(String userId){
		return attendanceRecords.stream()
				.filter(att -> userId == null || userId.isEmpty() || att.getUserId().equals(userId))
				.filter(att -> att.getCheckInTime() != null && att.getCheckOutTime() != null)
				.collect(Collectors.groupingBy(
				att -> YearMonth.from(att.getCheckInTime()),
				Collectors.summingLong(att -> dailyWorkingHours(att.getCheckInTime(),
				att.getCheckOutTime()))
				));
	}
	
	public Map<YearMonth,Long> getMonthlyOverWorkingHours(String userId){
		return attendanceRecords.stream()
				.filter(att -> userId == null || userId.isEmpty() || att.getUserId().equals(userId))
				.filter(att -> att.getCheckInTime() != null && att.getCheckOutTime() != null)
				.collect(Collectors.groupingBy(
				att -> YearMonth.from(att.getCheckInTime()),
				Collectors.summingLong(att -> overWorkingHours(att.getCheckInTime(),
				att.getCheckOutTime()))
				));
	}
	public Map<YearMonth,Long> getMonthlyCheckInCounts(String userId){
		return attendanceRecords.stream()
				.filter(att -> userId
						== null || userId.isEmpty() || att.getUserId().equals(userId))
				.filter(att -> att.getCheckInTime() != null)
				.collect(Collectors.groupingBy(
						att -> YearMonth.from(att.getCheckInTime()),
						Collectors.counting()
				));
	}
	public void addManualAttendance(String userId,LocalDateTime checkIn,LocalDateTime checkOut) {
		Attendance newRecord = new Attendance(userId);
		newRecord.setCheckInTime(checkIn);
		newRecord.setCheckOutTime(checkOut);
		attendanceRecords.add(newRecord);
	}
	public boolean updateManualAttendance(String userId, LocalDateTime oldCheckIn, LocalDateTime oldCheckOut, 
LocalDateTime newCheckIn, LocalDateTime newCheckOut) {
		for (int i=0; i < attendanceRecords.size(); i++) {
			Attendance att = attendanceRecords.get(i);
			if (att.getUserId().equals(userId) &&
				att.getCheckInTime().equals(oldCheckIn) &&
				(att.getCheckOutTime() == null ? oldCheckOut == null : att.getCheckOutTime().equals(oldCheckOut))) {
				att.setCheckInTime(newCheckIn);
				att.setCheckOutTime(newCheckOut);
				return true;
			}
		}
		return false;
	}
	
	public boolean deleteManualAttendance(String userId,LocalDateTime checkIn,LocalDateTime checkOut) {
		return attendanceRecords.removeIf(att ->
			att.getUserId().equals(userId) &&
			att.getCheckInTime().equals(checkIn) &&
			(att.getCheckOutTime() == null ? checkOut == null : att.getCheckOutTime().equals(checkOut))
		);
	}
	
	public Attendance findCheckInByUserId(String userId) {
		return attendanceRecords.stream()
				.filter(att -> att.getUserId().equals(userId))
				.max((a,b) -> a.getCheckInTime().compareTo(b.getCheckInTime()))
				.orElse(null);
	}
	
	public boolean checkInNow(String userId) {
		Attendance checkInNow = findCheckInByUserId(userId);
		return checkInNow != null
				&& checkInNow.getCheckInTime() != null
				&& checkInNow.getCheckOutTime() == null;
	}
	
	public List<Attendance> findUnfinishedChekOut() {
		return attendanceRecords.stream()
				.filter(att -> att.getCheckOutTime() == null) 
				.collect(Collectors.toList());
		
	}
	
}
