<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*, com.dashboard.utils.DBConnection" %>
<%@ page import="com.dashboard.servlets.SearchServlet" %>
<%
    String searchedUser = request.getParameter("username");
    String loggedInUser = (String) session.getAttribute("username");
    boolean isFollowing = false;

    if (searchedUser != null && loggedInUser != null) {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM followers WHERE follower_id = (SELECT id FROM users WHERE username = ?) AND following_id = (SELECT id FROM users WHERE username = ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, loggedInUser);
        stmt.setString(2, searchedUser);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            isFollowing = true; // Already following
        }
        rs.close();
        stmt.close();
        conn.close();
    }
%>
<html>
<head>
    <title>Search & Story</title>
    <style>
        body {
            background-color: #0D0D0D;
            color: white;
            font-family: Times, serif;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        .search-container {
            margin: 20px 0;
        }

        .search-box {
            padding: 10px;
            width: 300px;
            border-radius: 20px;
            border: none;
            outline: none;
            font-size: 16px;
            font-family:Times;
        }

        .search-btn {
            background-color: #D4A017;
            color: black;
            padding: 10px 20px;
            border: none;
            border-radius: 20px;
            font-size: 16px;
            cursor: pointer;
            font-family:Times;
            
        }

        .container {
            display: flex;
            align-items: flex-start;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        .user, .story {
            background-color: #1A1A1A;
            padding: 20px;
            border-radius: 10px;
            width: 45%;
            border: 1px solid #D4A017;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border-bottom: 1px solid #D4A017;
            text-align: left;
        }

        .profile-pic, .story-cover {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #D4A017;
        }

        .story-cover {
            width: 80px;
            height: 100px;
            border-radius: 5px;
        }

        .follow-btn {
            background-color: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .follow-btn.following {
            background-color: #28a745;
        }
        .content {
 margin-left: 80px; /* Default collapsed sidebar width */
            padding: 20px;
            background-color: #000000;
            min-height: 100vh;
            width: calc(100% - 80px); /* Adjust for collapsed sidebar width */
            transition: margin-left 0.3s ease, width 0.3s ease;     }
    .sidebar:hover ~ .content {
            margin-left: 250px; /* Expanded sidebar width */
            width: calc(100% - 250px); /* Adjust for expanded sidebar width */
        }
        media screen and (max-width: 768px) {
            .content {
                margin-left: 80px;
                width: calc(100% - 80px);
            }
        }
    </style>
</head>
<body>
    <%@ include file="menu.jsp" %>
    <div class="content">
        <div class="search-container">
            <form action="SearchServlet" method="post">
                <input type="text" name="search" class="search-box" placeholder="Enter story, name, username" required>
                <input type="submit" value="Search" class="search-btn">
            </form>
        </div>

        <div class="container">
<% String searchQuery = request.getParameter("search"); %>

<div class="user">
    <h2>Users</h2>
    <table>
        <% List<SearchServlet.User> users = (List<SearchServlet.User>) request.getAttribute("users"); %>
        <% if (searchQuery != null && !searchQuery.trim().isEmpty()) { // Only display if a search was performed %>
            <% if (users != null && !users.isEmpty()) { %>
                <% for (SearchServlet.User user : users) { %>
                    <tr>
                        <td>
                            <a href="profile.jsp?username=<%= user.getUsername() %>" style="text-decoration: none; color: inherit;">
                                <img src="<%= user.getProfilePicture() != null ? user.getProfilePicture() : "default.jpg" %>" class="profile-pic">
                            </a>
                        </td>
                        <td>
                            <a href="profile.jsp?username=<%= user.getUsername() %>" style="text-decoration: none; color: inherit;">
                                <%= user.getName() %>
                            </a>
                        </td>
                        <td>
                            <% if (!user.getUsername().equals(loggedInUser)) { %>
                                <button class="follow-btn <%= user.isFollowing() ? "following" : "" %>"
                                        onclick="toggleFollow(this, '<%= user.getUsername() %>')">
                                    <%= user.isFollowing() ? "Following" : "Follow" %>
                                </button>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="3" style="text-align: center; color: #D4A017;">No users found</td>
                </tr>
            <% } %>
        <% } %>
    </table>
</div>


 <div class="story">
    <h2>Stories</h2>
    <table>
        <% List<SearchServlet.Story> stories = (List<SearchServlet.Story>) request.getAttribute("stories"); %>
        <% if (searchQuery != null && !searchQuery.trim().isEmpty()) { // Only display if a search was performed %>
            <% if (stories != null && !stories.isEmpty()) { %>
                <% for (SearchServlet.Story story : stories) { %>
                    <tr>
                        <td>
                            <a href="readStory.jsp?id=<%= story.getId() %>" style="text-decoration: none; color: inherit;">
                            <img src="<%= request.getContextPath() %>/uploads/<%= story.getCoverImage() %>" class="story-cover">
                            </a>
                        </td>
                        <td>
                            <a href="readStory.jsp?id=<%= story.getId() %>" style="text-decoration: none; color: inherit;">
                                <%= story.getTitle() %>
                            </a>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="2" style="text-align: center; color: #D4A017;">No stories found</td>
                </tr>
            <% } %>
        <% } %>
    </table>
</div>


        </div>
    </div>

    <script>
        function toggleFollow(btn, username) {
            let xhr = new XMLHttpRequest();
            xhr.open("POST", "FollowServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    btn.classList.toggle("following");
                    btn.innerText = btn.classList.contains("following") ? "Following" : "Follow";
                }
            };
            xhr.send("followingUsername=" + encodeURIComponent(username));
        }
    </script>
</body>
</html>

