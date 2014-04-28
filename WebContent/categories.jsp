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
  
  <div class="row" id="shift">
    <div class="row">
      <div class="panel">
      
        <h3>Add a new category</h3><p>
        <form action="categories.jsp" method="post">
        <input type="hidden" value="insert" name="action">
            Category name: 
                <input type="text" name="param_catname" autofocus="autofocus"/>
            Description: 
                <input type="text" name="param_desc"/>
        <input type="submit" value="Submit" class="button">
        </form>
        
        <br>
        <br>
        
        <h3>Edit existing categories</h3>
        
        
    
    
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
            <!------ INSERT CODE ------>
        <%
            // Check if an insertion is requested
            String action = request.getParameter("action");
            if (action != null && action.equals("insert"))
            {
                // Begin transaction
                conn.setAutoCommit(false);
                
                // Create the PreparedStatement and use it to INSERT
                //   the Category attribuets INTO the Categories table
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Categories (name, description) " +
                                          "VALUES (?, ?)");
                
                pstmt.setString(1, request.getParameter("param_catname"));
                pstmt.setString(2, request.getParameter("param_desc"));
                int rowCount = pstmt.executeUpdate();
                
                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
            }
            
        %>
        
            <!------ UPDATE CODE ------>
        <%
            // Check if an updated is requested
            if (action != null && action.equals("update"))
            {
                // Begin transaction
                conn.setAutoCommit(false);
                
                // Create the PreparedStatement and use it to UPDATE
                //   Category values in the Categories table
                PreparedStatement pstmt = conn.prepareStatement("UPDATE Categories " +
                                                                "SET name = ?, description = ? " +
                                                                "WHERE category_id = ?");
                
                pstmt.setString(1, request.getParameter("param_catname"));
                pstmt.setString(2, request.getParameter("param_desc"));
                pstmt.setInt   (3, Integer.parseInt(request.getParameter("param_id")));
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
            ResultSet rs = statement.executeQuery("SELECT * FROM Categories");
            
        %>
        
        <!------ ITERATION CODE ------>
        <table border="1">
        <tr>
            <th>ID</th>
            <th>Category</th>
            <th>Description</th>
        </tr>
    <%
        while(rs.next())
        {
    %>      <tr>
            <form action="categories.jsp" method="post">
            <input type="hidden" value="update" name="action"/>
                <td>
                    <input type="hidden" value="<%=rs.getInt("category_id")%>" name="param_id" size="15" />
                    <%=rs.getInt("category_id") %>
                </td>
                <td><input value="<%=rs.getString("name")%>" name="param_catname" size="15" /></td>
                <td><input value="<%=rs.getString("description")%>" name="param_desc" size="15" /></td>
            <!-- Update button -->
            <td><input type="submit" value="Update" class="button" ></td>
            </form>
            
            <form action="categories.jsp" method="post">
                <input type="hidden" value="delete" name="action"/>
                <input type="hidden" value="<%=rs.getInt("category_id")%>" name="param_id"/>
            <!-- Delete button -->    
            <td><input type="submit" value="Delete" class="button"/></td>
            </form>
            </tr>
    <%
        }
    %>
        </table>
    
            <!------ Close the connection code ------>
    <%      
            // Close the ResultSet
            rs.close();
    
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
