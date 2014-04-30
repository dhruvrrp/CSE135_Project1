<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Product Order</title>
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
 			
 			Statement stmt_prodo = conn.createStatement();
 			
 			
 		%>
 			<div class="row" id="shift">
      			<div class="row">
          			<div class="panel">     
          				<span id="welcome">Hello <%= session.getAttribute("session_username") %> </span>
          				<br>
          				

						<%
							String new_item = (String)request.getParameter("prod_pur");
							//int user_id = (int)session.getAttribute("session_userid");
							
							//REMOVE THIS LINE LATER> TESTING ONLY
							
							int user_id = 1;
							
							//REMOVE IT
							
							int quantity = 0;
							%>
							<form action="ProductOrder.jsp" method="POST">
							<table border="1">
         							<tr>
         								<th>Product Name</th>
         								<th>Quantity</th>
         							</tr>
         							<tr>
         								<td><%=new_item %></td>
         								<td><input type="text" name="quant"></td>
         							</tr>
         					<input type="hidden" name="action1" value=<%=new_item %>>
         					</table>
         					<input type="submit" value="Insert">
         					</form>
							<%
							if(request.getParameter("quant") != null)
							{
								String quan = request.getParameter("quant");
								quantity = Integer.parseInt(quan);
								new_item = request.getParameter("action1");
								System.out.println(quantity + " New item "+ new_item);
								if(quantity <= 0)
								{
									out.println("Quantity needs to be more than 0!!!");
								}
								else
								{
									Statement stmt_allprod = conn.createStatement();
         							ResultSet rset_allprod = stmt_allprod.executeQuery("SELECT * FROM products WHERE name = '"+new_item+"'");
								    rset_allprod.next();
								    
									conn.setAutoCommit(false);
					                
				                    // Create the PreparedStatement and use it to INSERT
				                    //   the Category attribuets INTO the Categories table
				                    PreparedStatement pstmt_quan = conn.prepareStatement("INSERT INTO shopping_cart " + 
				                    		                                        "(customer_name, product_sku, product_price, quantity) " +
				                    	                                            "VALUES (?, ?, ?, ?)");
				                
				                    pstmt_quan.setInt(1, user_id);
				                    pstmt_quan.setInt(2, rset_allprod.getInt("product_id"));
				                    pstmt_quan.setFloat(3, rset_allprod.getFloat("price"));
				                    pstmt_quan.setInt(4, quantity);
				                    int rowCount = pstmt_quan.executeUpdate();
				                
				                    // Commit transaction
				                    conn.commit();
				                    conn.setAutoCommit(true);
				                    response.sendRedirect("ProductBrowsing.jsp");
								}
							}
							ResultSet rset_prodo = stmt_prodo.executeQuery("SELECT * FROM shopping_cart WHERE customer_name = "+user_id);
%>							<table border="1">
         							<tr>
         								<th>Product Name</th>
         								<th>Individual Price</th>
         								<th>Quantity</th>
         								<th>Total Price</th>
         							</tr>
         							<%
							while(rset_prodo.next())
							{
							
								Statement stmt_prodn = conn.createStatement();
								ResultSet rset_prodn = stmt_prodn.executeQuery("SELECT * FROM products WHERE product_id = "+rset_prodo.getInt("product_sku"));
								rset_prodn.next();
							%>
								<tr>
     								<td><%= rset_prodn.getString("name") %></td>
     								<td><%=rset_prodn.getInt("price")%></td>
     								<td><%= rset_prodo.getInt("quantity") %></td>
     								<td><%= rset_prodn.getInt("price") * rset_prodo.getInt("quantity") %></td>
     							</tr>
     						
						<%}%>
						</table>
						
							
          			</div>
    			</div>
  			</div>
 		
 		
 		<% 
 			//close connections to db
 		//	rset_cat.close();
 			//stmt_cat.close();
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
