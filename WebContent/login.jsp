<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Log in</title>
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
          <a href="index.html">
            PYTS Home
          </a>
        </h1>
      </li>
      <li class="toggle-topbar menu-icon"><a href="#"><span>menu</span></a></li>
    </ul>
  </nav>
 
  <!-- End Top Bar -->
 
  <!-- Header -->
  <div class="row">
    <div class="large-12 columns">
      <img src="img/yts_header.png" alt=""><br><br>
    </div>
  </div>
 
  <!-- End Header -->
 
 
  <div class="row" id="shift">
      <div class="row">
          <div class="panel">
          	<h3>Log in</h3>
            <h5>Enter your credentials:</h5>
            
            
 <!-- *****************************************JSP*************************************************** -->
 	<%@ page language="java" import="java.sql.*" %>
 			<!-- Connect to DataBase -->
 			<% 
 				
 					 Class.forName("org.postgresql.Driver");
 					 Connection conn = DriverManager.getConnection(
 							 "jdbc:postgresql://localhost:5432/Assignment 1 - 135", "postgres", "pass");
 					 
 					// Initialization 
 	 				Statement stmt = conn.createStatement();
 					ResultSet rset_users = stmt.executeQuery("SELECT name FROM users");
 					rset_users.next();
 	 			 	
 			%>
 
            <form method="post" action="confirmation.jsp">
				Name: <input type="text" name="param_username">
				<input type="submit" value="Log in" class="button">
            </form>
 <!-- *********************************************************************************************** -->      
            
          </div>
    </div>
  </div>
 
  <!-- Footer -->
 
  <footer class="row">
  <div class="large-12 columns"><hr />
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