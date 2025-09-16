<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
	<meta charset="UTF-8">
	<title>管理者メニュー</title>
	<link rel="stylesheet"href="${pageContext.request.contextPath}/style.css">
</head>
<body>
	<div class="container">
		<h1>管理者メニュー</h1>
		<p>ようこそ,${user.username}さん</p>
		<c:if test="${not empty findUnfinishedChekOut}">
			<p class="warning-message">退勤が記録されていない従業員がいます！</p>
 			<ul>
 				<c:forEach var="att" items="${findUnfinishedChekOut}">
					<li>${att.userId} さんが出勤中</li>
				</c:forEach>
			</ul>
		</c:if>
		<div class="main-nav">
			<a href="AttendanceServlet?action=filter">勤怠履歴管理</a>
			<a href="UserServlet?action=list">ユーザー管理</a>
			<a href="LogoutServlet">ログアウト</a>
		</div>
		<c:if test="${not empty successMessage}">
    		<p class="success-message"><c:out value="${successMessage}"/></p>
		</c:if>
		<h2>勤怠履歴</h2>
		<form action="AttendanceServlet" method="get" class="filter-form">
			<input type="hidden" name="action" value="filter">
			<div>
				<label for="filterUserId">ユーザーID</label>
				<input type="text" id="filterUserId" name="filterUserId" value="<c:out value="${param.filterUserId}"/>">
			</div>
			<div>
				<label for="startDate">開始日</label>
				<input type="date" id="startDate" name="startDate" value="<c:out value="${param.startDate}"/>">
			</div>
			<div>
				<label for="endDate">終了日</label>
				<input type="date" id="endDate" name="endDate" value="<c:out value="${param.endDate}"/>">
			</div>
			<button type="submit" class="button">フィルタ</button>
		</form>
		<p class="error-message"><c:out value="${errorMessage}"/></p>
		<a href="AttendanceServlet?action=export_csv&filterUserId=<c:out value="${param.filterUserId}"/>&startDate=<c:out
 value="${param.startDate}"/>&endDate=<c:out value="${param.endDate}"/>">勤怠管理をCSVエクスポート</a>

		<h3>合計労働時間</h3>
		<table class="summary-table">
			<thead>
				<tr>
					<th>ユーザーID</th>
					<th>労働合計時間</th>
					<th>残業合計時間</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="entry" items="${totalHoursByUser}">
					<tr>
						<td>${entry.key }</td>
						<td>${entry.value }時間</td>
						<td>
							${totalOverHoursByUser[entry.key]}時間
							<c:if test="${totalOverHoursByUser[entry.key] >= 45}">
								<span>残業上限を超過しています</span>
							</c:if>
							<c:if test="${totalOverHoursByUser[entry.key] >= 40 and totalOverHoursByUser[entry.key] < 45}">
								<span>もうすぐ残業上限です</span>
							</c:if>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty totalHoursByUser}">
					<tr><td colspan="2">データがありません。</td></tr>
				</c:if>
			</tbody>
		</table>
		<h3>月別退勤グラフ</h3>
		<h4>月別合計時間</h4>
		<pre>
			<c:forEach var="entry" items="${monthlyWorkingHours }">
				${entry.key }: <c:forEach begin="1" end="${entry.value / 5 }">*</c:forEach> ${entry.value }時間
			</c:forEach>
			<c:if test="${empty monthlyWorkingHours }">データがありません</c:if>
		</pre>
		<h4>月別出勤日数</h4>
		<pre>
			<c:forEach var="entry" items="${monthlyCheckInCounts }">
				${entry.key }: <c:forEach begin="1" end="${entry.value}">◾️</c:forEach> ${entry.value }日
			</c:forEach>
			<c:if test="${empty monthlyWorkingHours }">データがありません</c:if>
		</pre>
		
		<h3>勤怠履歴</h3>
		<table>
			<thead>
				<tr>
					<th>従業員ID</th>
					<th>出勤時刻</th>
					<th>退勤時刻</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="att" items="${allAttendanceRecords }">
					<tr>
						<td>${att.userId }</td>
						<td>${att.checkInTime }</td>
						<td>${att.checkOutTime }</td>
						<td class="table-actions">
							<form action="AttendanceServlet" method="post" style="display:inline;">
								<input type="hidden" name="action" value="delete_manual">
								<input type="hidden" name="userId" value="${att.userId }">
								<input type="hidden" name="checkInTime" value="${att.checkInTime }">
								<input type="hidden" name="checkOutTime" value="${att.checkOutTime}">
								<input type="submit" value="削除" class="button danger" 
onclick="return confirm('本当に削除しますか?');">
							</form>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty allAttendanceRecords}">
					<tr><td colspan="4">データがありません。</td></tr>
				</c:if>
			</tbody>
		</table>
		<h2>勤怠記録の手動追加</h2>
		<form action="AttendanceServlet" method="post">
			<input type="hidden" name="action" value="add_manual">
			<p>
				<label for="manualUserId">ユーザーID</label>
				<input type="text" id="manualUserId" name="userId" required>
			</p>
			<p>
				<label for="manualCheckInTime">出勤時刻</label>
				<input type="datetime-local" id="manualCheckInTime" name="checkInTime" required>
			</p>
			<p>
				<label for="manualCheckOutTime">退勤時刻</label>
				<input type="datetime-local" id="manualCheckOutTime" name="checkOutTime">
			</p>
			<div class="button-group">
				<input type="submit" value="追加">
			</div>
		</form>
	</div>
</body>
</html>