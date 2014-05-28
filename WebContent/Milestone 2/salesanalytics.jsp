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
	<!-- Set language to java, and import sql package -->
	<%@ page language="java" import="java.sql.*, java.util.ArrayList"%>

	<!-- Connect to DataBase -->
	<% try {
            Class.forName("org.postgresql.Driver");
 			Connection conn = DriverManager.getConnection(
 							  "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 			
 			 Statement stmt_states = conn.createStatement();
 	         ResultSet rs_states = stmt_states.executeQuery("SELECT state_id FROM states ORDER BY state_id");
 	         String WHERE_ROWS = "";
 	         String WHERE_COLS = "";
 	         String RowParam = "";
 	         
 	         ResultSet rset_Join = null;
 	         ResultSet rset_JoinRows = null;
 	         Statement stmt_cats = conn.createStatement();
 	         ResultSet rs_cats = stmt_cats.executeQuery("SELECT name, id FROM categories ORDER BY name");
 	         ResultSet rset_TESTTT = null;
 	         Statement stmt_users = conn.createStatement();
 	         
 	        int offset = 0;    //default offset is 0 (first load of page)*
	         
	         //check if offset is set, therefore need to change value of offset*
	         if(request.getParameter("offset") != null) {
	        	 offset = Integer.parseInt(request.getParameter("offset"));
	         }
 	         if(request.getParameter("big_filter") == null)
 	         {
 	        	Statement stmt_Join = conn.createStatement();
	        	  
	        	rset_Join = stmt_Join.executeQuery("SELECT SUM(quantity* sales.price) AS total, products.name"+
	        			  " FROM sales INNER JOIN users ON users.id = sales.uid RIGHT OUTER JOIN products"+
	        			  " ON products.id = sales.pid GROUP BY products.name ORDER BY products.name");
	        	
	        	Statement stmt_JoinRows = conn.createStatement();

           	    rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, states.state_id AS state FROM sales INNER JOIN users ON users.id = sales.uid INNER JOIN products "+
	        	  "ON products.id = sales.pid RIGHT OUTER JOIN states ON states.state_id=users.state GROUP BY states.state_id ORDER BY states.state_id");
           	    
           	 Statement stmt_TESTTT = conn.createStatement();
        	  rset_TESTTT = stmt_TESTTT.executeQuery("SELECT SUM(quantity* sales.price) AS total, products.name, states.state_id "+
        			" FROM sales RIGHT OUTER JOIN products ON sales.pid = products.id INNER JOIN users ON users.id = sales.uid "+
        			" FULL OUTER JOIN states ON states.state_id = users.state GROUP BY products.name, states.state_id ORDER BY states.state_id");
 	         }
 	         else if(request.getParameter("big_filter").equals("customers"))
 	         {
 	        	 System.out.println(" Customers");
 	        	if(!request.getParameter("states").equals("all"))
      		    {
      				WHERE_ROWS +=  "WHERE users.state = '" + request.getParameter("states")+"'";
      		   	}
      		   	if(!request.getParameter("age").equals("all"))
      		   	{
      				String age[] = request.getParameter("age").split("-");
      			   //states is all
      			   if(WHERE_ROWS.length() == 0)
      			   {
      				   WHERE_ROWS +=  "WHERE users.age BETWEEN " + age[0] + " AND " + age[1];
      			   }
      			   else
      			   {
      				   WHERE_ROWS += " AND users.age BETWEEN " +age[0] + " AND " + age[1];
      			   }
      		   }
      		   if(!request.getParameter("product_cat").equals("all"))
      		   {
      			   out.println(request.getParameter("product_cat"));
      			   WHERE_COLS += "WHERE products.cid = " + request.getParameter("product_cat");
      		   }
      		   
      		   
      		 PreparedStatement seleUsers = conn.prepareStatement("DROP TABLE IF EXISTS SelectedUsers; SELECT id, name, age, state INTO TEMP SelectedUsers FROM users "+ WHERE_ROWS+ " ORDER BY state");
       	   seleUsers.executeUpdate();
       	  
       	  //Create the selected products temp table
       	  
       	  PreparedStatement seleProds = conn.prepareStatement("DROP TABLE IF EXISTS SelectedProducts; SELECT id, cid, name INTO TEMP SelectedProducts FROM products " + WHERE_COLS);
      	  seleProds.executeUpdate();
      	  
      	  Statement stmt_Join = conn.createStatement();
      	  
      	  rset_Join = stmt_Join.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name"+
      			  " FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid RIGHT OUTER JOIN SelectedProducts"+
      			  " ON SelectedProducts.id = sales.pid GROUP BY SelectedProducts.name ORDER BY SelectedProducts.name");
       	   
      	  Statement stmt_JoinRows = conn.createStatement();

      	  rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedUsers.name AS state "+
      			"FROM sales INNER JOIN SelectedProducts ON SelectedProducts.id = sales.pid RIGHT OUTER JOIN SelectedUsers ON SelectedUsers.id = sales.uid "+
      			"GROUP BY SelectedUsers.name ORDER BY SelectedUsers.name");
       	  Statement stmt_TESTTT = conn.createStatement();
       	  rset_TESTTT = stmt_TESTTT.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name, SelectedUsers.name AS state_id "+
       			" FROM sales INNER JOIN SelectedProducts ON sales.pid = SelectedProducts.id RIGHT OUTER JOIN SelectedUsers ON SelectedUsers.id = sales.uid "+
       			"GROUP BY SelectedProducts.name, SelectedUsers.name ORDER BY SelectedUsers.name");
      		   
      		   
 	         }
	         else if(request.getParameter("big_filter").equals("states"))
 	         {
 	        	   if(request.getParameter("big_filter").equals("states"))
 	        	   {
 	        		   if(!request.getParameter("states").equals("all"))
 	        		   {
 	        			   WHERE_ROWS +=  "WHERE users.state = '" + request.getParameter("states")+"'";
 	        		   }
 	        		   if(!request.getParameter("age").equals("all"))
 	        		   {
 	        			   String age[] = request.getParameter("age").split("-");
 	        			   //states is all
 	        			   if(WHERE_ROWS.length() == 0)
 	        			   {
 	        				   WHERE_ROWS +=  "WHERE users.age BETWEEN " + age[0] + " AND " + age[1];
 	        			   }
 	        			   else
 	        			   {
 	        				   WHERE_ROWS += " AND users.age BETWEEN " +age[0] + " AND " + age[1];
 	        			   }
 	        		   }
 	        		   if(!request.getParameter("product_cat").equals("all"))
 	        		   {
 	        			   out.println(request.getParameter("product_cat"));
 	        			   WHERE_COLS += "WHERE products.cid = " + request.getParameter("product_cat");
 	        		   }
 	        	   }   
 	        	   
 	        	   
					//Create the selected users temp table

 	        	   PreparedStatement seleUsers = conn.prepareStatement("DROP TABLE IF EXISTS SelectedUsers; SELECT id, name, age, state INTO TEMP SelectedUsers FROM users "+ WHERE_ROWS+ " ORDER BY state");
 	        	   seleUsers.executeUpdate();
 	        	  
 	        	  //Create the selected products temp table
 	        	  
 	        	  PreparedStatement seleProds = conn.prepareStatement("DROP TABLE IF EXISTS SelectedProducts; SELECT id, cid, name INTO TEMP SelectedProducts FROM products " + WHERE_COLS);
	        	  seleProds.executeUpdate();
	        	  
	        	  Statement stmt_Join = conn.createStatement();
	        	  
	        	  rset_Join = stmt_Join.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name"+
	        			  " FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid RIGHT OUTER JOIN SelectedProducts"+
	        			  " ON SelectedProducts.id = sales.pid GROUP BY SelectedProducts.name ORDER BY SelectedProducts.name");
 	        	   
	        	  Statement stmt_JoinRows = conn.createStatement();
 	        	  if(request.getParameter("states").equals("all"))
 	        	  {
	        	  rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, states.state_id AS state FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid INNER JOIN SelectedProducts "+
	        	  "ON SelectedProducts.id = sales.pid RIGHT OUTER JOIN states ON states.state_id=SelectedUsers.state GROUP BY states.state_id ORDER BY states.state_id");
 	        	  }
 	        	  else
 	        	  {
 	        		 rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedUsers.state FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid INNER JOIN SelectedProducts "+
 	      	        	  "ON SelectedProducts.id = sales.pid GROUP BY SelectedUsers.state ORDER BY SelectedUsers.state");
 	        	  }
 	        	  Statement stmt_TESTTT = conn.createStatement();
 	        	  rset_TESTTT = stmt_TESTTT.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name, states.state_id "+
 	        			" FROM sales INNER JOIN SelectedProducts ON sales.pid = SelectedProducts.id INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid "+
 	        			" FULL OUTER JOIN states ON states.state_id = SelectedUsers.state GROUP BY SelectedProducts.name, states.state_id ORDER BY states.state_id");
 	         }
 	  //       while(rset_TESTTT.next())
 	 //        {
 	 //       	 System.out.println(rset_TESTTT.getInt("total") + " A " + rset_TESTTT.getString("name") + " state " + rset_TESTTT.getString("state_id"));
 	  //       }
 	         ArrayList<String> ar = new ArrayList<String>();
 		%>
	<!-- Navigation -->

	<nav class="top-bar" data-topbar>
	<ul class="title-area">
		<!-- Title Area -->
		<li class="name">
			<h1>
				<a href="home.jsp"> PYTS Home </a>
			</h1>
		</li>
		<li class="toggle-topbar menu-icon"><a href="#"><span>menu</span></a></li>
	</ul>

	<!-- SHOPPING CART LINK --> <section class="top-bar-section">
	<!-- Right Nav Section -->
	<ul class="right">
		<li><span id="welcome">Hello, You! </span></li>
		<li class="divider"></li>
		<li><a href="BuyShoppingCart.jsp"><img id="cart"
				src="../img/cart_icon.png" alt="" title="My Cart"></a></li>
		<li class="divider"></li>
	</ul>
	</section> </nav>

	<!-- End Top Bar -->

	<!-- Header -->
	<div class="row">
		<div class="large-12 columns">
			<img src="../img/yts_header.png" alt=""><br> <br>
		</div>
	</div>
	<div class="row" id="shift">
		<div class="row">
			<div class="panel">
				<div id="left-box">
					<form action="salesanalytics.jsp" method="GET">
						<h3>Filter</h3>

						<label>Rows:</label> <select name="big_filter">
							<option value="customers" selected="selected">Customers</option>
							<option value="states">States</option>
						</select> <label>State:</label> <select name="states">
							<option value="all">All States</option>
							<% while(rs_states.next()) { %>
							<option value=<%= rs_states.getString("state_id") %>>
								<%= rs_states.getString("state_id") %></option>
							<% } %>
						</select> <label>Product Category:</label> <select name="product_cat">
							<option value="all">All Categories</option>
							<% while(rs_cats.next()) { %>
							<option value=<%= rs_cats.getInt("id") %>>
								<%= rs_cats.getString("name") %></option>
							<% } %>
						</select> <label>Age:</label> <select name="age">
							<option value="all">All Ages</option>
							<option value="12-17">12-18</option>
							<option value="18-44">18-45</option>
							<option value="45-64">45-65</option>
							<option value="65-999">65+</option>
						</select> <input type="submit" value="Run Query" class="button"> <input
							type="reset" value="Clear Fields" class="button">
					</form>
				</div>
				<div id="right-box">
					<h3>Your Sales Analytics Report</h3>
					<hr>
					<table border="1">
						<tr>
							<th>Row Header</th>
							<%while(rset_Join.next()){ar.add(rset_Join.getString("name")); %>
							<td><%=rset_Join.getString("name") + " $" + rset_Join.getInt("total") %></td>
							<%} %>
						</tr>
						<%rset_TESTTT.next();
						
					    if (!(rset_JoinRows.isBeforeFirst()) && !request.getParameter("states").equals("all"))
					    {
					        %><tr><td><%=request.getParameter("states") + " ($0)"%></td>
                            <%for(int i=0; i< ar.size(); i++){%>
                                  <td>$0</td><% 
                              }%></tr><%}
					    else
					    {
		                    while(rset_JoinRows.next()){ 

							%>
						<tr><%while(rset_TESTTT.getString("state_id").equals(rset_JoinRows.getString("state")) == false )
							{
								rset_TESTTT.next();
								System.out.println(rset_TESTTT.getString("state_id")+" yup");
								System.out.println(rset_TESTTT.getString("state_id") + " " + rset_JoinRows.getString("state"));
								System.out.println("yup");
							}
							%>
							<td><%=rset_JoinRows.getString("state") + " $" + rset_JoinRows.getInt("total") %></td>
							<%for(int i=0; i< ar.size(); i++)
							{
							if(rset_TESTTT.getString("name") == null) 
							{
							%>
							<td><%="$" + "0" %></td>
							<%
								if((i+1) == ar.size() && rset_TESTTT.getString("state_id").equals(rset_JoinRows.getString("state")))
								{
									rset_TESTTT.next();
									if(rset_TESTTT.isAfterLast())
									{
										System.out.println("Hello");
										break;
									}
									System.out.println(rset_TESTTT.getString("state_id")+" yup woho");
									if(rset_TESTTT.getString("state_id").equals("WY"))
										System.out.println("YOHOHOHOHOH");
								}
							}
							else
							{
								if(rset_TESTTT.getString("name") != null && ar.get(i).equals(rset_TESTTT.getString("name")) && rset_TESTTT.getString("state_id").equals(rset_JoinRows.getString("state")))
								{%>
									<td><%=" $" +rset_TESTTT.getString("total") %></td>
								<%
								System.out.println(rset_TESTTT.getString("state_id")+" yup before");
								rset_TESTTT.next();
								if(rset_TESTTT.isAfterLast())
								{
									System.out.println("Hello 1");
									break;
								}
								System.out.println(rset_TESTTT.getString("state_id")+" yup after");
								if(rset_TESTTT.getString("state_id").equals("WY"))
									System.out.println(rset_JoinRows.getString("state")+" YOHOHOHOHOH " + i + " A " + rset_TESTTT.getString("name"));
								}
								else
								{%>
									<td>$ 0</td>
								<% 
								}
							}} %>
						</tr>
						<%} }%>
					</table>
				</div>
				<div class="divide"></div>
				<div id="next-btns">
					<form id="next10" class="float-left" action="salesanalytics.jsp"
						method="GET">
						<input type="submit" value="Next 10" class="button">
					</form>
					<form id="next20" action="salesanalytics.jsp" method="GET">
						<input type="submit" value="Next 20" class="button">
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
 	       	 	out.println(e.getMessage());
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
	<div class="large-12 columns">
		<hr />
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
