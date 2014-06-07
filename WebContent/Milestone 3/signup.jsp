<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>
<body>
<%
session.removeAttribute("name");
session.removeAttribute("userID");

%>
<table width="100%" align="center"><tr><td align="left"><a href="login.jsp">Home</a></td></tr></table>
<form action="signup.jsp" method="post">
<table align="center">
	<tr><td>Name:</td><td><input type="text" id="name" name="name"></td></tr>
	<tr>
		<td>Role:</td>
		<td>
			<select id="role" name="role">
				<option>owner</option>
				<option>customer</option>
			</select>
		</td>
	</tr>
	<tr><td>Age:</td><td><input type="text" id="age" name="age"></td></tr>
	<tr><td>State:</td>
		<td>
			<select id="state" name="state">
				<option>AL</option> 
				<option>AK</option>
				<option>AZ</option>
				<option>AR</option>
				<option>CA</option>
				<option>CO</option>
				<option>CT</option>
				<option>DE</option>
				<option>FL</option>
				<option>GA</option>
				<option>HI</option>
				<option>ID</option>
				<option>IL</option>
				<option>IN</option>
				<option>IA</option>
				<option>KS</option>
				<option>KY</option>
				<option>LA</option>
				<option>ME</option>
				<option>MD</option>
				<option>MA</option>
				<option>MI</option>
				<option>MN</option>
				<option>MS</option>
				<option>MO</option>
				<option>MT</option>
				<option>NE</option>
				<option>NV</option>
				<option>NH</option>
				<option>NJ</option>
				<option>NM</option>
				<option>NY</option>
				<option>NC</option>
				<option>ND</option>
				<option>OH</option>
				<option>OK</option>
				<option>OR</option>
				<option>PA</option>
				<option>RI</option>
				<option>SC</option>
				<option>SD</option>
				<option>TN</option>
				<option>TX</option>
				<option>UT</option>
				<option>VT</option>
				<option>VA</option>
				<option>WA</option>
				<option>WV</option>
				<option>WI</option>
				<option>WY</option>

			</select>
		</td>
	</tr>
	<tr><td><input type="submit" value="Signup"></td><td><input type="button" value="Reset"></td></tr>
</table>
</form>
<%
String name=null, role=null, age=null, state=null;
try { name=request.getParameter("name"); }catch(Exception e) { name=null; }
try { role=request.getParameter("role"); }catch(Exception e) { role=null; }
try { age=request.getParameter("age"); }catch(Exception e) { age=null; }
try { state=request.getParameter("state"); }catch(Exception e) { state=null; }


if(name!=null && age!=null && role!=null && state!=null)
{
	Connection conn=null;
	Statement stmt;
	
	try
	{
		String  SQL="INSERT INTO users (name, role, age, state) VALUES('"+name+"','"+role+"',"+age+",'"+state+"');";
		try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
		String url="jdbc:postgresql://localhost:5432/CSE135";
		String user="postgres";
		String password="calcium";
		conn =DriverManager.getConnection(url, user, password);
		stmt =conn.createStatement();
		try{
			conn.setAutoCommit(false);
			stmt.execute(SQL);
			conn.commit();
			conn.setAutoCommit(true);
			out.println("Register successfully. <br>");
			out.println("<table><tr><td>Name:</td><td>"+name+"</td></tr><tr><td>Role:</td><td>"+role+"</td></tr><tr><td>Age:</td><td>"+age+"</td></tr><tr><td>State:</td><td>"+state+"</td></tr></table>");
			out.println("Please go back to <a href='login.jsp' target='_self'>login</a>.");
		}
		catch(SQLException e)
		{
			out.println("Fail, can not access the database, please check the database status first! Please <a href='signup.jsp' target='_self'>register</a> again.");
		}
		
	}
	catch(Exception e)
	{
			out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
	}
	finally
	{
		conn.close();
	}
}
%>

</body>
</html>
