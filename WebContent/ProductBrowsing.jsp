<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Product Browsing</title>
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
 
  <!-- End Header -->
 <!-- *****************************************JSP*************************************************** -->
 	
 	<!-- Set language to java, and import sqql package -->
 	<%@ page language="java" import="java.sql.*" %>
 	    
 	    <!-- Connect to DataBase -->
 		<% try {
            Class.forName("org.postgresql.Driver");
 			Connection conn = DriverManager.getConnection(
 							  "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
 			
 			Statement stmt_cat = conn.createStatement();
 			
 			//get all tuples from the categories table
 			ResultSet rset_cat = stmt_cat.executeQuery("SELECT * FROM categories");
 			
 			
 		%>
 			<div id="prod_search">
  				<p><b>Filter</b></p>
  				<ul>
  					<li><a href="ProductBrowsing.jsp?BUTTONN=">All Products</a></li>
  					<% while(rset_cat.next()) { %>
  						<li><a href="ProductBrowsing.jsp?BUTTONN=<%=rset_cat.getInt("category_id")%>"><%= rset_cat.getString("name") %></a></li>
  					<% } %>
  				</ul>
  			</div>
 			
 			
 			
 		
 			<div class="row" id="shift">
      			<div class="row">
          			<div class="panel">     
          				<br>
          				
          					<%
          					String link ="";
          					if(request.getParameter("BUTTONN") != null)
          						link = "ProductBrowsing.jsp?BUTTONN="+request.getParameter("BUTTONN");
          					%>

          					<form action="<%=link%>" method="POST">
          					Search for Products: <input type="search" name="prod_search">
          					<input type="submit" value="Search" class="button">
          					</form>



						<%
							System.out.println("CAT "+request.getParameter("BUTTONN") + "X");
						
							Statement stmt_sea = conn.createStatement();
							String q="";
							String a = request.getParameter("prod_search");
							//System.out.println("WTFFF " + a.length());
							if(a == null)
							{
								System.out.println("WTFFF");
								q = "SELECT * FROM products WHERE name ILIKE '%%'";
							}
							else
							{
								q = "SELECT * FROM products WHERE name ILIKE '%"+ a+"%'";
							}
							boolean check = true;
							System.out.println("AAA "+ a);
							System.out.println("QQ  " +q);
							if((String)request.getParameter("BUTTONN") != null && !request.getParameter("BUTTONN").equals(""))
							{
								q = q + " AND category = '"+request.getParameter("BUTTONN") +"'";
								System.out.println("I'm here");
							}
							System.out.println(q);
							ResultSet rset_sea = stmt_sea.executeQuery(q);
								%>
								<table border="1">
         							<tr>
         								<th>Product SKU</th>
         								<th>Name</th>
         								<th>Category</th>
         								<th>Price</th>
         							</tr>
         							
         						<% 	
         						while(rset_sea.next()&&check)
								{
         							Statement stmt_catname = conn.createStatement();
         							ResultSet rset_catname = stmt_catname.executeQuery("SELECT Categories.name FROM Categories, Products " + 
         								                                               "WHERE Categories.category_id = '" + 
         								                                               rset_sea.getString("category") + "'");
         							rset_catname.next();
								%>
									<form action="ProductOrder.jsp" method="GET">
									<tr>
         								<td align="center"><%= rset_sea.getString("sku") %></td>
         								<td align="center"><input type="submit" class="button small" name="prod_pur" value ="<%=rset_sea.getString("name")%>"></td>
         								<td align="center"><%= rset_catname.getString("name") %></td>
         								<td align="center"><%= rset_sea.getInt("price") %></td>
         							</tr>
							<%}%>
							</form>
								</table>
							
          			</div>
    			</div>
  			</div>
 		
 		
 		<% 
 			//close connections to db
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
