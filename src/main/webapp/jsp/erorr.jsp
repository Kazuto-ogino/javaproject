<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>エラー</title>
</head>
<body>
	<h1>エラーが発生しました</h1>
	<p>申し訳ありません、処理中にエラーが発生しました</p>
	<p>エラーメッセージ：<%=Exception.getMessage() %>></p>
	<a href="../login.jsp">ログインページに戻る</a>
</body>
</html>