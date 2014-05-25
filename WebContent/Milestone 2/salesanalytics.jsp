<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Sales Analytics</title>
  <meta name="Author" content="Allen Gong">
  <meta name="description" content="Best place to get your goodies">
  
  <link rel="stylesheet" type="text/css" href="../css/normalize.css">
  <link rel="stylesheet" type="text/css" href="../css/foundation.css">
  <link rel="stylesheet" type="text/css" href="../css/custom.css">
  
  <script type="text/javascript" src="../js/vendor/jquery.js"></script>
  <script type="text/javascript" src="../js/foundation.min.js"></script>
</head>
<body>
 
 
 
 <!-- *****************************************JSP*************************************************** -->
 	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
 	<!-- Set language to java, and import sqql package -->
 	<%@ page language="java" import="java.sql.*" %>
 	    
 	    <!-- Connect to DataBase -->
 		<% try {
            Class.forName("org.postgresql.Driver");
 			Connection conn = DriverManager.getConnection(
 							  "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 			
 			 Statement stmt_states = conn.createStatement();
 	         ResultSet rs_states = stmt_states.executeQuery("SELECT state_id FROM states ORDER BY state_id");
 	         String WHERE_ROWS = "";
 	         String WHERE_COLS = "";
 	         Statement stmt_cats = conn.createStatement();
 	         ResultSet rs_cats = stmt_cats.executeQuery("SELECT name, id FROM categories ORDER BY name");
 	         if(request.getParameter("big_filter") != null)
 	         {
 	        	   if(request.getParameter("big_filter").equals("states"))
 	        	   {
 	        		   if(!request.getParameter("states").equals("all"))
 	        		   {
 	        			   WHERE_ROWS +=  "WHERE states.state_id = " + request.getParameter("states");
 	        		   }
 	        		   if(!request.getParameter("age").equals("all"))
 	        		   {
 	        			   //states is all
 	        			   if(WHERE_ROWS.length() == 0)
 	        			   {
 	        				   WHERE_ROWS +=  "WHERE users.age = " + request.getParameter("age");
 	        			   }
 	        			   else
 	        			   {
 	        				   WHERE_ROWS += " AND users.age = " + request.getParameter("age");
 	        			   }
 	        		   }
 	        		   if(!request.getParameter("product_cat").equals("all"))
 	        		   {
 	        			   WHERE_COLS += "WHERE products.cid = " + request.getParameter("product_cat");
 	        		   }
 	        	   }
 	        	   String qRow = "SELECT * FROM users " + WHERE_ROWS;
 	        	   String qCol = "SELECT * FROM products " + WHERE_COLS;
 	        	   out.println(qCol + " |||");
 	         }
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
      			<li><span id="welcome">Hello, You! </span></li>
        			<li class="divider"></li>
        			<li><a href="BuyShoppingCart.jsp"><img id="cart" src="../img/cart_icon.png" alt="" title="My Cart"></a></li>
        			<li class="divider"></li>
      			</ul>
    			</section>
  			</nav>
 
  			<!-- End Top Bar -->
 
  			<!-- Header -->
  			<div class="row">
    			<div class="large-12 columns">
      			<img src="../img/yts_header.png" alt=""><br><br>
    			</div>
  			</div>
 			<div class="row" id="shift">
      			<div class="row">
          			<div class="panel">     
          				<div id="left-box">
          					<form action="" method="GET">
          						<h3>Filter</h3>
          						
          						<label>Rows:</label>
          				    	<select name="big_filter">
          				    		<option value="customers" selected="selected">Customers</option>
          				    		<option value="states">States</option>
          				    	</select>
          				    	
          				    	<label>State:</label>
          				    	<select name="states">
          				    	    <option value="all">All States</option>
                                    <% while(rs_states.next()) { %>
                                        <option value= <%= rs_states.getString("state_id") %>>
                                        <%= rs_states.getString("state_id") %></option>
                                    <% } %>
                                </select> 
          				    	<label>Product Category:</label>
          				    	<select name="product_cat">
          				    	    <option value="all">All Categories</option>
                                    <% while(rs_cats.next()) { %>
                                        <option value= <%= rs_cats.getInt("id") %>>
                                        <%= rs_cats.getString("name") %></option>
                                    <% } %>
                                </select> 
          				    	<label>Age:</label>
          				    	<select name="age">
          				    		<option value="all">All Ages</option>
          				    		<option value="1">12-18</option>
          				    		<option value="2">18-45</option>
          				    		<option value="3">45-65</option>
          				    		<option value="4">65+</option>
          				    	</select>
          				    	<input type="submit" value="Run Query" class="button">
          				    	<input type="reset" value="Clear Fields" class="button">
          					</form> 
          				</div>
          				<div id="right-box">
          					<h3>Your Sales Analytics Report</h3><hr>
          					<table border="1">
          						<tr>
          							<th>Row Header</th>
          							<td>Product 1</td>
          						</tr>
          						<tr>
          							<td>Customer 1</td>
          							<td>$599</td>
          						</tr>
          						<tr>
          							<td>State 1</td>
          							<td>$200</td>
          						</tr>
          					</table>
          				</div>
          				<div class="divide"></div>
          				<div id="next-btns">
          					<form id="next10" class="float-left" action="salesanalytics.jsp" method="GET">
          						<input type="submit" value="Next 10 Products" class="button">
          						<input type="hidden" name="action" value="next10">
          					</form>
          					<form id="next20" action="salesanalytics.jsp" method="GET">
          						<input type="submit" value="Next 20 Customers" class="button">
          						<input type="hidden" name="action" value="next20">
          					</form>
          				</div>
          				<div class="divide"></div>
          			</div>
    			</div>
  			</div>
 		
 		<% 
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
  
  <footer class="row" id="footer">
  <div class="large-12 columns"><hr />
      <div class="row">
 
        <div class="large-6 columns">
            <p>&copy; Allen Gong, Dhruv Kaushal, Jasmine Nguyen.</p>
        </div>
      </div>
  </div>
  </footer>
  <script src="../../assets/js/jquery.js"></script>
    <script src="../../assets/js/templates/foundation.js"></script>
    <script>
      $(document).foundation();

      var doc = document.documentElement;
      doc.setAttribute('data-useragent', navigator.userAgent);
      </script>
</body>
</html>