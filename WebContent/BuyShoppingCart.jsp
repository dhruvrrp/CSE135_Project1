<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Shopping Cart</title>
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
  
  <div class="row" id="shift">
      <div class="row">
          <div class="panel">
              <span id="welcome">Hello <%= session.getAttribute("session_username") %>, <!-- TESTING SESSION_USERID, DELETE LATER --><%= session.getAttribute("session_userid")%> </span>
  
  
  
  <!-- *****************************************JSP*************************************************** -->
    
    <%@ page language="java" import="java.sql.*" %>
    
    <!-- Connect to database -->
    <%
        try
        {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(
                              "jdbc:postgresql://localhost:5432/CSE135", 
                              "postgres", "calcium");
    %>
        <!------ SELECT CODE ------>
        <%
            // Create the Statement
            Statement stmt_shopcart = conn.createStatement();
            
            // Use the created Statement to SELECT the Category attributes
            //   from the Categories table
            ResultSet rs_shopcart = stmt_shopcart.executeQuery("SELECT * " +
                                                               "FROM Shopping_Cart " + 
                                                               "WHERE customer_name = " + session.getAttribute("session_userid"));
        %>
        
        <!------ ITERATION CODE ------>

        <h2>Your shopping cart</h2>
        <table border="1">
        <tr>
            <th>Product</th>
            <th>Price per unit</th>
            <th>Quantity</th>
            <th>Subtotal</th>
        </tr>
    <%
        ResultSet rs_prodname = null;
        Statement stmt_prodname = null;
        while(rs_shopcart.next())
        {
            // Get ResultSet containing Products attached to the current Category
            stmt_prodname = conn.createStatement();
            rs_prodname = stmt_prodname.executeQuery("SELECT name FROM Products " + 
                                                     "WHERE Products.product_id = " + 
                                                     rs_shopcart.getInt("product_sku"));
            rs_prodname.next();
            
    %>      <tr>
            <form action="BuyShoppingCart.jsp" method="post">
            <!-- <input type="hidden" value="update" name="action"/> -->
                <td><%=rs_prodname.getString("name") %></td>
                <td><%=rs_shopcart.getFloat("product_price") %></td>
                <td><%=rs_shopcart.getInt("quantity") %></td>
                <td><%=rs_shopcart.getFloat("product_price") * rs_shopcart.getInt("quantity") %></td>
               <!--  <td><input type="submit" value="Update" class="button" ></td> -->
            </form>
            
<%--             <form action="categories.jsp" method="post">
                <input type="hidden" value="delete" name="action"/>
                <input type="hidden" value="<%=rs_allcats.getInt("category_id")%>" name="cat_id"/>
                <input type="hidden" value="<%=rs_allcats.getString("name")%>" name="cat_name"/>
            </form>
            </tr> --%>
    <%
        }
    %>
        </table>
  
              <!------ Close the connection code ------>
    <%      
            // Close the ResultSet
            rs_shopcart.close();
            rs_prodname.close();
            
            // Close the Statements
            stmt_shopcart.close();
            stmt_prodname.close();
    
            // Close the connection
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
        
    %>
  
  
  
          </div>
      </div>
  </div>
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
  