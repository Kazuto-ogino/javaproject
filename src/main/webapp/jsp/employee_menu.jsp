<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
	<meta charset="UTF-8">
	<title>従業員メニュー</title>
	<link rel="stylesheet"href="${pageContext.request.contextPath}/style.css">
</head>
<body>
	<div class="container">
		<h1>従業員メニュー</h1>
		<p>${user.username }さん</p>
		<c:if test="${checkInNow}">
			<p class="warning-message"> 出勤中です。退勤を忘れないでください。</p>
		</c:if>
		<c:if test="${not empty sessionScope.successMessage }">
			<p class="success-message"><c:out value="${sessionScope.successMessage }"/></p>
			<c:remove var="successMessage" scope="session"/>
		</c:if>
		<div class="button-group">
			<form action="AttendanceServlet" method="post" style="display:inline;">
				<input type="hidden" name="action" value="check_in">
				<input type="submit" value="出勤">
			</form>
			<form action="AttendanceServlet" method="post" style="display:inline;">
				<input type="hidden" name="action" value="check_out">
				<input type="submit" value="退勤">
			</form>
		</div>
		<h2>労働合計時間</h2>
		<table>
			<thead>
				 <tr>
					<th>年月</th>
					<th>労働時間</th>
					<th>出勤日数</th>
					<th>残業時間</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="entry" items="${monthlyWorkingHours}">
	 				<c:if test="${monthlyOvertimeHours[entry.key] >= 45}">
						<span>残業上限を超過しています</span>
					</c:if>
					<c:if test="${monthlyOvertimeHours[entry.key] >= 40 and monthlyOvertimeHours[entry.key] < 45}">
								<span>もうすぐ残業上限です</span>
					</c:if>
					<tr>
						<td>${entry.key}</td>
						<td>${entry.value} 時間</td>
						<td>${monthlyCheckInCounts[entry.key]} 日</td>
						<td>${monthlyOvertimeHours[entry.key]} 時間</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<h2>勤怠履歴</h2>
		<table>
			<thead>
				<tr>
					<th>出勤時間</th>
					<th>退勤時間</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="att" items="${attendanceRecords }">
					<tr>
						<td>${att.checkInTime }</td>
						<td>${att.checkOutTime }</td>
					</tr>
				</c:forEach>
				<c:if test="${empty attendanceRecords }">
					<tr><td colspan="2">勤怠記録がありません</td></tr>
				</c:if>
			</tbody>
		</table>
		<div class="button-group">
			<a href="LogoutServlet" class="button secondary">ログアウト</a>
		</div>
	</div>
</body>
</html>