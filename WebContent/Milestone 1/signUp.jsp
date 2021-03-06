<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Sign Up</title>
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
          	<h3>Sign up below:</h3><br>
            
            
 <!-- *****************************************JSP*************************************************** -->

 <%@ page language="java" import="java.sql.*" %>
 
 <!-- Connect to database -->
 <% 
     try
 	 {
 	     Class.forName("org.postgresql.Driver");
 		 Connection conn = DriverManager.getConnection(
 					       "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 					 
 		 // Initialization 
 	 	 Statement stmt = conn.createStatement();
 	 	 ResultSet rs_states = stmt.executeQuery("SELECT state_id FROM states ORDER BY state_id");
 	 			 	
 	     Statement stmt2 = conn.createStatement();
 	 	 ResultSet rs_roles = stmt2.executeQuery("SELECT * FROM roles");
 %>
 
         <!-- Begin text forms -->
         <form method="post" action="signUpConfirmation.jsp">
         <input type="hidden" value="insert" name="action">
             Username: 
                 <input type="text" name="param_name" autofocus="autofocus">
             Role: 
                 <select name="param_role">
                     <% while (rs_roles.next()) { %>
                         <option value= <%= rs_roles.getString("role") %>>
                         <%= rs_roles.getString("role") %></option>
                     <% } %> 
                 </select>
             Age: 
                 <input type="text" name="param_age">
             State: 
                 <select name="param_state">
                     <% while(rs_states.next()) { %>
                         <option value= <%= rs_states.getString("state_id") %>>
                         <%= rs_states.getString("state_id") %></option>
                     <% } %>
                 </select> 
         <input type="submit" value="Sign Up" class="button">
         </form>

 <!-- Close connection to database -->
 
 <%
         rs_states.close();
         rs_roles.close();

         stmt.close();
         stmt2.close();

         conn.close();
     }
     catch (SQLException e)
     {
         out.println(e.getMessage());
         e.printStackTrace();
         return;
     }
     catch (Exception e)
     {
         out.println(e.getMessage());
     }
 %>
 
 <!-- *********************************************************************************************** -->      
          
            
      </div>
    </div>
  </div>
 
  <!-- Footer -->
 
  <footer class="row">
  <div class="large-12 columns"><hr />
      <div class="row">
 
        <div class="large-6 columns">
            <p>� Copyright no one at all. Go to town.</p>
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