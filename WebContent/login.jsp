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
            
            <form method="post" action="login.jsp">
              Name: <input type="text" name="param_username" />
              <input type="hidden" name="loginClicked" value="true" />
              <input type="submit" value="Log in" class="button">
            </form> 
            
 <!-- *****************************************JSP*************************************************** -->
 	
 	
 	<%@ page language="java" import="java.sql.*" %>
 	    
 	    <!-- Connect to DataBase -->
 		
 		<% 
            Class.forName("org.postgresql.Driver");
 			Connection conn = DriverManager.getConnection(
 							  "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 		
 			// Check if the Login button has been clicked
            String clicked = request.getParameter("loginClicked");
 		    if (clicked != null && clicked.equals("true"))
 		    {
 			    conn.setAutoCommit(false);
 			
 	  		    // Initialization 
 	 		    Statement stmt_user = conn.createStatement();
 			    ResultSet rset_user = stmt_user.executeQuery("SELECT * FROM Users WHERE name='" + 
 	 				 								         request.getParameter("param_username") + "'");
/*  			    Statement stmt_userid = conn.createStatement();
 			    ResultSet rset_userid = stmt_userid.executeQuery("SELECT user_id FROM Users WHERE"); */
				//Check if username is valid
                if(rset_user.next()) 
                { 
                    // Save username in session
                    String username = request.getParameter("param_username");
                    int userid = rset_user.getInt("user_id");
                    session.setAttribute("session_username", username);
                    session.setAttribute("session_userid", userid);
                    
                    // Redirect to home page
                    String redirectURL = "home.jsp";
                    response.sendRedirect(redirectURL);
                } 
                // Else invalid username
                else 
                {
            	    out.println("The provided name \"" + 
                                request.getParameter("param_username") + 
                                "\" is not known.");
                }
            
                conn.commit();
                conn.setAutoCommit(true);
                conn.close();
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
            <p>&copy; Allen Gong, Dhruv Kaushal, Jasmine Nguyen.</p>
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