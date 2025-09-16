package com.example.attendance.controller;



import java.io.IOException;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.example.attendance.dao.AttendanceDAO;
import com.example.attendance.dao.UserDAO;
import com.example.attendance.dto.User;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private final UserDAO userDAO = new UserDAO();
	private final AttendanceDAO attendanceDAO = new AttendanceDAO();       

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		User user = userDAO.findByUsername(username);
		if (user != null && user.isEnabled() && userDAO.verifyPassword(username, password)) {
			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			session.setAttribute("successMessage", "ログインしました");
			if ("admin".equals(user.getRole())) {
				request.setAttribute("allAttendanceRecords", attendanceDAO.findAll());
				Map<String, Long> totalHoursByUser = attendanceDAO.findAll().stream()
					.collect(Collectors.groupingBy(com.example.attendance.dto.Attendance::getUserId,
					Collectors.summingLong(att -> {
						if (att.getCheckInTime() != null && att.getCheckOutTime() != null) {
							return java.time.temporal.ChronoUnit.HOURS.between(att.getCheckInTime(), att.getCheckOutTime());
						}
						return 0L;
					})));
				request.setAttribute("totalHoursByUser", totalHoursByUser);
				RequestDispatcher rd = request.getRequestDispatcher("/AttendanceServlet");
				rd.forward(request, response);
			}else if ("employee".equals(user.getRole())) {
				request.setAttribute("attendanceRecords", attendanceDAO.findByUserId(user.getUsername()));
				RequestDispatcher rd = request.getRequestDispatcher("/AttendanceServlet");
				rd.forward(request, response);
			}
		
		} else {
			request.setAttribute("errorMessage", "ユーザーIDまたはパスワードが不正です。または、アカウントが無効です。");
			RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
			rd.forward(request, response);
		}
	}

}
