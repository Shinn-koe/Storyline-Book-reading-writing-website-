<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.dashboard.utils.DBConnection" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession userSession = request.getSession();
    Integer userId = (Integer) userSession.getAttribute("user_id");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String storyId = request.getParameter("storyId");
    String title = "";
    String content = "";
    String description = "";
    String category = "";
    String coverImage = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT title, content, description, category, cover_image FROM stories WHERE id = ? AND user_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(storyId));
        stmt.setInt(2, userId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
            description = rs.getString("description");
            category = rs.getString("category");
            coverImage = rs.getString("cover_image");
        } else {
            response.sendRedirect("mystory.jsp");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Story</title>
    <link rel="stylesheet" href="resources/css/style.css">
</head>
<body>
    <div class="container" style="font-family: Times;">
        <h2>Edit Story</h2>
        <form action="UpdateStoryServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="storyId" value="<%= storyId %>">
            
            <label>Title:</label>
            <input type="text" name="title" value="<%= title %>" required>


            <label>Category:</label>
            <select name="category" required>
                
                <option value="fiction" <%= category.equals("fiction") ? "selected" : "" %>>Fiction</option>
                <option value="non-fiction" <%= category.equals("non-fiction") ? "selected" : "" %>>Non-Fiction</option>
                <option value="fantasy" <%= category.equals("fantasy") ? "selected" : "" %>>Fantasy</option>
                <option value="romance" <%= category.equals("romance") ? "selected" : "" %>>Romance</option>
                <option value="thriller" <%= category.equals("thriller") ? "selected" : "" %>>Thriller</option>
                 <option value="action" <%= category.equals("action") ? "selected" : "" %>>Action</option>
                <option value="adventure" <%= category.equals("adventure") ? "selected" : "" %>>Adventure</option>
                <option value="chickLit" <%= category.equals("chickLit") ? "selected" : "" %>>ChickLit</option>
                <option value="classics" <%= category.equals("classics") ? "selected" : "" %>>Classics</option>
                <option value="knowledge" <%= category.equals("knowledge") ? "selected" : "" %>>Knowledge</option>
                 <option value="general" <%= category.equals("general") ? "selected" : "" %>>General</option>
                <option value="historical" <%= category.equals("historical") ? "selected" : "" %>>Historical</option>
                <option value="horror" <%= category.equals("horror") ? "selected" : "" %>>Horror</option>
                <option value="humor" <%= category.equals("humor") ? "selected" : "" %>>Humor</option>
                <option value="mystery" <%= category.equals("mystery") ? "selected" : "" %>>Mystery</option>
                 <option value="paranormal" <%= category.equals("paranormal") ? "selected" : "" %>>Paranormal</option>
                <option value="poetry" <%= category.equals("poetry") ? "selected" : "" %>>Poetry</option>
                <option value="random" <%= category.equals("random") ? "selected" : "" %>>Random</option>
                <option value="science" <%= category.equals("science") ? "selected" : "" %>>Science</option>
                <option value="short" <%= category.equals("short") ? "selected" : "" %>>Short</option>
                 <option value="spiritual" <%= category.equals("spiritual") ? "selected" : "" %>>Spiritual</option>
                <option value="teen" <%= category.equals("teen") ? "selected" : "" %>>Teen</option>
                <option value="vampire" <%= category.equals("vampire") ? "selected" : "" %>>Vampire</option>
                <option value="werewolf" <%= category.equals("werewolf") ? "selected" : "" %>>Werewolf</option>
                <option value="hot" <%= category.equals("hot") ? "selected" : "" %>>Hot</option>
            </select>

            <label>Content:</label>
            <textarea name="content" required><%= content %></textarea>

            <label>Cover Image:</label>
            <input type="file" name="cover">
            <% if (coverImage != null && !coverImage.isEmpty()) { %>
                <p>Current Cover: <img src="uploads/<%= coverImage %>" width="100"></p>
            <% } %>

            <button type="submit" style="font-family: Times">Update Story</button>
            <button onclick="window.history.back()" class="back-button" style="font-family: Times">Back</button>
        </form>
    </div>
</body>
</html>
