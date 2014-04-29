<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>Sign up confirmation</title>
<meta name="Author" content="Allen Gong">
<meta name="description" content="Best place to get your goodies">

<link rel="stylesheet" type="text/css" href="css/normalize.css">
<link rel="stylesheet" type="text/css" href="css/foundation.css">
<link rel="stylesheet" type="text/css" href="css/custom.css">

<script type="text/javascript" src="js/vendor/jquery.js"></script>
<script type="text/javascript" src="js/foundation.min.js"></script>
</head>
<body>
	<!-- Navigation -->

	<nav class="top-bar" data-topbar>
	<ul class="title-area">
		<!-- Title Area -->
		<li class="name">
			<h1>
				<a href="index.html"> PYTS Home </a>
			</h1>
		</li>
		<li class="toggle-topbar menu-icon"><a href="#"><span>menu</span></a></li>
	</ul>
	</nav>

	<!-- End Top Bar -->

	<!-- Header -->
	<div class="row">
		<div class="large-12 columns">
			<img src="img/yts_header.png" alt=""><br>
			<br>
		</div>
	</div>

	<!-- End Header -->


	<div class="row" id="shift">
		<div class="row">
			<div class="panel">

		<!-- *****************************************JSP*************************************************** -->

		<%-- Set the scripting language to Java and import the java.sql package--%>
		<%@ page language="java" import="java.sql.*"%>

	<%
        try 
        {        
            Class.forName("org.postgresql.Driver");

            // Make a connection to the Oracle datasource "CSE135"
            Connection conn = DriverManager.getConnection(
            		          "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
    %>

				<%---------- INSERT Code ----------%>
				<%
            // Check if an insertion is requested
            String action = request.getParameter("action");
            if (action != null && action.equals("insert")) {

            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // INSERT the User attributes INTO the Users table.
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Users " +
                                      "(name, role, age, state) VALUES (?, ?, ?, ?)");
    
            pstmt.setString(1, request.getParameter("param_name"));
            pstmt.setString(2, request.getParameter("param_role"));
            pstmt.setInt   (3, Integer.parseInt(request.getParameter("param_age")));
            pstmt.setString(4, request.getParameter("param_state"));
            int rowCount = pstmt.executeUpdate();
            
            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
            }
        
            // Close the connection
            conn.close();
    
        }
		//Specific error handling
		    catch (SQLException e) 
		{
		
		    	//If the user already exists
		    	if(e.getSQLState().equals("23505"))
		    	{
		        	out.println("Sorry username already exists! Please try a different one");
		        	return;
		    	}
		    	out.println(e.getSQLState());
		        e.printStackTrace();
		        return;
		    }
		
			//TO-DO Catch if age inputted is not a number
		
		    catch (Exception e) 
		    {
		        out.println(e.getMessage());
		        return;
		    }

    %>

		<!-- *********************************************************************************************** -->

		<h2>Sign up SUCCESSFUL! Welcome, <%= request.getParameter("param_name") %>!</h2>
		<h4>Return to <a href="index.html">home page</a> to login</h4>

			</div>
		</div>
	</div>

	<!-- Footer -->

	<footer class="row">
	<div class="large-12 columns">
		<hr />
		<div class="row">

			<div class="large-6 columns">
				<p>© Copyright no one at all. Go to town.</p>
			</div>
		</div>
	</div>
	</footer>
	<script src="../assets/js/jquery.js"></script>
	<script src="../assets/js/templates/foundation.js"></script>
	<script>
      $(document).foundation();

      var doc = document.documentElement;
      doc.setAttribute('data-useragent', navigator.userAgent);
      </script>
</body>
</html>