<!-- ************* FOR GETTING THE STORED USERNAME, JUST SAVING FOR FUTURE REF ***********
<body>
Hello, <%= session.getAttribute("session_username") %>!
</body> 
     *********************************************************-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
    
    <%@ page language="java" import="java.sql.*" %>
    
    <!-- Connect to database -->
    <%
        try
        {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(
            		          "jdbc:postgresql://localhost:5432/CSE135", "postgres", "calcium");
            
    %>
            <!-- Insert text forms -->
            <div class="row" id="shift">
                <div class="row">
                    <div class="panel">
                        <span id="welcome">Hello <%= session.getAttribute("session_username") %> </span>
                        <br>
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
     
            <!------ INSERT CODE ------>
        <%
            // Check if an insertion is requested
            String action = request.getParameter("action");
            if (action != null && action.equals("insert"))
            {
            	String strCatName = request.getParameter("cat_name");
                
            	Statement statement = conn.createStatement();
                ResultSet rs_dupcat = statement.executeQuery("SELECT * FROM Categories " + 
                                                             "WHERE name = '" + request.getParameter("cat_name") + "'");
                
                // Check for empty text fields and throw error if true
                if (strCatName == "")
                {
                	    out.println("ERROR ADDING NEW CATEGORY: The category name cannot be empty.");
                }
                else if (rs_dupcat.next())
                {
                	out.println("ERROR ADDING NEW CATEGORY: Category name \"" + request.getParameter("cat_name") + 
                			    "\" already exists! Please choose a different name.");
                }
                else
                {
                    // Begin transaction
                    conn.setAutoCommit(false);
                
                    // Create the PreparedStatement and use it to INSERT
                    //   the Category attribuets INTO the Categories table
                    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Categories (name, description) " +
                    	                      "VALUES (?, ?)");
                
                    pstmt.setString(1, request.getParameter("cat_name"));
                    pstmt.setString(2, request.getParameter("cat_desc"));
                    int rowCount = pstmt.executeUpdate();
                
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                    if (request.getParameter("cat_name") != "")
                    {
                    	out.println("The category \"" + request.getParameter("cat_name") + "\" has been added!");
                    }
                }
            }
            
        %>
        
            <!------ UPDATE CODE ------>
        <%
            // Check if an updated is requested
            if (action != null && action.equals("update"))
            {
                String strCatName = request.getParameter("cat_name");
                
                Statement statement = conn.createStatement();
                ResultSet rs_dupcat = statement.executeQuery("SELECT * FROM Categories " + 
                                                             "WHERE name = '" + request.getParameter("cat_name") + "'");
                
                // Check for 1) empty text field and 2) duplicate category name
                //   Allows updating description of a given category w/o throwing "duplicate category" error
                if (strCatName == "")
                {
                        out.println("ERROR UPDATING EXISTING CATEGORY: The category name cannot be empty.");
                }
                else if (rs_dupcat.next() 
                		 && Integer.parseInt(request.getParameter("cat_id")) != rs_dupcat.getInt("category_id"))
                {
                    out.println("ERROR UPDATING EXISTING CATEGORY: Category name \"" + request.getParameter("cat_name") + 
                                "\" already exists! Please choose a different name.");
                }
                else
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
                }
            }
        %>
        
            <!------ DELETE CODE ------>
        <%
            // Check if a delete is requested
            if (action != null && action.equals("delete"))
            {
                // Begin transaction
                conn.setAutoCommit(false);
                
                Statement statement2 = conn.createStatement();

               
                // Create the PreparedStatement and use it to
                //   DELETE Categories FROM the Categories table
                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Categories " +
                		                                        "WHERE category_id = ? ");
                pstmt.setInt(1, Integer.parseInt(request.getParameter("cat_id")));
                int rowCount = pstmt.executeUpdate();
                
                
                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
            }
        %>
            
            <!------ SELECT CODE ------>
        <%
            // Create the Statement
            Statement statement = conn.createStatement();
            
            // Use the created Statement to SELECT the Category attributes
            //   from the Categories table
            ResultSet rs_allcats = statement.executeQuery("SELECT * FROM Categories ORDER BY category_id");
            

            
        %>
        
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
        Statement statement2 = null;
        while(rs_allcats.next())
        {
            // Get ResultSet containing Products attached to the current Category
        	statement2 = conn.createStatement();
        	rs_nodelete = statement2.executeQuery("SELECT * FROM Products " + 
                                                  "WHERE Products.category = " + rs_allcats.getInt("category_id"));
    %>      <tr>
            <form action="categories.jsp" method="post">
            <input type="hidden" value="update" name="action"/>
                <td>
                    <input type="hidden" value="<%=rs_allcats.getInt("category_id")%>" name="cat_id" />
                    <%=rs_allcats.getInt("category_id") %>
                </td>
                <td><input value="<%=rs_allcats.getString("name")%>" name="cat_name" /></td>
                <td><input value="<%=rs_allcats.getString("description")%>" name="cat_desc"/></td>
            <!-- Update button -->
            <td><input type="submit" value="Update" class="button" ></td>
            </form>
            
            <form action="categories.jsp" method="post">
                <input type="hidden" value="delete" name="action"/>
                <input type="hidden" value="<%=rs_allcats.getInt("category_id")%>" name="cat_id"/>
    <% 
            // Only display Delete button if there are no Products
            //   attached to the current Category
            if (!(rs_nodelete.next())) {  
    %>          <!-- Delete button -->    
                <td><input type="submit" value="Delete" class="button"/></td> 
    <%      } 
    %>
            </form>
            </tr>
    <%
        }
    %>
        </table>

    
            <!------ Close the connection code ------>
    <%      
            // Close the ResultSet
            rs_allcats.close();
            rs_nodelete.close();
            
            // Close the Statements
            statement.close();
            statement2.close();
    
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
  
  
  <!-- *********************************************************************************************** -->      
  
  
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
