<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@include file="welcome.jsp" %>

<% ArrayList<String> sales = (ArrayList)request.getSession().getAttribute("saless");
  
  if(sales == null) {
	  System.out.println("what");
  }
  for(int i = 0; i < sales.size(); i++) {
	  System.out.println(sales.get(i));
  }
   
%>
 


<%
if(session.getAttribute("name")!=null)
{

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>

<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Produts</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td align="left"><font size="+3">
	<%
	String uName=(String)session.getAttribute("name");
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String card=null;
	int card_num=0;
	try {card=request.getParameter("card"); }catch(Exception e){card=null;}
	try
	{
		 
		 card_num    = Integer.parseInt(card);
		 if(card_num>0)
		 {
	
				Connection conn=null;
				Statement stmt=null;
				try
				{
					
					//String SQL_copy="INSERT INTO sales (uid, pid, quantity, price) select c.uid, c.pid, c.quantity, c.price from carts c where c.uid="+userID+";";
					
					String userState = "SELECT state FROM users WHERE users.id=" + userID; 
					
					String  SQL="delete from carts where uid="+userID+";";
					
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					String url="jdbc:postgresql://localhost:5432/CSE135";
					String user="postgres";
					String password="calcium";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
				
					try{
						String state = null;
						
						Statement state_stmt = conn.createStatement();
						
						//get the user's state
						conn.setAutoCommit(false);
						ResultSet rset_state = state_stmt.executeQuery(userState);
						if(rset_state.isBeforeFirst()) {
							rset_state.next();
							state = rset_state.getString("state");
						}
						conn.commit();
						conn.setAutoCommit(true);
							
			////////////FOR THE TOP ROW///////////////////////////////////////////////////////////////			
						
			
				
						String SQL_row_update = "UPDATE precompproductsrow SET total=total+? " +
						"WHERE name=? AND state=?";

						//update
						PreparedStatement pstmt_row_update = conn.prepareStatement(SQL_row_update);
						
						PreparedStatement pstmt_row_insert = conn.prepareStatement("INSERT INTO" +
						" precompproductsrow (total, name, state, cid) VALUES(?,?,?,?)");
						
						
						//for each product in sales
						for(int i = 0; i < sales.size(); i++) {
							String[] currentProd = sales.get(i).split("@");
							String name = currentProd[0];
							int quantity = Integer.parseInt(currentProd[1]);
							int price = Integer.parseInt(currentProd[2]);
							int cid = Integer.parseInt(currentProd[3]);
							
							
							
							//try to update
								conn.setAutoCommit(false);
								pstmt_row_update.setInt(1, quantity*price);
								pstmt_row_update.setString(2, name);
								pstmt_row_update.setString(3, state);
								
								int rows_changed = pstmt_row_update.executeUpdate();
									conn.commit();
								conn.setAutoCommit(true);
							
							
								//no rows changed, so we need to insert
								if(rows_changed == 0) {
									conn.setAutoCommit(false);
									pstmt_row_insert.setInt(1, quantity*price);
									pstmt_row_insert.setString(2, name);
									pstmt_row_insert.setString(3, state);
									pstmt_row_insert.setInt(4, cid);
									
									pstmt_row_insert.executeUpdate();
									conn.commit();
									conn.setAutoCommit(true);
								}
								
						}
						
			////////////END TOP ROW/////////////////////////////////////////////////
			
			
			
			
			
			////////////FOR THE FIRST COL///////////////////////////////////////////////////////////////			
						
				
						String SQL_col_update = "UPDATE precompstacuscol SET total=total+? " +
						"WHERE name=? AND cid=?";

						
						//update
						PreparedStatement pstmt_col_update = conn.prepareStatement(SQL_col_update);
						
						PreparedStatement pstmt_col_insert = conn.prepareStatement("INSERT INTO" +
						" precompstacuscol (total, name, state, cid) VALUES(?,?,?,?)");
						
						
						//for each product in sales
						for(int i = 0; i < sales.size(); i++) {
							String[] currentProd = sales.get(i).split("@");
							String name = currentProd[0];
							int quantity = Integer.parseInt(currentProd[1]);
							int price = Integer.parseInt(currentProd[2]);
							int cid = Integer.parseInt(currentProd[3]);
							

								conn.setAutoCommit(false);
								pstmt_col_update.setInt(1, quantity*price);
								pstmt_col_update.setString(2, uName);
								pstmt_col_update.setInt(3, cid);
								
								int num_changed = pstmt_col_update.executeUpdate();
								conn.commit();
								conn.setAutoCommit(true);
								
								
								
								
							//insert if nothing was updated
							if(num_changed == 0) {
								
								conn.setAutoCommit(false);
								pstmt_col_insert.setInt(1, quantity*price);
								pstmt_col_insert.setString(2, uName);
								pstmt_col_insert.setString(3, state);
								pstmt_col_insert.setInt(4, cid);
								
								pstmt_col_insert.executeUpdate();
								conn.commit();
								conn.setAutoCommit(true);
							}
							
						}
						
			////////////END FIRST COL/////////////////////////////////////////////////
			
			
			
			////////////FOR THE INNER CELL///////////////////////////////////////////////////////////////			
				
						String SQL_inner_update = "UPDATE precompcells SET total=total+? " +
						"WHERE name=? AND nam=?";
						
						
						//update
						PreparedStatement pstmt_inner_update = conn.prepareStatement(SQL_inner_update);
						
						PreparedStatement pstmt_inner_insert = conn.prepareStatement("INSERT INTO" +
						" precompcells (total, name, state, nam) VALUES(?,?,?,?)");
						
						
						//for each product in sales
						for(int i = 0; i < sales.size(); i++) {
							String[] currentProd = sales.get(i).split("@");
							String name = currentProd[0];
							int quantity = Integer.parseInt(currentProd[1]);
							int price = Integer.parseInt(currentProd[2]);
							int cid = Integer.parseInt(currentProd[3]);
							
							
							
								conn.setAutoCommit(false);
								pstmt_inner_update.setInt(1, quantity*price);
								pstmt_inner_update.setString(2, name);
								pstmt_inner_update.setString(3, uName);
								
								int num = pstmt_inner_update.executeUpdate();
								conn.commit();
								conn.setAutoCommit(true);
							
							//else we need to insert cause there were no updates
							if(num == 0) {
								conn.setAutoCommit(false);
								pstmt_inner_insert.setInt(1, quantity*price);
								pstmt_inner_insert.setString(2, name);
								pstmt_inner_insert.setString(3, state);
								pstmt_inner_insert.setString(4, uName);
								
								pstmt_inner_insert.executeUpdate();
								conn.setAutoCommit(true);
							}
							
						}
						
			////////////END INNER CELL/////////////////////////////////////////////////
			
			
							conn.setAutoCommit(false);
							/**record log,i.e., sales table**/
							//stmt.execute(SQL_copy);
							stmt.execute(SQL);
							conn.commit();
							
							conn.setAutoCommit(true);
							out.println("Dear customer '"+uName+"', Thanks for your purchasing.<br> Your card '"+card+"' has been successfully proved. <br>We will ship the products soon.");
							out.println("<br><font size=\"+2\" color=\"#990033\"> <a href=\"products_browsing.jsp\" target=\"_self\">Continue purchasing</a></font>");
					}
					catch(Exception e)
					{
						//out.println("Fail! Please try again <a href=\"purchase.jsp\" target=\"_self\">Purchase page</a>.<br><br>");
						e.printStackTrace();
					}
					conn.close();
				}
				catch(Exception e)
				{
						e.printStackTrace();
						out.println("<font color='#ff0000'>Error.<br><a href=\"purchase.jsp\" target=\"_self\"><i>Go Back to Purchase Page.</i></a></font><br>");
						
				}
			}
			else
			{
			
				out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
			}
		}
	catch(Exception e) 
	{ 
		out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
	}
%>
	
	</font><br>
</td></tr>
</table>
</div>
</body>
</html>
<%}%>