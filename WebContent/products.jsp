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
 	   	<% String ERROR_MISSING_CATNAME   = "23514"; %>
 	    
 	    <!-- Connect to DataBase -->
 		<% try {
            Class.forName("org.postgresql.Driver");
 			Connection conn = DriverManager.getConnection(
 							  "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 			
 			Statement stmt_cat = conn.createStatement();

 			
 			//get all category tuples
 			ResultSet rset_cat = stmt_cat.executeQuery("SELECT * FROM categories");
 			
 			//insert,update,delete, and search handling 
 			Statement stmt_prod_filter = conn.createStatement();
 			
 			//used to be WHERE 1=0
 			ResultSet rset_prod_filter = stmt_prod_filter.executeQuery("SELECT * FROM products");
 			
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
          			<%
          			/////////////////////////////actions//////////////////////////////////
          			//get the requested action (if applicable)
         			String action = request.getParameter("action");
         			
         			//check if search was selected
         			if(action!=null && action.equals("search")) {
         				rset_prod_filter = stmt_prod_filter.executeQuery("SELECT * FROM products" +
        							" WHERE name ILIKE '%" + request.getParameter("search_for")+"%'");
         				
         				if(!rset_prod_filter.isBeforeFirst()) {
         					out.print("Sorry, no results found for \"" + request.getParameter("search_for") +
         									"\"");
         				}
         			}
         			
         			//check for insert action
         			else if(action!=null && action.equals("insert")) {
         				try {
         				
         				
         				//first we need to find what category was in the insert
         				Statement stmt = conn.createStatement();
         				ResultSet rset_ = stmt.executeQuery("SELECT category_id FROM categories WHERE name='" +
         									request.getParameter("prod_category") + "'");
         				rset_.next();
         				int cat_id = rset_.getInt("category_id");
         				PreparedStatement pstmt = conn.prepareStatement("INSERT INTO products (name,sku,category,price)" + 
         																	"VALUES (?,?,?,?)");
         				
         				if(request.getParameter("prod_name").equals("")) {
         					throw new SQLException();
         				}
         				
         				//transaction
         				conn.setAutoCommit(false);
         				
         				//set appropriate fields
         				pstmt.setString(1,request.getParameter("prod_name"));
         				pstmt.setString(2, request.getParameter("prod_sku"));
         				pstmt.setInt(3, cat_id);
         				pstmt.setDouble(4, Double.parseDouble(request.getParameter("prod_price")));
         				
         				int count = pstmt.executeUpdate();
         				conn.commit();   //end transaction
         				
         				
         				//if no rows were affected
         				if(count == 0) {
         					out.println("Failure to insert new product.");	
         					return;
         				}
         	
         				pstmt.close();
         				rset_.close();
         				stmt.close();
         				out.print("Insertion Successful - inserted: " + request.getParameter("prod_name"));
         				
         				//reset the products displayed in table
     					rset_prod_filter = stmt_prod_filter.executeQuery("SELECT * FROM products");
         				}
         				catch(SQLException e){
         					out.println("Failure to insert new product.");
         				}
         				catch(Exception e) {
         					out.println("Failure to insert new product");
         				}
         				finally {
         					conn.setAutoCommit(true); //reset autocommit back to true
         				}
         			}
         			//if action was an update
         			else if(action!=null && action.equals("update")) {
         				
         				try {
         				//prepare statement
         				PreparedStatement pstmt_update = conn.prepareStatement("UPDATE products" + 
         								" SET name=?, sku=?, category=?, price=? " + "WHERE product_id=" + 
         								request.getParameter("pkey"));
         				
         				//get the category id
         				Statement stmt_catID = conn.createStatement();
         				ResultSet rset_catID = stmt_catID.executeQuery("SELECT category_id FROM categories WHERE" +
         								" name='" + request.getParameter("prod_cat") + "'");
         				
         				//preliminary check to ensure product still exists
         				Statement testStatement = conn.createStatement();
         				ResultSet test_rset = testStatement.executeQuery("SELECT * FROM products WHERE name='" +
         										request.getParameter("prod_name") + "'");
         				
         				
         				//check if the product was deleted
         				if(!test_rset.isBeforeFirst()) {
         					throw new SQLException();
         				}
         				
         				//get the category id of the product
         				rset_catID.next();
         				int cat_id = rset_catID.getInt("category_id");
         				
         				//check if input name was null
         				if(request.getParameter("prod_name").equals("")) {
         					throw new SQLException();
         				}
         				
         				conn.setAutoCommit(false);  //transaction start
         				pstmt_update.setString(1, request.getParameter("prod_name"));
         				pstmt_update.setString(2, request.getParameter("prod_sku"));
         				pstmt_update.setInt(3, cat_id);
         				pstmt_update.setDouble(4, Double.parseDouble(request.getParameter("prod_price")));
         				
         				int count = pstmt_update.executeUpdate();
         				conn.commit();   //end transaction
         				conn.setAutoCommit(true);
         				
         				//close statements
         				rset_catID.close();
         				stmt_catID.close();
         				pstmt_update.close();
         				test_rset.close();
         				testStatement.close();
         				
         				out.print("Update Successful - updated: " + request.getParameter("prod_name"));
         				
         				//reset the products displayed in table
     					rset_prod_filter = stmt_prod_filter.executeQuery("SELECT * FROM products");
         				}
         				catch(SQLException e) {
         					out.println("Failure to update product.");
         					
         					//set autocommit to be false so rollback is possible
         					conn.setAutoCommit(false);
         					
         					//rollback any changes
         					conn.rollback();
         				}
         				catch(Exception e)
         	 	    	{	
         					System.out.println("big error");
         	 	     		out.println(e.getMessage());
         	 	    	}
         				finally {
         					//make sure to reset ac to true 
         					conn.setAutoCommit(true);
         				}
         			}
         			//check if action was delete
         			else if(action!=null && action.equals("delete")) {
         				try {
         					conn.setAutoCommit(false);  //transaction power up!
         					PreparedStatement pstmt_del = conn.prepareStatement("DELETE FROM products WHERE" +
        							" product_id=" + request.getParameter("pkey"));
         					
         					pstmt_del.executeUpdate();
         					
         					conn.commit();
         					conn.setAutoCommit(true);
         					out.print("Deletion Successful - deleted: " + request.getParameter("prod_name"));
         					
         					//reset the products displayed in table
         					rset_prod_filter = stmt_prod_filter.executeQuery("SELECT * FROM products");
         				}
         				catch(SQLException e) {
         					out.println("Failure to delete product.");
         					out.println(e.getMessage());
         					e.printStackTrace();
         				}
         				catch (Exception e)
         	 	    	{
         	 	     		out.println(e.getMessage());
         	 	    	}
         				
         			}
         			
          			%>
          				<span id="welcome">Hello <%= session.getAttribute("session_username") %> </span>
          				<br>
          				<h4>Search for products by name</h4>
          				<form method="GET" action="products.jsp"> 
          					<input id="search_bar" type="text" name="search_for" autofocus="autofocus">
          					<input type="submit" value="Search" class="button">
          					<input type="hidden" value="search" name="action">
          				</form><hr><br>
          				<h4>Add, view, or modify products here</h4><hr>
          				<table border="1">
          					<tr>
          						<th>Product SKU</th>
          						<th>Name</th>
          						<th>Category</th>
          						<th>Price</th>
          						<th colspan="2">Action</th>
          					</tr>
          					
          					<!-- Insert form -->
          					<tr>
          					<form action="products.jsp" method="POST">
          						<input type="hidden" name="action" value="insert">
          						<th><input type="text" name="prod_sku"></th>
          						<th><input type="text" name="prod_name"></th>
          						<th><select name="prod_category">
          								<% rset_cat = stmt_cat.executeQuery("SELECT * FROM categories");
          								   while(rset_cat.next()) { %>
          								<option value="<%= rset_cat.getString("name") %>"><%= rset_cat.getString("name") %></option>
          								<% } %>
          							</select>
          						</th>
          						<th><input type="text" name="prod_price"></th>
          						<th><input type="submit" value="Insert" class="button"></th>
          						<th></th>
          					</form>
          					</tr>
          					<%-- Populate the table --%>
          					<% while(rset_prod_filter.next()) { %>
          						<% 
          						    //get the primary key id of the current product
          						    int product_pkey = rset_prod_filter.getInt("product_id");
          						    
          							//get the integer id of category the current product
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
          						<form action="products.jsp" method="POST">
          						<td><input type="text" name="prod_sku" value="<%= rset_prod_filter.getString("sku") %>"></td>
          						<td><input type="text" name="prod_name" value="<%= rset_prod_filter.getString("name") %>"></td>
          						<td><select name="prod_cat">
          								<% rset_cat = stmt_cat.executeQuery("SELECT * FROM categories");
          								   while(rset_cat.next()) { 
          								   if(rset_cat.getString("name").equals(current_category)) { %>
          								   		<option value="<%= current_category %>" selected><%= current_category %></option>   
          								  <% } else {
          								 %>
          								<option value="<%= rset_cat.getString("name") %>"><%= rset_cat.getString("name") %></option>
          								<% } }%>
          							</select>
          						</td>
          						<td><input type="text" name="prod_price" value="<%= rset_prod_filter.getFloat("price") %>"></td>
          						<td><input type="submit" value="Update" class="small button"></td>
          						<input type="hidden" name="action" value="update">
          						<input type="hidden" name="pkey" value="<%= product_pkey %>">
          						</form>		
          						<form action="products.jsp" method="GET">
          							<input type="hidden" name="pkey" value="<%= product_pkey %>">
          							<input type="hidden" name="prod_name" value="<%= rset_prod_filter.getString("name") %>">
          							<input type="hidden" name="action" value="delete">
          							<td><input type="submit" value="Delete" class="small button"></td>
          						</form>
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
 			rset_prod_filter.close();
 			stmt_prod_filter.close();
 			rset_cat.close();
 			stmt_cat.close();
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