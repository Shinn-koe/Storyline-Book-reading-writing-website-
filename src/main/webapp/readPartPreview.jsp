<%@ page import="java.sql.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/storyline";
    String dbUser = "root";
    String dbPassword = "shinn";

    // Get the part ID from the request
    String partId = request.getParameter("id");

    // Initialize variables for storing part details
    String title = "";
    String content = "";

    if (partId != null) {
        try {
            // Load the database driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish the connection
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            
            // Prepare SQL query
            String sql = "SELECT title, content FROM parts WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(partId));
            
            // Execute query
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
               title = rs.getString("title");
               content = rs.getString("content");
            } else {
                response.sendRedirect("myPart.jsp"); // Redirect if part not found
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
    <title><%= title %></title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
	
    <style>
        body {
            transition: background-color 0.3s, color 0.3s;
        }
        .back-arrow {
		    text-decoration: none;
		    font-size: 28px; /* Adjust size as needed */
		    color: black; /* Change color if needed */
		}
		.back-arrow:hover {
		    color: gray; /* Change color on hover */
		}
        .content {
            padding: 20px;
            border-radius: 8px;
        }
        .dark-mode {
            background-color: #222;
            color: #fff;
        }
        .dark-mode .content .back-arrow {
            background-color: #333;
            color: #fff;
            border: 1px solid #555;
        }
    </style>
</head>
<body class="light-mode">

<div class="container mt-6">
        <div class="d-flex justify-content-between align-items-center">
        	<!-- Back Button (Top Left) -->
            <a href="javascript:history.back()" class="back-arrow">
			    <i class="fa fa-arrow-left"></i>
			</a>
            
            <h1 class="text-center flex-grow-1"><%= title %> (Preview)</h1>
            <button id="themeToggle" class="btn btn-secondary">🌙 Dark</button>
        </div>
        <hr>
        <div class="content p-3 border">
            <p><%= content %></p>
        </div>
    </div>

<!-- JavaScript for Theme Toggle -->
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
