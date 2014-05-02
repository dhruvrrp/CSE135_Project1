<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Home</title>
  <meta name="Author" content="Allen Gong">
  <meta name="description" content="Best place to get your goodies">
  
  <link rel="stylesheet" type="text/css" href="css/normalize.css">
  <link rel="stylesheet" type="text/css" href="css/foundation.css">
  <link rel="stylesheet" type="text/css" href="css/custom.css">
  
  <script type="text/javascript" src="js/vendor/jquery.js"></script>
  <script type="text/javascript" src="js/foundation.min.js"></script>
</head>
<body>
 
 <!-- *****************************************JSP*************************************************** -->
 	
 	<!-- Set language to java, and import sqql package -->
 	<%@ page language="java" import="java.sql.*" %>
 	    
 	    <!-- Connect to DataBase -->
 		<% try {
            Class.forName("org.postgresql.Driver");
 			Connection conn = DriverManager.getConnection(
 							  "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 			
 			Statement stmt = conn.createStatement();
 			
 			//get the role of the current user who owns this session
 			ResultSet rset_role = stmt.executeQuery("SELECT role FROM users WHERE name='" + 
 											session.getAttribute("session_username") + "'" );
 			//get the tuple (there should only be one)
 			rset_role.next();
 			String user_role = rset_role.getString("role");
 			
 			
 			
 		%>
 			<!-- Navigation -->
 
  			<nav class="top-bar" data-topbar>
    			<ul class="title-area">
      			<!-- Title Area -->
     			<li class="name">
        			<h1>
          			<a href="home.jsp">
            			PYTS Home
         			</a>
        			</h1>
      			</li>
      			<li class="toggle-topbar menu-icon"><a href="#"><span>menu</span></a></li>
    			</ul>
    
    			<!-- SHOPPING CART LINK -->
    			<section class="top-bar-section">
      			<!-- Right Nav Section -->
      			<ul class="right">
      			<li><span id="welcome">Hello, <%= session.getAttribute("session_username") %>! </span></li>
        			<li class="divider"></li>
        			<li><a href="BuyShoppingCart.jsp"><img id="cart" src="img/cart_icon.png" alt="" title="My Cart"></a></li>
        			<li class="divider"></li>
      			</ul>
    			</section>
  			</nav>
 
  			<!-- End Top Bar -->
 
  			<!-- Header -->
  			<div class="row">
    			<div class="large-12 columns">
      			<img src="img/yts_header.png" alt=""><br><br>
    			</div>
  			</div>
 			<div class="row" id="shift">
      			<div class="row">
          			<div class="panel">     
          				<span id="welcome">Hello <%= session.getAttribute("session_username") %> </span>
          				<br>
          				<h4>Welcome <%= session.getAttribute("session_username") %>! These are the
          				options you can choose because you are a(n)
          				<%= user_role %> :
          				</h4><br>    
          				<% if(user_role != null && user_role.equals("Owner")) { %>   
       	  				<div class="center">
       	  					<a href="categories.jsp" class="button">Categories</a>
       	  					<a href="products.jsp" class="button">Products</a>
       	  					<a href="ProductBrowsing.jsp" class="button">Product Browsing</a>
       	  				</div>
       	  				<% } else if(user_role != null && user_role.equals("Customer")) { %>
       	  					<div class="center"><a href="ProductBrowsing.jsp" class="button">Products Browsing</a></div>
       	  				<% } %>
          			</div>
    			</div>
  			</div>
 		
 		
 		<% 
 			rset_role.close();
			stmt.close();
			conn.close();
 			}
 			catch (SQLException e)
 	    	{
 	       	 	out.println("You must be logged in to view this page!");
 	       	 	return;
 	    	}
 	    	catch (Exception e)
 	    	{
 	     		out.println(e.getMessage());
 	    	}
 			finally {
 				//throws exception if you try to close here?
 			}
        %>
 <!-- *********************************************************************************************** -->
 
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