<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>ユーザー管理</title>
	<link rel="stylesheet"href="${pageContext.request.contextPath}/style.css">
</head>
<body>
	<div class="container">
		<h1>ユーザー管理</h1>
		<div class="main-nav">
			<a href="AttendanceServlet?action=filter">勤怠管理</a>
			<a href="UserServlet?action=list">ユーザー管理</a>
			<a href="LogoutServlet">ログアウト</a>
		</div>
		<c:if test="${not empty sessionScope.successMessage }">
			<p class="success-message"><c:out value="${sessionScope.successMessage }"/></p>
			<c:remove var="successMessage" scope="session"/>
		</c:if>
		<h2>ユーザー追加/編集</h2>
		<form action="UserServlet" method="post" class="user-form">
			<input type="hidden" name="action" value="<c:choose><c:when test="${userToEdit !=
null}">update</c:when><c:otherwise>add</c:otherwise></c:choose>">
			<c:if test="${userToEdit !=null }">
				<input type="hidden" name="username" value="${userToEdit.username }">
			</c:if>
			<label for="username">ユーザーID</label>
			<input type="text" id="username" name="username" placeholder="ユーザーIDを設定してください" value="<c:out value="${userToEdit.username}"/>"
<c:if test="${userToEdit !=null }">readonly</c:if> required>
			<label for="passeord">パスワード</label>
			<input type="password" id="passeord" name="password"
placeholder="${userToEdit != null ? '変更するには別途操作を行なってください':'パスワードを設定してください'}"
<c:if test="${userToEdit == null }">required</c:if>>
			<label for="role">役割</label>
			<select id="role" name="role" required>
				<option value="employee" <c:if test="${userToEdit.role == 'employee'}">selected</c:if>>従業員</option>
				<option value="admin" <c:if test="${userToEdit.role == 'admin'}">selected</c:if>>管理者</option>
			</select>
			
			<p>
				<label for="enabled">アカウント有効</label>
				<input type="checkbox" id="enabled" name="enabled" value="true"
<c:if test="${userToEdit == null || userToEbit.enabled }">checked</c:if>>
			</p>
			<div class="button-group">
				<input type="submit" value="<c:choose><c:when test="${userToEdit != null}">更新
</c:when><c:otherwise>追加</c:otherwise></c:choose>">
			</div>
		</form>
		<div class="button-group">
			<c:if test="${userToEdit != null }">
				<form action="UserServlet" method="post" style="display:inline;">
			 		<input type="hidden" name="action" value="reset_password">
					<input type="hidden" name="username" value="${userToEdit.username }">
					<input type="hidden" name="newPassword" value="password">
					<input type="submit" value="パスワードリセット" class="button secondary"
onclick="return confirm('本当にパスワードをリセットしますか？');" >
				</form>
			</c:if>
		</div>
		<p class="error-message"><c:out value="${errorMessage }"/></p>
		<h2>既存ユーザー</h2>
		<table>
			<thead>
				<tr>
					<th>ユーザID</th>
					<th>役割</th>
					<th>有効</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="u" items="${users }">
					<tr>
						<td>${u.username }</td>
						<td>${u.role }</td>
						<td>
							<form action="UserServlet" method="post" style="display:inline;">
								<input type="hidden" name="action" value="toggle_enabled">
								<input type="hidden" name="username" value="${u.username }">
								<input type="hidden" name="enabled" value="${!u.enabled }">
								<input type="submit" value="<c:choose><c:when test="${u.enabled}">無効化</c:when>
<c:otherwise>有効化</c:otherwise></c:choose>" class="button<c:choose><c:when test="${u.enabled}">danger</c:when>
<c:otherwise>secondary</c:otherwise></c:choose>" onclick="return confirm('本当にこのユーザーを<c:choose><c:when 
test="${u.enabled}">無効</c:when><c:otherwise>有効</c:otherwise></c:choose>にしますか？');">
							</form>
						</td>
						<td class="table-actions">
							<a href="UserServlet?action=edit&username=${u.username }" class="button">編集</a>
							<form action="UserServlet" method="post" style="display:inline;">
								<input type="hidden" name="action" value="delete">
								<input type="hidden" name="username" value="${u.username }">
								<input type="submit" value="削除" class="button daner" onclick="return confirm('削除しますか？');">
							</form>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty users }">
					<tr><td colspan="4">ユーザーがいません</td></tr>
				</c:if>
			</tbody>
		</table>
	</div>
</body>
</html> 