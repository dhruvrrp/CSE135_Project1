<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<% String ERROR_DUPLICATE_CATNAME = "23505";
   String ERROR_MISSING_CATNAME   = "23514";%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title>Categories</title>
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
    
    <%@ page language="java" import="java.sql.*" %>
    
    <!-- Connect to database -->
  <%
     boolean noUser = false;  //boolean flag to see if there is no user logged in
     try
     {
         Class.forName("org.postgresql.Driver");
         Connection conn = DriverManager.getConnection(
                           "jdbc:postgresql://localhost:5432/CSE135", 
                           "postgres", "calcium");
            
         // Check if there is no user who is logged in (shouldn't be on this page)
         if(session.getAttribute("session_username") == null) 
         {
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
        <div class="row" id="shift">
            <div class="row">
                <div class="panel">
     



         <!------ INSERT CODE ------>
     <%
         try
         {
             // Check if an insertion is requested
             String action = request.getParameter("action");
             if (action != null && action.equals("insert"))
             {
                 // Begin transaction
                 conn.setAutoCommit(false);
                
                 // Create the PreparedStatement and use it to INSERT
                 //   the Category attribuets INTO the Categories table
                 PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Categories " + 
                                                                 "(name, description) " +
                                                                 "VALUES (?, ?)");
                
                 pstmt.setString(1, request.getParameter("cat_name"));
                 pstmt.setString(2, request.getParameter("cat_desc"));
                 int rowCount = pstmt.executeUpdate();
                
                 // Commit transaction
                 conn.commit();
                 conn.setAutoCommit(true);
                    
                 if (request.getParameter("cat_name") != "")
                 {
                     out.println("The category \"" + 
                                 request.getParameter("cat_name") + 
                                 "\" has been added!");
                     %><br><%
                  }
             }
         }
         catch (SQLException e)
         {
             if (e.getSQLState().equals(ERROR_DUPLICATE_CATNAME))
             {
                 out.println("ERROR ADDING NEW CATEGORY: Category name \"" + 
                             request.getParameter("cat_name") + 
                             "\" already exists! Please choose a different name.");
                 %><br><%
             }
            
             if (e.getSQLState().equals(ERROR_MISSING_CATNAME))
             {
                 out.println("ERROR ADDING NEW CATEGORY: " + 
                             "The category name cannot be empty.");
                 %><br><%
             }
                
             /* return; */
            
         }
         finally
         {
        	 conn.setAutoCommit(true);
         }
        %>
        
         <!------ UPDATE CODE ------>
        <%
         try
         {
             // Check if an update is requested
             String action = request.getParameter("action");
             if (action != null && action.equals("update"))
             {
                 // Begin transaction
                 conn.setAutoCommit(false);
                
                 // Create the PreparedStatement and use it to UPDATE
                 //   Category values in the Categories table
                 PreparedStatement pstmt = conn.prepareStatement("UPDATE Categories " +
                                                                 "SET name = ?, description = ? " +
                                                                 "WHERE category_id = ?");
                
                 pstmt.setString(1, request.getParameter("cat_name"));
                 pstmt.setString(2, request.getParameter("cat_desc"));
                 pstmt.setInt   (3, Integer.parseInt(request.getParameter("cat_id")));
                 int rowCount = pstmt.executeUpdate();
                
                 // Commit transaction
                 conn.commit();
                 conn.setAutoCommit(true);
                    
                 out.println("The category \"" + 
                             request.getParameter("cat_name") + 
                             "\" has been updated!");
                 %><br><%
             }
         }
         catch (SQLException e)
         {
             if (e.getSQLState().equals(ERROR_DUPLICATE_CATNAME))
             {
                 out.println("ERROR UPDATING EXISTING CATEGORY: Category name \"" + 
                             request.getParameter("cat_name") + 
                             "\" already exists! Please choose a different name.");
                 %><br><%
             }
            
             if (e.getSQLState().equals(ERROR_MISSING_CATNAME))
             {
                 out.println("ERROR UPDATING EXISTING CATEGORY: " + 
                             "The category name cannot be empty.");
                 %><br><%
             }
            
             /* return; */
         }
        finally
        {
            conn.setAutoCommit(true);
        }
            
        %>
        
         <!------ DELETE CODE ------>
        <%
         // Check if a delete is requested
         String action = request.getParameter("action");
         if (action != null && action.equals("delete"))
         {   
             // Fill ResultSet with Products of the Category that is to be deleted  
             Statement stmt_nodelete2 = conn.createStatement();
             ResultSet rs_nodelete2 = stmt_nodelete2.executeQuery("SELECT * FROM Products " + 
                                                                  "WHERE Products.category = " + 
                                                                  request.getParameter("cat_id"));
                
             // Check if there are Products attached to the Category, else DELETE as normal
             if ((rs_nodelete2.next()))
             {
                 out.println("ERROR DELETING CATEGORY: " + 
                             "A product has been added to the category \"" + 
                             request.getParameter("cat_name") + "\" and thus can no longer be deleted.");
                 %><br><%
             }
             else
             {
                 // Begin transaction
                 conn.setAutoCommit(false);
                	
                 // Create the PreparedStatement and use it to
                 //   DELETE Categories FROM the Categories table
                 PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Categories " +
                                                                 "WHERE category_id = ? ");
                 pstmt.setInt(1, Integer.parseInt(request.getParameter("cat_id")));
                 int rowCount = pstmt.executeUpdate();
                
                 // Commit transaction
                 conn.commit();
                 conn.setAutoCommit(true);
                    
                 // Close stuff
                 stmt_nodelete2.close();
                 rs_nodelete2.close();
                    
                 out.println("The category \"" +
                             request.getParameter("cat_name") + 
                             "\" has been deleted!");
             } 
         }
        %>
         <br>
         <!------ SELECT CODE ------>
        <%
         // Create the Statement
         Statement stmt_allcats = conn.createStatement();
            
         // Use the created Statement to SELECT the Category attributes
         //   from the Categories table
         ResultSet rs_allcats = stmt_allcats.executeQuery("SELECT * " +
                                                          "FROM Categories " + 
                                                          "ORDER BY category_id");
        %>
        
         
         
        <!------ Insert text forms ------>
        <h2>Add categories</h2><hr>
        <table border="1">
            <tr>
                <th>Name</th>
                <th>Description</th>
            </tr>
            <tr>
                <form action="categories.jsp" method="post">
                <input type="hidden" name="action" value="insert">
                    <th><input name="cat_name" autofocus="autofocus"></th>
                    <th><input name="cat_desc"></th>
                    <th><input type="submit" value="Insert" class="button"></th>
                </form>
            </tr>
        </table>
         
         
        <!------ ITERATION CODE ------>
        <br><br><br><br>
        
        <h2>Modify existing categories</h2>
        <table border="1">
        <tr>
            <th>ID</th>
            <th>Category</th>
            <th>Description</th>
        </tr>
       <%
        ResultSet rs_nodelete = null;
        Statement stmt_nodelete = null;
        while(rs_allcats.next())
        {
            // Get ResultSet containing Products attached to the current Category
            stmt_nodelete = conn.createStatement();
            rs_nodelete = stmt_nodelete.executeQuery("SELECT * FROM Products " + 
                                                     "WHERE Products.category = " + 
                                                     rs_allcats.getInt("category_id"));
       %>   <tr>
                <form action="categories.jsp" method="post">
                <input type="hidden" value="update" name="action"/>
                    <td><input type="hidden" value="<%=rs_allcats.getInt("category_id")%>" name="cat_id" />
                        <%=rs_allcats.getInt("category_id") %></td>
                    <td><input value="<%=rs_allcats.getString("name")%>" name="cat_name" /></td>
                    <td><input value="<%=rs_allcats.getString("description")%>" name="cat_desc"/></td>
                    <td><input type="submit" value="Update" class="button" ></td>
                </form>
           
                <form action="categories.jsp" method="post">
                    <input type="hidden" value="delete" name="action"/>
                    <input type="hidden" value="<%=rs_allcats.getInt("category_id")%>" name="cat_id"/>
                    <input type="hidden" value="<%=rs_allcats.getString("name")%>" name="cat_name"/>
        <%
                    // Only display Delete button if there are no Products
                    //   attached to the current Category
                   if (!(rs_nodelete.next())) 
                   {  %>   
                       <td><input type="submit" value="Delete" class="button"/></td> 
       <%          } 
        %>
                </form>
            </tr>
        <%
        }
        %>
        </table>
      
      
      
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
            rs_allcats.close();
            rs_nodelete.close();
            
            // Close the Statements
            stmt_allcats.close();
            stmt_nodelete.close();
    
            // Close the connection
            conn.close();
        }
        catch (SQLException e)
        {
        	if(noUser) {
        		out.println("You must be logged in to view this page!");
        	}
        	else{
            	out.println(e.getMessage());
            	e.printStackTrace();
        	}
        }
        catch (Exception e)
        {
            out.println(e.getMessage());
        }
        
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