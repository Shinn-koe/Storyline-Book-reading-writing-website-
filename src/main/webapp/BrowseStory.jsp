<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Stories</title>
    <style>
        .main-content {
            margin-left: 250px;
            padding: 20px;
            background-color: #000000;
            min-height: 100vh;
            width: calc(100% - 250px);
        }
        .book-section {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 10px;
            justify-content: center;
            padding: 10px;
        }
        .book-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            width: 150px;
        }
        .book-card:hover {
            transform: scale(1.03);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        .book-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        .book-card .book-details {
            padding: 8px;
        }
        .book-card .book-details h3 {
            font-size: 0.9rem;
            margin: 0;
            color: #333;
        }
        .book-card .book-details p {
            font-size: 0.7rem;
            color: #555;
            margin: 5px 0 0;
        }
        .book-card .book-details button {
            margin-top: 5px;
            padding: 5px 10px;
            background-color: #f3c204;
            border: none;
            color: #1a202c;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .book-details button:hover {
            background-color: #e0ab03;
        }
    </style>
</head>
<body>

<%@ include file="menu.jsp" %>

<%
    String category = request.getParameter("category");
    List<Map<String, String>> stories = new ArrayList<>();

    if (category != null && !category.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/storyline", "root", "shinn");

            String sql = "SELECT id, title, description, cover_image FROM stories WHERE category = ? AND status = 'published'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, String> story = new HashMap<>();
                story.put("id", rs.getString("id"));
                story.put("title", rs.getString("title"));
                story.put("description", rs.getString("description"));
                story.put("coverImage", rs.getString("cover_image"));
                stories.add(story);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    request.setAttribute("filteredStories", stories);
%>
<div class="main-content">
    <h2 style="color: #e0ab03; font-size: 1.2rem; margin-bottom: 10px;">Stories in <%= category %></h2>
    <div class="book-section">
        <c:forEach var="story" items="${filteredStories}">
            <div class="book-card">
                <img src="uploads/${story.coverImage}" alt="${story.title}">
                <div class="book-details">
                    <h3>${story.title}</h3>
                    <p>${story.description}</p>
                    <button onclick="location.href='readStory.jsp?id=${story.id}'">Read More</button>
                    <button class="download-btn" data-storyid="${story.id}">Download</button>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.download-btn').forEach(button => {
            button.addEventListener('click', function () {
                let storyId = this.getAttribute('data-storyid');

                fetch('DownloadServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'storyId=' + storyId
                })
                .then(response => response.text())
                .then(data => {
                    alert('Story added to Downloads!');
                });
            });
        });
    });
</script>

</body>
</html>
