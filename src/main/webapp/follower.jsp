<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.dashboard.utils.DBConnection" %>
<%@ page session="true" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Get the username from the request parameter (the viewed user's username)
    String profileUsername = request.getParameter("username");

    // If username is missing, redirect to the logged-in user's profile
    if (profileUsername == null || profileUsername.trim().isEmpty()) {
        response.sendRedirect("profile.jsp"); // Redirect to own profile if no username is provided
        return;
    }

    String loggedInUsername = (String) session.getAttribute("username"); // Get the logged-in user's username

    try {
        conn = DBConnection.getConnection();
        
        // SQL query to get the followers of the specified user
        String sql = "SELECT u.username, u.name, u.profile_picture " +
                     "FROM users u " +
                     "INNER JOIN followers f ON u.id = f.follower_id " +
                     "WHERE f.following_id = (SELECT id FROM users WHERE username = ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, profileUsername);
        rs = pstmt.executeQuery();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= profileUsername %>'s Followers</title>
    <style>
        body {
            background-color: #0d0d0d;
            color: white;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: #141414;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #ccc;
            text-align: center;
            width: 350px;
        }
        .user {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px;
            border-radius: 8px;
        }
        .user img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid gold;
        }
        .user span {
            flex-grow: 1;
            text-align: left;
            margin-left: 10px;
        }
        .follow-button {
            background-color: gold;
            color: black;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        .follow-button:hover {
            background-color: #FFD700;
        }
    </style>
</head>
<body>
    <%@ include file="menu.jsp" %>
    <div class="container">
        <h2><%= profileUsername %>'s Followers</h2>
        <% 
        boolean hasFollowers = false;
        while (rs.next()) {
            hasFollowers = true;
            String followerUsername = rs.getString("username"); // Get the follower's username
            String followerName = rs.getString("name");
            String profilePic = (rs.getString("profile_picture") != null) ? rs.getString("profile_picture") : "default.jpg";
            
            // Check if the logged-in user is already following this user
            String followStatusSql = "SELECT * FROM followers WHERE follower_id = (SELECT id FROM users WHERE username = ?) AND following_id = (SELECT id FROM users WHERE username = ?)";
            PreparedStatement followStatusStmt = conn.prepareStatement(followStatusSql);
            followStatusStmt.setString(1, loggedInUsername);
            followStatusStmt.setString(2, followerUsername);
            ResultSet followStatusRs = followStatusStmt.executeQuery();
            boolean isFollowing = followStatusRs.next();
        %>
            <div class="user">
                <img src="<%= profilePic %>" alt="User">
                <span>
                    <a href="profile.jsp?username=<%= followerUsername %>" style="color: gold; text-decoration: none;">
                        <%= followerName %>
                    </a>
                </span>
                
                <!-- Display follow button only if the logged-in user is not the follower -->
                <% if (!followerUsername.equals(loggedInUsername)) { %>
                    <form action="followAction.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="followUsername" value="<%= followerUsername %>">
                        <button type="submit" class="follow-button">
                            <%= isFollowing ? "Unfollow" : "Follow" %>
                        </button>
                    </form>
                <% } %>
            </div>
        <% 
            followStatusRs.close();
        }
        if (!hasFollowers) { %>
            <p>No followers yet.</p>
        <% } %>
    </div>
</body>
</html>

<%
    // Close resources
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
%>
