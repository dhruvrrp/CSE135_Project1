<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Products</title>
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
 <!-- *****************************************JSP*************************************************** -->
 	
 	<!-- Set language to java, and import sql package -->
 	<%@ page language="java" import="java.sql.*" %>
 	    
 	    <!-- Connect to DataBase -->
 		<% try {
            Class.forName("org.postgresql.Driver");
 			Connection conn = DriverManager.getConnection(
 							  "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 			
 			Statement stmt_prod = conn.createStatement();
 			Statement stmt_cat = conn.createStatement();
 			
 			//get all tuples from the products table
 			ResultSet rset_prod = stmt_prod.executeQuery("SELECT * FROM products");
 			
 			//get all category tuples
 			ResultSet rset_cat = stmt_cat.executeQuery("SELECT * FROM categories");
 			
 			
 			
 			
 			
 			
 			//insert,update,delete, and search
 			String search_param = request.getParameter("search_for");
 			
 			
 			Statement stmt_prod_filter = conn.createStatement();
 			ResultSet rset_prod_filter = stmt_prod_filter.executeQuery("SELECT * FROM products");
 			
 			//get the requested action (if applicable)
 			String action = request.getParameter("action");
 			
 			//check if search was selected
 			if(action!=null && action.equals("search")) {
 				System.out.println("entered here: " + request.getParameter("search_for"));
 				rset_prod_filter = stmt_prod_filter.executeQuery("SELECT * FROM products" +
							" WHERE name LIKE '%" + request.getParameter("search_for")+"%'");
 			}
 			
 			//check for insert action
 			if(action!=null && action.equals("insert")) {
 				//first we need to find what category was in the insert
 				Statement stmt = conn.createStatement();
 				ResultSet rset_ = stmt.executeQuery("SELECT category_id FROM categories WHERE name='" +
 									request.getParameter("prod_category") + "'");
 				rset_.next();
 				int cat_id = rset_.getInt("category_id");
 				
 				PreparedStatement pstmt = conn.prepareStatement("INSERT INTO products (name,sku,category,price)" + 
 																	"VALUES (?,?,?,?)");
 				pstmt.setString(1,request.getParameter("prod_name"));
 				pstmt.setString(2, request.getParameter("prod_sku"));
 				pstmt.setInt(3, cat_id);
 				pstmt.setInt(4, Integer.parseInt(request.getParameter("prod_price")));
 				
 				
 				int count = pstmt.executeUpdate();
 				System.out.println(count);
 				pstmt.close();
 				rset_.close();
 				stmt.close();
 			}
 			
 		%>
 			<div id="prod_search">
  				<p><b>Filter</b></p>
  				<ul>
  					<li><a href="">All Products</a></li>
  					<% while(rset_cat.next()) { %>
  						<li><a href=""><%= rset_cat.getString("name") %></a></li>
  					<% } %>
  				</ul>
  			</div>
 		
 		
 			<div class="row" id="shift">
      			<div class="row">
          			<div class="panel">     
          				<span id="welcome">Hello <%= session.getAttribute("session_username") %> </span>
          				<br>
          				<h4>Search for products</h4>
          				<form method="GET" action="products.jsp"> 
          					<input id="search_bar" type="text" name="search_for">
          					<input type="submit" value="Search" class="button">
          					<input type="hidden" value="search" name="action">
          				</form><hr><br>
          				<h4>Add or modify products here</h4><hr>
          				<table border="1">
          					<tr>
          						<th>Product SKU</th>
          						<th>Name</th>
          						<th>Category</th>
          						<th>Price</th>
          					</tr>
          					
          					<!-- Insert form -->
          					<tr>
          					<form action="products.jsp" method="POST">
          						<input type="hidden" name="action" value="insert">
          						<th><input type="text" name="prod_sku" autofocus="autofocus"></th>
          						<th><input type="text" name="prod_name"></th>
          						<th>
          						</th>
          						<th><input type="text" name="prod_price"></th>
          						<th><input type="submit" value="Insert" class="button"></th>
          						<th></th>
          					</form>
          					</tr>
          					<%-- Populate the table --%>
          					<% while(rset_prod_filter.next()) { %>
          						<% 
          							//get the integer id of the current product
          							int category_id = rset_prod_filter.getInt("category");
          						
          							//create a statement to retrieve name of current category
          						   	Statement get_cat = conn.createStatement();
          						   	ResultSet rset_current = get_cat.executeQuery("SELECT name FROM categories WHERE category_id="
          								   									+ category_id);
          						    //get the tuple from rset_current
          						   	rset_current.next();
          						    
          						    //get the category name as a string
          						   	String current_category = rset_current.getString("name");
          						   
          						%>
          						<tr>
          						<td><input type="text" name="prod_sku" value="<%= rset_prod_filter.getString("sku") %>"></td>
          						<td><input type="text" name="prod_name" value="<%= rset_prod_filter.getString("name") %>"></td>
          						<td><input type="text" name="prod_category" value="<%= current_category %>"></td>
          						<td><input type="text" name="prod_price" value="<%= rset_prod_filter.getInt("price") %>"></td>
          						<td><input type="submit" value="Update" class="small button"></td>
          						<td><input type="submit" value="Delete" class="small button"></td>
          						</tr>
          					<%
          						rset_current.close();
          					} 
          					%>
          					
          				</table>
          			</div>
    			</div>
  			</div>
 		
 		
 		<% 
 			//close connections to db
 			rset_cat.close();
 			rset_prod.close();
 			stmt_cat.close();
 			stmt_prod.close();
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