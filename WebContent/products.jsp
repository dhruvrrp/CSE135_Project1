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
 	
 	<!-- Set language to java, and import sqql package -->
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
 			
 		%>
 			<div class="row" id="shift">
      			<div class="row">
          			<div class="panel">     
          				<span id="welcome">Hello <%= session.getAttribute("session_username") %> </span>
          				<br>
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
          					<form action="" method="POST">
          						<input type="hidden" name="action" value="insert">
          						<th><input type="text" name="prod_sku" autofocus="autofocus"></th>
          						<th><input type="text" name="prod_name"></th>
          						<th><input type="text" name="prod_category"></th>
          						<th><input type="text" name="prod_price"></th>
          						<th><input type="submit" value="Insert" class="button"></th>
          					</form>
          					</tr>
          					<%-- Populate the table --%>
          					<% while(rset_prod.next()) { %>
          						<% 
          							//get the integer id of the current product
          							int category_id = rset_prod.getInt("category");
          						
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
          						<td><input type="text" name="prod_sku" value="<%= rset_prod.getString("sku") %>"></td>
          						<td><input type="text" name="prod_name" value="<%= rset_prod.getString("name") %>"></td>
          						<td><input type="text" name="prod_category" value="<%= current_category %>"></td>
          						<td><input type="text" name="prod_price" value="<%= rset_prod.getInt("price") %>"></td>
          						<td><input type="submit" value="Update" class="small button"><input type="submit" value="Delete" class="small button"></td>
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