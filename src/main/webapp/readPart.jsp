<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="com.dashboard.servlets.PartDAO" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
	String jdbcURL = "jdbc:mysql://localhost:3306/storyline";
	String dbUser = "root";
	String dbPassword = "shinn";
	
	String partId = request.getParameter("id");
	
	String title = "";
	String content = "";
	String paymentStatus = "";
    String storyTitle = "";
    String username = "";
    String name = "";
    boolean isPurchased = false;
    boolean isAuthor = false;
    Integer totalCoins = 0;
    
    Integer userId = (Integer) session.getAttribute("user_id");
    int nextPartId = -1;
    String nextPartTitle = null;
    
	if (partId != null) {
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        
	        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
	        
	     	// Fetch part details
	        String sql = "SELECT p.title AS part_title, p.content, p.payment, " +
		                 "s.title AS story_title, u.username, u.name, s.user_id " +
		                 "FROM parts p " +
		                 "JOIN stories s ON p.story_id = s.id " +
		                 "JOIN users u ON s.user_id = u.id " +
		                 "WHERE p.id = ?";
	        PreparedStatement stmt = conn.prepareStatement(sql);
	        stmt.setInt(1, Integer.parseInt(partId));
	        ResultSet rs = stmt.executeQuery();
	        
	        if (rs.next()) {
	           title = rs.getString("part_title");
	           content = rs.getString("content");
	           paymentStatus = rs.getString("payment");
	           storyTitle = rs.getString("story_title");
	           username = rs.getString("username");
	           name = rs.getString("name");
	           
	           int authorId = rs.getInt("user_id");
               if (userId != null && userId == authorId) {
            	   isAuthor = true;
               }
	        } else {
	            response.sendRedirect("readStory.jsp");
	        }
	        
	     	// Check if the user has purchased this part
            if (userId != null && !isAuthor) {
                String purchaseCheckSQL = "SELECT COUNT(*) FROM purchases WHERE user_id = ? AND part_id = ?";
                PreparedStatement purchaseStmt = conn.prepareStatement(purchaseCheckSQL);
                purchaseStmt.setInt(1, userId);
                purchaseStmt.setInt(2, Integer.parseInt(partId));
                ResultSet purchaseRs = purchaseStmt.executeQuery();
                
                if (purchaseRs.next() && purchaseRs.getInt(1) > 0) {
                    isPurchased = true;
                }
                
                purchaseRs.close();
                purchaseStmt.close();
            }
                    
         	// Fetch the next part details
            String nextPartQuery = "SELECT id, title FROM parts WHERE story_id = (SELECT story_id FROM parts WHERE id = ?) AND id > ? AND status = 'published' ORDER BY id ASC LIMIT 1";
            PreparedStatement nextPartStmt = conn.prepareStatement(nextPartQuery);
            nextPartStmt.setInt(1, Integer.parseInt(partId));
            nextPartStmt.setInt(2, Integer.parseInt(partId));
            
            try (ResultSet nextPartRs = nextPartStmt.executeQuery()) {
                if (nextPartRs.next()) {
                    nextPartId = nextPartRs.getInt("id");
                    nextPartTitle = nextPartRs.getString("title");
                }
            }
            
            if (userId != null) {
                String coinQuery = "SELECT total_coins FROM users WHERE id = ?";
                PreparedStatement coinStmt = conn.prepareStatement(coinQuery);
                coinStmt.setInt(1, userId);
                ResultSet coinRs = coinStmt.executeQuery();
                
                if (coinRs.next()) {
                    totalCoins = coinRs.getInt("total_coins");
                }
                
                coinRs.close();
                coinStmt.close();
            }

	     
	        // Close connections
	        rs.close();
	        stmt.close();
	        conn.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Read Part - Storyline</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { transition: background-color 0.3s, color 0.3s; }
        .back-arrow { text-decoration: none; font-size: 28px; color: #f3c204; margin-left: 100px; }
		.back-arrow:hover { color: gray; }
        .content { padding: 20px; border-radius: 8px; }
        .dark-mode { background-color: #222; color: #fff; }
        .dark-mode .content .back-arrow { background-color: #333; color: #fff; border: 1px solid #555; }
        .header { display: flex; align-items: center; justify-content: space-between; padding: 20px; font-family: Times, serif; margin:0 50px; }
		.header-left { display: flex; align-items: center; }
		.header-left .back-arrow { width: 50px; height: 50px; margin-right: 10px; }
		.header-left span { font-size: 1.5em; font-weight: bold; }
		.header-right { display: flex; align-items: center; gap: 15px; margin-right: -180px; }
		.header-right select { width: 200px; padding: 10px; border: 1px solid #444; border-radius: 5px; cursor: pointer; }
		.header .by-username { text-decoration: none; color: #f1c40f; display: flex; align-items: center; font-size: 14px; }
		.container { display: flex; flex-direction: column; padding: 20px; font-family: Times, serif; }
		.content { flex: 1; padding: 20px; box-sizing: border-box; margin-left: 250px; }
		.content h1 { font-size: 1.8em; margin-bottom: 10px; text-align: center; position: relative; padding-bottom: 10px; margin-bottom: 20px;  border-bottom: 1px solid #000;}
		.content p { line-height: 1.6; }
		.stats { display: flex; justify-content: center; gap: 10px; font-size: 0.9em; margin-bottom: 30px; }
		.stats span { display: flex; align-items: center; gap: 5px; }
		.purchase-container { display: flex; flex-direction: column; align-items: center; text-align: center; margin-top: 20px; }
		.purchase-container .support-text { font-size: 25px; }
		.purchase-btn { display: flex; align-items: center; justify-content: center; background-color: #1e1e1e; color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-weight: bold; margin-top: 10px; transition: background 0.3s; }
		.purchase-btn:hover { background-color: #333; }
		.alert { margin: 20px; font-size: 1.2em; }
		.next-part { margin-top: 60px; text-align: center; }
		.next-part .next-part-link { padding: 10px 20px; background-color: #ffa500; border: none; color: #000; font-size: 1em; border-radius: 5px; cursor: pointer; text-decoration: none; }
    	.coin-box {
	      display: flex;
	      align-items: center;
	      justify-content: center;
	      background-color: #000;
	      color: #fff;
	      border: 2px solid #444;
	      border-radius: 10px;
	      padding: 5px 15px;
	      margin: 10px auto;
	      height: 40px;
	      width: 120px;
	      font-size: 1rem;
	      gap: 10px;
	      box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
	    }
	    .coin-box i {
	      color: #f3c204;
	      font-size: 1.5rem;
	    }
	    .coin-box span {
	      font-weight: bold;
	      color: #fff;
	    }
    </style>
    <script>
	    setTimeout(function() {
	        let alertBox = document.querySelector(".alert-success");
	        if (alertBox) {
	            alertBox.style.display = "none";
	        }
	    }, 3000); // Hide after 3 seconds
	    
	    setTimeout(function() {
	        let alertBox = document.querySelector(".alert-danger");
	        if (alertBox) {
	            alertBox.style.display = "none";
	        }
	    }, 3000);
	</script>
</head>
<body class="light-mode">
	<%@ include file="menu.jsp"%>
	<div class="container">
		<!-- Header Section -->
	    <div class="header">
	       <div class="header-left">
	       		<a href="javascript:history.back()" class="back-arrow">
			    	<i class="fa fa-arrow-left"></i>
				</a>
			    <div>
			        <span><%= storyTitle %></span>
			        <br>
			        <a href="profile.jsp?username=<%= username %>" class="by-username">by <%= username %></a>
			    </div>
			</div>
	
	        <div class="header-right">
	        	<div class="coin-box">
	                <i class="fas fa-coins"></i>
	                <span><%= totalCoins %></span>
	                <button style="background: none; border: none; color: #f3c204; font-weight: bold; font-size: 1.5rem; cursor: pointer;" onclick="location.href='earnCoin.jsp'">+</button>
	            </div>
	            <button id="themeToggle" class="btn btn-secondary">🌙 Dark</button>
	        </div>
	    </div>
	    
        <!-- Content Section -->
	    <div class="content">
	    	<% 
		        String successMessage = request.getParameter("success");
		        if ("1".equals(successMessage)) { 
		    %>
		        <div class="alert alert-success" role="alert">
		            Purchase successful! You can now read this part.
		        </div>
		    <% } %>
		    
	    	<h1><%= title %></h1><br>
	    	<%
		        if ("paid".equals(paymentStatus) && !isPurchased && !isAuthor) {
		    %>
	        <% 
		        String errorMessage = request.getParameter("error");
		        if ("2".equals(errorMessage)) { 
		    %>
		        <div class="alert alert-danger" role="alert">
		            You do not have enough coins to make the purchase!
		        </div>
		    <% } %>
		        <div class="purchase-container">
				    <p class="support-text">Show your support for <%= name %>, and continue reading this story</p>
				    <a href="PurchaseServlet?id=<%= partId %>" class="purchase-btn"> Unlock with coins </a>
				</div>
		    <%
		        } else {
		    %>
	        	<p><%= content %></p>
		        <% if (nextPartId != -1) { %>
		            <div class="next-part">
		                <a class="next-part-link" href="readPart.jsp?id=<%= nextPartId %>">Continue to Next Part</a>
		            </div>
		        <% } %>
		    <%
		        }
		    %>
	    </div>
    </div>
    
    <script>
        const toggleButton = document.getElementById('themeToggle');
        const body = document.body;
        // Load saved theme from localStorage
        if (localStorage.getItem('theme') === 'dark') {
            body.classList.add('dark-mode');
            toggleButton.textContent = '☀️ Light';
            toggleButton.classList.remove('btn-secondary');
            toggleButton.classList.add('btn-light');
        }
        toggleButton.addEventListener('click', () => {
            body.classList.toggle('dark-mode');
            if (body.classList.contains('dark-mode')) {
                localStorage.setItem('theme', 'dark');
                toggleButton.textContent = '☀️ Light';
                toggleButton.classList.remove('btn-secondary');
                toggleButton.classList.add('btn-light');
            } else {
                localStorage.setItem('theme', 'light');
                toggleButton.textContent = '🌙 Dark';
                toggleButton.classList.remove('btn-light');
                toggleButton.classList.add('btn-secondary');
            }
        });
    </script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
