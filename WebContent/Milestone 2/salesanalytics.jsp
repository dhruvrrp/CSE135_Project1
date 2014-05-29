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
	<% 
	try 
	{
		
		Class.forName("org.postgresql.Driver");
 		Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 		
 		Statement stmt_states = conn.createStatement();
 		long startTime, endTime;
 		ResultSet rs_states = stmt_states.executeQuery("SELECT state_id FROM states ORDER BY state_id");
 		String WHERE_ROWS = "";
		String WHERE_COLS = "";    
		ResultSet rset_Join = null;
		ResultSet rset_JoinRows = null;
		Statement stmt_cats = conn.createStatement();
		ResultSet rs_cats = stmt_cats.executeQuery("SELECT name, id FROM categories ORDER BY name");
		ResultSet rset_Table = null;
		Statement stmt_users = conn.createStatement();        
		int offset = 0;    //default offset is 0 (first load of page)*
	         //check if offset is set, therefore need to change value of offset*
		if(request.getParameter("offset") != null) 
		{
			offset = Integer.parseInt(request.getParameter("offset"));
		}
		if(request.getParameter("big_filter") == null)
		{
			Statement stmt_Join = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);        	  
			
			// Initialize timer
			startTime = System.currentTimeMillis();
			rset_Join = stmt_Join.executeQuery("SELECT SUM(quantity* sales.price) AS total, products.name"+
 	       			  " FROM sales INNER JOIN users ON users.id = sales.uid RIGHT OUTER JOIN products"+
 	       			  " ON products.id = sales.pid GROUP BY products.name ORDER BY products.name LIMIT 10");
			// End timer
            endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_Join query: " + (endTime-startTime) + "ms");
 	        	   
			Statement stmt_JoinRows = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

			startTime = System.currentTimeMillis();
			rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, users.name AS state "+
 	       			"FROM sales INNER JOIN products ON products.id = sales.pid RIGHT OUTER JOIN users ON users.id = sales.uid "+
 	       			"GROUP BY users.name ORDER BY users.name LIMIT 20");
            endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
			
            startTime = System.currentTimeMillis();
            Statement stmt_Table = conn.createStatement();
			rset_Table = stmt_Table.executeQuery("SELECT SUM(quantity* sales.price) AS total, products.name, users.name AS state_id "+
 	        			" FROM sales INNER JOIN products ON sales.pid = products.id RIGHT OUTER JOIN users ON users.id = sales.uid "+
 	        			"GROUP BY products.name, users.name ORDER BY users.name");
			endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_Table query: " + (endTime-startTime) + "ms");
		}
		else if(request.getParameter("big_filter").equals("customers"))
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
				WHERE_COLS += "WHERE products.cid = " + request.getParameter("product_cat");
			}
  
	        startTime = System.currentTimeMillis();
			PreparedStatement seleUsers = conn.prepareStatement("DROP TABLE IF EXISTS SelectedUsers; SELECT id, name, age, state INTO TEMP SelectedUsers FROM users "+ WHERE_ROWS+ " ORDER BY state");
			seleUsers.executeUpdate();
            endTime = System.currentTimeMillis();
            System.out.println("Time for running seleUsers query: " + (endTime-startTime) + "ms");
      	  
			//Create the selected products temp table
			startTime = System.currentTimeMillis();
			PreparedStatement seleProds = conn.prepareStatement("DROP TABLE IF EXISTS SelectedProducts; SELECT id, cid, name INTO TEMP SelectedProducts FROM products " + WHERE_COLS);
			seleProds.executeUpdate();
            endTime = System.currentTimeMillis();
            System.out.println("Time for running seleProds query: " + (endTime-startTime) + "ms");
     	  
			Statement stmt_Join = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
     	    
			startTime = System.currentTimeMillis();
			rset_Join = stmt_Join.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name"+
					" FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid RIGHT OUTER JOIN SelectedProducts"+
     			  " ON SelectedProducts.id = sales.pid GROUP BY SelectedProducts.name ORDER BY SelectedProducts.name LIMIT 10");
			endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_Join query: " + (endTime-startTime) + "ms");
      	   
			Statement stmt_JoinRows = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

	        startTime = System.currentTimeMillis();
			rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedUsers.name AS state "+
     			"FROM sales INNER JOIN SelectedProducts ON SelectedProducts.id = sales.pid RIGHT OUTER JOIN SelectedUsers ON SelectedUsers.id = sales.uid "+
     			"GROUP BY SelectedUsers.name ORDER BY SelectedUsers.name LIMIT 20");
			endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
            
            startTime = System.currentTimeMillis();
			Statement stmt_Table = conn.createStatement();
			rset_Table = stmt_Table.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name, SelectedUsers.name AS state_id "+
      			" FROM sales INNER JOIN SelectedProducts ON sales.pid = SelectedProducts.id RIGHT OUTER JOIN SelectedUsers ON SelectedUsers.id = sales.uid "+
      			"GROUP BY SelectedProducts.name, SelectedUsers.name ORDER BY SelectedUsers.name");
			endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_Table query: " + (endTime-startTime) + "ms");
     		   
     		   
		}
		else if(request.getParameter("big_filter").equals("states"))
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
				WHERE_COLS += "WHERE products.cid = " + request.getParameter("product_cat");
			}
			//Create the selected users temp table
			startTime = System.currentTimeMillis();
			PreparedStatement seleUsers = conn.prepareStatement("DROP TABLE IF EXISTS SelectedUsers; SELECT id, name, age, state INTO TEMP SelectedUsers FROM users "+ WHERE_ROWS+ " ORDER BY state");
			seleUsers.executeUpdate();
			endTime = System.currentTimeMillis();
            System.out.println("Time for running seleUsers query: " + (endTime-startTime) + "ms");
 	        	  
			//Create the selected products temp table
 	        startTime = System.currentTimeMillis();
			PreparedStatement seleProds = conn.prepareStatement("DROP TABLE IF EXISTS SelectedProducts; SELECT id, cid, name INTO TEMP SelectedProducts FROM products " + WHERE_COLS);
			seleProds.executeUpdate();
			endTime = System.currentTimeMillis();
            System.out.println("Time for running seleProds query: " + (endTime-startTime) + "ms");
            
			Statement stmt_Join = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
	        
			startTime = System.currentTimeMillis();
			rset_Join = stmt_Join.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name"+
	        			  " FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid RIGHT OUTER JOIN SelectedProducts"+
	        			  " ON SelectedProducts.id = sales.pid GROUP BY SelectedProducts.name ORDER BY SelectedProducts.name LIMIT 10");
			endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_Join query: " + (endTime-startTime) + "ms");
 	        	   
			Statement stmt_JoinRows = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
			if(request.getParameter("states").equals("all"))
			{
				startTime = System.currentTimeMillis();
				rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, states.state_id AS state FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid INNER JOIN SelectedProducts "+
	        	  "ON SelectedProducts.id = sales.pid RIGHT OUTER JOIN states ON states.state_id=SelectedUsers.state GROUP BY states.state_id ORDER BY states.state_id LIMIT 20");
				endTime = System.currentTimeMillis();
	            System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
			}
			else
			{
                startTime = System.currentTimeMillis();
				rset_JoinRows = stmt_JoinRows.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedUsers.state FROM sales INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid INNER JOIN SelectedProducts "+
 	      	        	  "ON SelectedProducts.id = sales.pid GROUP BY SelectedUsers.state ORDER BY SelectedUsers.state");
				endTime = System.currentTimeMillis();
                System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
			}
			Statement stmt_Table = conn.createStatement();
			startTime = System.currentTimeMillis();
			rset_Table = stmt_Table.executeQuery("SELECT SUM(quantity* sales.price) AS total, SelectedProducts.name, states.state_id "+
 	        			" FROM sales INNER JOIN SelectedProducts ON sales.pid = SelectedProducts.id INNER JOIN SelectedUsers ON SelectedUsers.id = sales.uid "+
 	        			" FULL OUTER JOIN states ON states.state_id = SelectedUsers.state GROUP BY SelectedProducts.name, states.state_id ORDER BY states.state_id");
			endTime = System.currentTimeMillis();
            System.out.println("Time for running rset_Table query: " + (endTime-startTime) + "ms");
		}
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
							<%
							while(rset_Join.next())
							{
								ar.add(rset_Join.getString("name"));
								String truncate = rset_Join.getString("name");
								if(truncate.length() > 10)
									truncate = truncate.substring(0,10) + "...";%>
							<td class="bold"><%=truncate + " ($" + rset_Join.getInt("total") + ")" %></td>
						  <%} %>
						</tr>
						<%
						rset_Table.next();	
					    if (!(rset_JoinRows.isBeforeFirst()) && !request.getParameter("states").equals("all"))
					    {
					        %><tr><td class="bold"><%=request.getParameter("states") + " ($0)"%></td>
                            <%for(int i=0; i< ar.size(); i++)
                              {%>
                                  <td>$0</td><% 
                              }%></tr><%
                        }
					    else
					    {
		                    while(rset_JoinRows.next())
		                    { 
							%>
						<tr><%
								while(rset_Table.getString("state_id").equals(rset_JoinRows.getString("state")) == false )
								{
									rset_Table.next();
								}
							%>
							<td class="bold"><%=rset_JoinRows.getString("state") + " ($" + rset_JoinRows.getInt("total") + ")" %></td>
							<%
								for(int i=0; i< ar.size(); i++)
								{
									if(rset_Table.getString("name") == null) 
									{
							%>
							<td><%="$" + "0" %></td>
								<%
										if((i+1) == ar.size() && rset_Table.getString("state_id").equals(rset_JoinRows.getString("state")))
										{
											rset_Table.next();
											if(rset_Table.isAfterLast())
											{
												break;
											}
										}
									}
									else
									{
										if(rset_Table.getString("name") != null && ar.get(i).equals(rset_Table.getString("name")) && rset_Table.getString("state_id").equals(rset_JoinRows.getString("state")))
										{
								%>
									<td><%=" $" +rset_Table.getString("total") %></td>
								<%
											rset_Table.next();
											if(rset_Table.isAfterLast())
											{
												break;
											}		
										}
										else
										{
								%>
											<td>$0</td>
								<% 
										}
									}
								} 	%>
						</tr>
						<%	} 
		                }%>
					</table>
				</div>
				<div class="divide"></div>
				<div id="next-btns">
					<% 
						String big_filter = request.getParameter("big_filter");
						String states = request.getParameter("states");
						String product_cat = request.getParameter("product_cat");
						String age = request.getParameter("age");
						
						//if the big filter is null, then the page has been loaded for the first time
						if(big_filter == null) 
						{
							big_filter = "customers";
							states = "all";
							product_cat = "all";
							age = "all";
						}
						
						//reset the cursors 
						rset_Join.first();
						rset_JoinRows.first();
					%>
				
					<%	
						//check if there are any more tuples to display, if not, don't display button
						if(rset_Join.relative(9)) { 
					%>
					<form id="next10" class="float-left" action="salesanalyticsnext.jsp"
						method="GET">
						<input type="submit" value="Next 10 Products" class="button">
						<input type="hidden" name="colOffset" value="10">
						<input type="hidden" name="rowOffset" value="0">
						<input type="hidden" name="big_filter" value="<%= big_filter %>">
						<input type="hidden" name="states" value="<%= states %>">
						<input type="hidden" name="age" value="<%= age %>">
						<input type="hidden" name="product_cat" value="<%= product_cat %>">
					</form>
					<% } %>
					
					<% if(rset_JoinRows.relative(19))  {%>
					<form id="next20" action="salesanalyticsnext.jsp" method="GET">
						<input type="submit" value="Next 20 Rows" class="button">
						<input type="hidden" name="colOffset" value="0">
						<input type="hidden" name="rowOffset" value="20">
						<input type="hidden" name="big_filter" value="<%= big_filter %>">
						<input type="hidden" name="states" value="<%= states %>">
						<input type="hidden" name="age" value="<%= age %>">
						<input type="hidden" name="product_cat" value="<%= product_cat %>">
					</form>
					<% } %>
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
 			finally 
 			{
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
