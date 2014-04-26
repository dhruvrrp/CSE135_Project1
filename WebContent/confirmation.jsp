<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sign Up Success!</title>
</head>
<body>


<!-- Redirect to correct page -->
	<%@ page language="java" import="java.sql.*" %>
	
	<% try { %>
	
	<% //connect to database
		Class.forName("org.postgresql.Driver");
		Connection conn = DriverManager.getConnection(
				 "jdbc:postgresql://localhost:5432/Assignment 1 - 135", "postgres", "pass");
	%>
	
	<!-- Check for valid sign up credentials -->
	<%
		//check if
	%>
	
	
	<% } finally{} %>
	
</body>
</html>