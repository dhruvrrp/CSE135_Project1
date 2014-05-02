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
    
    
    
    <!-- *****************************************JSP*************************************************** -->
    
   <%@ page language="java" import="java.sql.*" import="java.util.*"%> 
    
    <!-- Connect to database -->
    <%
    boolean noUser = false; //boolean check to see if there is no user logged in
    try
    {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(
                          "jdbc:postgresql://localhost:5432/CSE135", 
                          "postgres", "calcium");
        
        if(session.getAttribute("session_username") == null) {
            noUser = true;
            throw new SQLException();
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
                    <li><span id="welcome">Hello, <%= session.getAttribute("session_username") %></span></li>
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
  
        <div class="row" id="shift">
            <div class="row">
                <div class="panel">  

        <!------ SELECT CODE ------>
    <%
        // Use the created Statement to SELECT the Shopping_Cart attributes
        //   from the Shopping_Cart table    
        Statement stmt_shopcart = conn.createStatement();
        ResultSet rs_shopcart = stmt_shopcart.executeQuery("SELECT * " +
                                                           "FROM Shopping_Cart " + 
                                                           "WHERE customer_name = " + 
                                                           session.getAttribute("session_userid"));
        
        // Alternative message for an empty cart
        if (!(rs_shopcart.isBeforeFirst()))
        {
    %>      <h3 align=center>
                Looks like your cart is empty! 
                Let's <a href="ProductBrowsing.jsp">browse</a> for some products.
            </h3>
    <%      return;
        }
        
        
        // Get total price of User's Shopping_Cart
        Statement stmt_total = conn.createStatement();
        ResultSet rs_total = stmt_total.executeQuery("SELECT SUM(Products.price * Shopping_Cart.quantity) AS total " +
                                                     "FROM Products, Shopping_Cart " +
                                                     "WHERE customer_name = " + 
                                                     session.getAttribute("session_userid") +
                                                     " AND Products.product_id = Shopping_Cart.product_sku");
        rs_total.next();
    %>
        

        <!------ ITERATION CODE ------>

        <h3>Your shopping cart</h3>
        <table border="1">
        <tr>
            <th>Product</th>
            <th>Price per unit</th>
            <th>Quantity</th>
            <th>Subtotal</th>
        </tr>
    <%
        ResultSet rs_allprod = null;
        Statement stmt_allprod = null;
        while(rs_shopcart.next())
        {
            // Get Product's name to be displayed instead of product_sku
            stmt_allprod = conn.createStatement();
            rs_allprod = stmt_allprod.executeQuery("SELECT * FROM Products " + 
                                                   "WHERE Products.product_id = " + 
                                                   rs_shopcart.getInt("product_sku"));
            rs_allprod.next();
            
            // Print two decimal places
            java.util.Formatter formatted_price = new java.util.Formatter();
            formatted_price.format("%.2f", rs_allprod.getFloat("price"));
            
            java.util.Formatter formatted_subtotal = new java.util.Formatter();
            formatted_subtotal.format("%.2f", rs_allprod.getFloat("price") * rs_shopcart.getInt("quantity"));
            
            // Display contents of User's Shopping_Cart
    %>      <tr>
                <td align=center><%=rs_allprod.getString("name") %></td>
                <td align=center><%=formatted_price %></td>
                <td align=center><%=rs_shopcart.getInt("quantity") %></td>
                <td align=center><%=formatted_subtotal %></td>
            </tr>
    <%
        }
    %>
        </table>
        
        <!------ Order total ------>
    <%
        // Print two decimal places    
        java.util.Formatter formatted_total = new java.util.Formatter();
        formatted_total.format("%.2f", rs_total.getFloat("total"));
    %>
        <h4>Order total</h4>
        <table border="1">
            <td><%=formatted_total %></td>
        </table>
        <br>
        
    <%  // Add more items if desired %>    
        <form method="post" action="ProductBrowsing.jsp">
            <input type="submit" value="Add more items" class="button small">
        </form>
        
        <!-- Purchase order -->
        <br><br><br><br>
        <h3>Want to place your order?</h3>
            <form method="post" action="BuyShoppingCartConfirmation.jsp">
                Name on card: 
                    <input type="text" name="card_name" placeholder="John Smith" />
                Credit card number: 
                    <input type="text" name="card_num" placeholder="0000 0000 0000 0000" size="10" />
                Expiration date: <br>
                    <input name="card_mon" size="2" maxlength="2" placeholder="mm"/>
                    <input name="card_yr" size="2" maxlength="4" placeholder="yyyy" />
                    <br>
                    <br>
                    <br>
                <input type="submit" value="Purchase!" class="button">
            </form>

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
  
        <!------ Close the connection code ------>
    <%      
        // Close the ResultSet
        rs_shopcart.close();
        rs_allprod.close();
        rs_total.close();
            
        // Close the Statements
        stmt_shopcart.close();
        stmt_allprod.close();
        stmt_total.close();
    
        // Close the connection
        conn.close();
    }
    catch (SQLException e)
    {
        if(noUser) {
            out.println("You must be logged in to view this page!");
        }
        else {
            out.println(e.getMessage());
            e.printStackTrace();
        }
    }
    catch (Exception e)
    {
        out.println(e.getMessage());
    }
    finally {}
        
    %>
  
  
   <!-- *********************************************************************************************** -->
  
  
  
  <script src="../assets/js/jquery.js"></script>
    <script src="../assets/js/templates/foundation.js"></script>
    <script>
      $(document).foundation();

      var doc = document.documentElement;
      doc.setAttribute('data-useragent', navigator.userAgent);
    </script>
    
</body>
</html>
  