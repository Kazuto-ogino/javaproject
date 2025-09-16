package com.example.attendance.controller;

import java.io.IOException;
import java.util.Collection;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.example.attendance.dao.UserDAO;
import com.example.attendance.dto.User;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
	private final UserDAO userDAO = new UserDAO();	
     
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("user");
		
		if (currentUser == null || !"admin".equals(currentUser.getRole())) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		String message = (String) session.getAttribute("successMessage");
		if (message != null) {
			request.setAttribute("successMessage", message);
		}
		String errorMessage = (String) session.getAttribute("errorMessage");
		if (errorMessage != null) {
			request.setAttribute("errorMessage", errorMessage);
			session.removeAttribute("errorMessage");
		}
		if ("list".equals(action) || action == null) {
			Collection<User> users = userDAO.getAllUsers();
			request.setAttribute("users", users);
			RequestDispatcher rd = request.getRequestDispatcher("/jsp/user_management.jsp");
			rd.forward(request, response);
		}else if ("edit".equals(action)) {
			String username = request.getParameter("username");
			User user = userDAO.findByUsername(username);
			request.setAttribute("userToEdit", user);
			Collection<User> users = userDAO.getAllUsers();
			request.setAttribute("users", users);
			RequestDispatcher rd = request.getRequestDispatcher("/jsp/user_management.jsp");
			rd.forward(request, response);
		}else {
			response.sendRedirect("UserServlet?action=list");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");
		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("user");
		
		if (currentUser ==null || !"admin".equals(currentUser.getRole())) {
			response.sendRedirect("login.jsp");
			return;
		}
		if ("add".equals(action)) {
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String role = request.getParameter("role");
			if (userDAO.findByUsername(username) == null) {
				userDAO.addUser(new User(username, UserDAO.hashPassword(password), role));
				session.setAttribute("successMessage", "ユーザーを追加しました");
			}else {
				session.setAttribute("errorMessage", "このユーザーは存在してます");
			}
		}else if ("update".equals(action)) {
			String username = request.getParameter("username");
			String role = request.getParameter("role");
			boolean enabled = request.getParameter("enabled") != null;
			
			User existingUser = userDAO.findByUsername(username);
			if (existingUser != null) {
				userDAO.updateUser(new User(username, existingUser.getPassword(), role,enabled));
				session.setAttribute("successMessage", "ユーザー情報を更新しました");
			}
		}else if ("delete".equals(action)) {
			String username = request.getParameter("username");
			userDAO.deleteUser(username);
			session.setAttribute("successMessage", "ユーザーを削除しました");
		}else if ("reset_password".equals(action)) {
			String username = request.getParameter("username");
			String newPassword =request.getParameter("newPassword");
			userDAO.resetPassword(username, newPassword);
			session.setAttribute("successMessage", "パスワードをリセットしました");
		}else if ("toggle_enabled".equals(action)) {
			String username = request.getParameter("username");
			boolean enabled = Boolean.parseBoolean(request.getParameter("enabled"));
			userDAO.toggleUserEnabled(username, enabled);
			session.setAttribute("successMessage",username +"のアカウントを"+(enabled?"有効":"無効")+"にしました");
		}
		response.sendRedirect("UserServlet?action=list");
	}

}
