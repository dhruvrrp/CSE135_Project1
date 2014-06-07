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
	<%@ page language="java" import="java.sql.*" import="java.util.ArrayList"%>

	<!-- Connect to DataBase -->
	<% 
	try 
	{
		long start=System.currentTimeMillis();
		
		Class.forName("org.postgresql.Driver");
 		Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE1351", "postgres", "calcium");
 		
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
			rset_Join = stmt_Join.executeQuery(
					"SELECT sum(total) as total, name " +
					"FROM precompproductsrow " +
					"GROUP BY name " +
					"ORDER BY total DESC NULLS LAST LIMIT 10");
			// End timer
            endTime = System.currentTimeMillis();
            ////System.out.println("Time for running rset_Join query: " + (endTime-startTime) + "ms");
 	        	   
			Statement stmt_JoinRows = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

			startTime = System.currentTimeMillis();
			rset_JoinRows = stmt_JoinRows.executeQuery(
					"SELECT sum(total) as total, name as state " +
					"FROM precompstacuscol " +
				    "GROUP BY name " +
				    "ORDER BY total DESC NULLS LAST, state LIMIT 20");
            endTime = System.currentTimeMillis();
            ////System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
			
            startTime = System.currentTimeMillis();
            Statement stmt_Table = conn.createStatement();
			rset_Table = stmt_Table.executeQuery(
					"SELECT foo.nam AS state_id, name, total " +
		                    "FROM " +
		                    "(SELECT * " +
		                    "FROM precompcells " +
		                    "ORDER BY total DESC) AS foo " +
		                    "INNER JOIN " +
		                    "(SELECT SUM(CASE WHEN nam = nam THEN total END), nam " +
		                    "FROM precompcells " +
		                    "GROUP BY nam) AS f1 ON foo.nam = f1.nam " +
		                    "ORDER BY sum DESC NULLS LAST, foo.nam, total DESC");
			endTime = System.currentTimeMillis();
            ////System.out.println("Time for running rset_Table query: " + (endTime-startTime) + "ms");
		}
		else if(request.getParameter("big_filter").equals("customers"))
		{
			String SUM1 = " ", SUM2 = " ";
			if(!request.getParameter("states").equals("all"))
			{
				WHERE_ROWS +=  "WHERE state = '" + request.getParameter("states")+"'";
				SUM1 += WHERE_ROWS;
				
				if(request.getParameter("product_cat").equals("all"))
				    SUM2 += "SUM(CASE WHEN state = '"+request.getParameter("states")+"' THEN total END)";
			}
			else
			{
				if(request.getParameter("product_cat").equals("all"))
			        SUM2 += "SUM(total)";
			}
			if(!request.getParameter("product_cat").equals("all"))
			{
				SUM2 += "SUM(CASE WHEN cid = '"+request.getParameter("product_cat")+"' THEN total END)";
				if(request.getParameter("states").equals("all")) 
				{
					WHERE_ROWS += "WHERE cid = " + request.getParameter("product_cat");
				}
				else 
				{
					WHERE_ROWS += " AND cid = " + request.getParameter("product_cat");
		            //SUM2 += "SUM(CASE WHEN cid = '"+request.getParameter("product_cat")+"' THEN total END)";

				}
			}
			
     	  
			Statement stmt_Join = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
System.out.println(" WhereRows: " + WHERE_ROWS);
			startTime = System.currentTimeMillis();
			rset_Join = stmt_Join.executeQuery(
					"SELECT SUM(total) as total, name " +
					"FROM precompproductsrow " + 
					WHERE_ROWS + 
				    "GROUP BY name " +
				    "ORDER BY total DESC NULLS LAST, name LIMIT 10");
			endTime = System.currentTimeMillis();
            ////System.out.println("Time for running rset_Join query: " + (endTime-startTime) + "ms");
      	   
			Statement stmt_JoinRows = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

	        startTime = System.currentTimeMillis();
System.out.println("here");
System.out.println("SUM2: " + SUM2);
			rset_JoinRows = stmt_JoinRows.executeQuery(
					"SELECT "+ SUM2 +" AS total, name AS state " +
					"FROM precompstacuscol " +
					SUM1 +
					"GROUP BY name " +
					"ORDER BY total DESC NULLS LAST, state LIMIT 20");
System.out.println("now here");
			endTime = System.currentTimeMillis();
            ////System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
            
            startTime = System.currentTimeMillis();
			Statement stmt_Table = conn.createStatement();
			rset_Table = stmt_Table.executeQuery(
					"SELECT foo.nam AS state_id, name, total " +
		            "FROM " +
		                "(SELECT * " +
		                  "FROM precompcells " +
		                  "ORDER BY total DESC) AS foo " +
		            "INNER JOIN " +
		                "(SELECT SUM(CASE WHEN nam = nam THEN total END), nam " +
		                  "FROM precompcells " +
		                  "GROUP BY nam) AS f1 " +
		            "ON foo.nam = f1.nam " +
		            "ORDER BY sum DESC NULLS LAST, foo.nam, total DESC");
			endTime = System.currentTimeMillis();
            ////System.out.println("Time for running rset_Table query: " + (endTime-startTime) + "ms");
     		   
     		   
		}
		else if(request.getParameter("big_filter").equals("states"))
		{
			String cid = " ";
			if(!request.getParameter("states").equals("all"))
			{
				WHERE_ROWS +=  "WHERE state = '" + request.getParameter("states")+"'";
			}
			if(!request.getParameter("product_cat").equals("all"))
			{
				cid += "WHERE cid = " + request.getParameter("product_cat");
				if(request.getParameter("states").equals("all")) {
                    WHERE_ROWS += "WHERE cid = " + request.getParameter("product_cat");
                }
                else 
                {
                    WHERE_ROWS += "AND cid = " + request.getParameter("product_cat");
                }
			}
			
			Statement stmt_Join = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
	        System.out.println(" states where " + WHERE_ROWS);
			startTime = System.currentTimeMillis();
			rset_Join = stmt_Join.executeQuery(
                    "SELECT SUM(total) as total, name " +
                    "FROM precompproductsrow " + 
                    WHERE_ROWS + 
                    "GROUP BY name " +
                    "ORDER BY total DESC NULLS LAST, name LIMIT 10");
			if(!rset_Join.isBeforeFirst())
			{
				System.out.println("Yo");
				rset_Join = stmt_Join.executeQuery(
						"SELECT 0 as total, name "+
						"FROM products "+
						cid +
						"LIMIT 10 ");
			}
			endTime = System.currentTimeMillis();
            ////System.out.println("Time for running rset_Join query: " + (endTime-startTime) + "ms");
 	        	   
			Statement stmt_JoinRows = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
			if(request.getParameter("states").equals("all"))
			{
				startTime = System.currentTimeMillis();
				rset_JoinRows = stmt_JoinRows.executeQuery(
						"SELECT total, state_id AS state "+
								"FROM( "+
								"SELECT SUM(total) as total, state "+
								"FROM precompstacuscol "+
								 WHERE_ROWS + 
								"GROUP BY state LIMIT 20) AS foo "+
								"FULL OUTER JOIN states "+
								"ON states.state_id = foo.state "+
								"ORDER BY total DESC NULLS LAST, state_id LIMIT 20");
						
				endTime = System.currentTimeMillis();
	            ////System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
			}
			else
			{
                startTime = System.currentTimeMillis();
				rset_JoinRows = stmt_JoinRows.executeQuery(
	                    "SELECT SUM(total) as total, state " +
	                    "FROM precompstacuscol " + 
	                    WHERE_ROWS + 
	                    "GROUP BY state " +
	                    "ORDER BY total DESC NULLS LAST, state LIMIT 20");
				endTime = System.currentTimeMillis();
                //System.out.println("Time for running rset_JoinRows query: " + (endTime-startTime) + "ms");
			}
			Statement stmt_Table = conn.createStatement();
			startTime = System.currentTimeMillis();
			rset_Table = stmt_Table.executeQuery(
					"SELECT foo.state AS state_id, name, total "+
					"FROM "+
					"(SELECT * "+
					"FROM precompcells "+
					"ORDER BY total DESC) AS foo "+
					"INNER JOIN "+
					"(SELECT SUM(CASE WHEN state = state THEN total END), state "+
					"FROM precompcells "+
					"GROUP BY state) AS f1 ON foo.state = f1.state "+
					"ORDER BY sum DESC NULLS LAST, foo.state, total DESC");
			endTime = System.currentTimeMillis();
            //System.out.println("Time for running rset_Table query: " + (endTime-startTime) + "ms");
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
						</select>  <select name="age" style="display: none">
							<option value="all" selected="selected">All Ages</option>
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
								System.out.println(rset_Join.getString("name"));
								ar.add(rset_Join.getString("name"));
								String truncate = rset_Join.getString("name");
								if(truncate.length() > 10)
									truncate = truncate.substring(0,10) + "...";%>
							<td class="bold"><%=truncate + " ($" + rset_Join.getInt("total") + ")" %></td>
						  <%} %>
						</tr>
						<%
						rset_Table.next();	
						System.out.println(" " +rset_JoinRows.isBeforeFirst());
					    if ((rset_JoinRows.isBeforeFirst()) && !request.getParameter("states").equals("all"))
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
		                    { System.out.println("Join rows " +rset_JoinRows.getString("state"));
							%>
						<tr><%
								if(!rset_Table.isAfterLast())
								while(rset_Table.getString("state_id").equals(rset_JoinRows.getString("state")) == false )
								{
									System.out.println("XXXXXXX" +rset_Table.getString("state_id")+" ok " +rset_JoinRows.getString("state"));
									rset_Table.next();
									if(rset_Table.isAfterLast())
										break;
								}
						System.out.println(" ahahah " + rset_JoinRows.getString("state"));
							%>
							<td class="bold"><%=rset_JoinRows.getString("state") + " ($" + rset_JoinRows.getInt("total") + ")" %></td>
							<%
								if(rset_Table.isAfterLast())
								{
									for(int i=0; i< ar.size(); i++)
									{
										%>
										<td>$0</td>
										<% 
									}
								}
								else
								for(int i=0; i< ar.size();)
								{
									int in = ar.indexOf(rset_Table.getString("name"));
									System.out.println("haha "+in + " " +rset_Table.getString("name"));
									if(in == -1)
									{
										System.out.println("Index -1 " + i);
										rset_Table.next();
										if(rset_Table.isAfterLast())
										{
											for(int j = i; j < ar.size(); j++, i++)
											{
												%>
												<td>$0</td>
												<% 
											}
											break;
										}
										if(!rset_Table.getString("state_id").equals(rset_JoinRows.getString("state")) || i == 9)
										{
											for(int j = i; j < ar.size(); j++, i++)
											{
												%>
												<td>$0</td>
												<% 
											}
										}
									}
									else
									{
										System.out.println(" value of i before "+i);
										for(int j = i; j < in; j++, i++)
										{
											%>
											<td>$0</td>
											<% 
										}
										%>
										<td><%=" $" +rset_Table.getString("total") %></td>
										<%	
										i++;
										System.out.println(" value of i "+i);
										rset_Table.next();
										if(rset_Table.isAfterLast())
										{
											for(int j = i; j < ar.size(); j++, i++)
											{
												%>
												<td>$0</td>
												<% 
											}
											break;
										}
										if(!rset_Table.getString("state_id").equals(rset_JoinRows.getString("state")) || i == 9)
										{
											for(int j = i ; j < ar.size(); j++, i++)
											{
												%>
												<td>$0</td>
												<% 
											}
												
										}
									}
								}
%>
									
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
						method="GET" style="display: none">
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
					<form id="next20" action="salesanalyticsnext.jsp" method="GET" style="display: none">
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
	long end=System.currentTimeMillis();
	out.println(" TOTAL TIME " + (end-start));
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
