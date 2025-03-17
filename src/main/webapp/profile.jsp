<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.dashboard.utils.DBConnection" %>
<%@ page session="true" %>
<%
    // Get the username from query parameter; fallback to session username if not provided
    String profileUsername = request.getParameter("username");
    if (profileUsername == null || profileUsername.trim().isEmpty()) {
        profileUsername = (String) session.getAttribute("username"); // show own profile
    }

    // Set default profile values
    String name = "Fullname";
    String profilePicture = "image/2.jpg";
    String coverPicture = "image/1.jpg";
    String bio = "This is my bio."; 
    Integer profileUserId = null;
    Integer workCount = 0; 
    Integer totalCoins = 0;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT id, name, profile_picture, cover_picture, bio, total_coins FROM users WHERE username = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, profileUsername);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            profileUserId = rs.getInt("id");
            name = rs.getString("name");
            profilePicture = rs.getString("profile_picture") != null ? rs.getString("profile_picture") : "image/2.jpg";
            coverPicture = rs.getString("cover_picture") != null ? rs.getString("cover_picture") : "image/1.jpg";
            bio = rs.getString("bio") != null ? rs.getString("bio") : "This user has no bio.";
            totalCoins = rs.getInt("total_coins");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) rs.close();
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
    }

    Integer followersCount = 0;
    Integer followingCount = 0;

    try {
        conn = DBConnection.getConnection();
        // Get followers count
        String followersQuery = "SELECT COUNT(*) AS count FROM followers WHERE following_id = (SELECT id FROM users WHERE username = ?)";
        pstmt = conn.prepareStatement(followersQuery);
        pstmt.setString(1, profileUsername);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            followersCount = rs.getInt("count");
        }
        rs.close();
        pstmt.close();

        // Get following count
        String followingQuery = "SELECT COUNT(*) AS count FROM followers WHERE follower_id = (SELECT id FROM users WHERE username = ?)";
        pstmt = conn.prepareStatement(followingQuery);
        pstmt.setString(1, profileUsername);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            followingCount = rs.getInt("count");
        }
        rs.close();
        pstmt.close();
        
     // Get the number of published works
        if (profileUserId != null) {
            String workCountQuery = "SELECT COUNT(*) AS work_count FROM stories WHERE user_id = ? AND status = 'published'";
            pstmt = conn.prepareStatement(workCountQuery);
            pstmt.setInt(1, profileUserId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                workCount = rs.getInt("work_count");
            }
            rs.close();
            pstmt.close();
        }

        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= profileUsername %>'s Profile</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <style>
    /* Global Styles */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      text-decoration: none;
      color: white;
    }
    body {
      font-family: Arial, sans-serif;
      background-color: #000;
      color: #fff;
    }
    /* Banner & Profile Section */
    .banner {
      height: 200px;
      width: 100%;
      display: block;
    }
    .profile-section {
      text-align: center;
      margin-top: -80px;
      font-family: Times, serif;
    }
    .profile-section img {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      border: 5px solid #fff;
    }
    .profile-section h1 {
      font-size: 1.5rem;
      margin: 10px 0 5px;
    }
    .profile-section p {
      color: #aaa;
      font-size: 1rem;
    }
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
      width: 150px;
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
    .profile-stats {
      display: flex;
      justify-content: center;
      gap: 30px;
      margin: 15px 0;
    }
    .profile-stats div {
      text-align: center;
    }
    .profile-stats div span {
      display: block;
      font-weight: bold;
      font-size: 1.2rem;
    }
    /* Main Content */
    .main-content {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 20px;
      padding: 20px;
    }
    .stories, .description {
      background-color: #111;
      padding: 20px;
      border-radius: 8px;
      width: 48%;
    }
    .stories h2, .description h2 {
      margin-bottom: 15px;
    }
    /*story*/
    .story-card {
      display: flex;
      gap: 15px;
      margin-bottom: 15px;
    }
    .story-card img {
      width: 80px;
      height: 80px;
      border-radius: 8px;
      object-fit: cover;
    }
    .story-details {
      display: flex;
      flex-direction: column;
      justify-content: center;
    }
    .story-details h3 {
      margin: 0;
      font-size: 1rem;
    }
    /* Social Links */
    .social-links {
      display: flex;
      justify-content: flex-start;
      gap: 10px;
      margin-top: 15px;
    }
    .social-links a {
      display: inline-block;
      width: 40px;
      height: 40px;
      background-color: #444;
      color: #fff;
      font-size: 1.5rem;
      text-align: center;
      line-height: 40px;
      border-radius: 50%;
      transition: background-color 0.3s, color 0.3s;
    }
    .social-links a:hover {
      background-color: #f3c204;
      color: #000;
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
        .back-arrow { text-decoration: none; font-size: 28px; color: #f3c204; }
    .back-arrow:hover { color: gray; }
  </style>
</head>
<body>
    <%@ include file="menu.jsp" %>
    <div class="content">
    <a href="javascript:history.back()" class="back-arrow">
            <i class="fa fa-arrow-left"></i>
        </a>
        <!-- Banner and Profile Header -->
        <img class="banner" src="<%= coverPicture %>" alt="Cover Image">
        <div class="profile-section">
            <img src="<%= profilePicture %>" alt="Profile Picture">
            <h1><%= name %></h1>
            <p>@<%= profileUsername %></p>
            <%
            String loggedInUser = (String) session.getAttribute("username");
			    if (profileUsername.equals(loggedInUser)) { // Hide button for own profile
			%>
            <div class="coin-box">
                <i class="fas fa-coins"></i>
                <span><%= totalCoins %></span>
                <button style="background: none; border: none; color: #fff; font-size: 1.2rem; cursor: pointer;" onclick="location.href='earnCoin.jsp?id=<%= profileUserId %>'">+</button>
            </div>
            <%
			    }
			%>
            <%
    
			    boolean isFollowing = false;
			
			    if (loggedInUser != null && profileUserId != null) {
			        Connection conn3 = null;
			        PreparedStatement pstmt3 = null;
			        ResultSet rs3 = null;
			        try {
			            conn3 = DBConnection.getConnection();
			            String followCheckQuery = "SELECT 1 FROM followers WHERE follower_id = (SELECT id FROM users WHERE username = ?) AND following_id = ?";
			            pstmt3 = conn3.prepareStatement(followCheckQuery);
			            pstmt3.setString(1, loggedInUser);
			            pstmt3.setInt(2, profileUserId);
			            rs3 = pstmt3.executeQuery();
			            isFollowing = rs3.next();
			        } catch (Exception e) {
			            e.printStackTrace();
			        } finally {
			            if (rs3 != null) rs3.close();
			            if (pstmt3 != null) pstmt3.close();
			            if (conn3 != null) conn3.close();
			        }
			    }
			%>
			<%
			    if (!profileUsername.equals(loggedInUser)) { // Hide button for own profile
			%>
			<button id="followBtn" class="follow-btn" onclick="toggleFollow('<%= profileUsername %>')" style="background: #f3c204; border: none; color: black; font-size: 1rem; cursor: pointer; padding: 8px 12px; border-radius: 5px;">
			    <%= isFollowing ? "Unfollow" : "Follow" %>
			</button>
			<%
			    }
			%>
			
            <div class="profile-stats">
                <div>
                    <span id="workCount"><%= workCount %></span> Work
                </div>
                <div>
                    <span id="followersCount"><%= followersCount %></span>
                    <a href="follower.jsp?username=<%= profileUsername %>">Followers</a>
                </div>
                <div>
                    <span id="followingCount"><%= followingCount %></span>
                    <a href="following.jsp?username=<%= profileUsername %>">Followings</a>
                </div>
            </div>
        </div>
        <!-- Main Content: Stories & Bio -->
        <div class="main-content">
            <!-- Stories Section -->
            <div class="stories">
                <h2>Stories</h2>
                <%
                    if(profileUserId != null) {
                        Connection conn2 = null;
                        PreparedStatement pstmt2 = null;
                        ResultSet rs2 = null;
                        try {
                            conn2 = DBConnection.getConnection();
                            String storiesSql = "SELECT id, title, cover_image FROM stories WHERE user_id = ? AND status = 'published'";
                            pstmt2 = conn2.prepareStatement(storiesSql);
                            pstmt2.setInt(1, profileUserId);
                            rs2 = pstmt2.executeQuery();
                            while(rs2.next()){
                                int storyId = rs2.getInt("id");
                                String storyTitle = rs2.getString("title");
                                String coverImage = rs2.getString("cover_image");
                                if(coverImage == null || coverImage.trim().isEmpty()){
                                    coverImage = "default-story.jpg";
                                }
                %>
                                <!-- Each story card is linked to readStory.jsp via the story id -->
                                <a href="readStory.jsp?id=<%= storyId %>" style="text-decoration: none; color: inherit;">
                                    <div class="story-card">
                                        <img src="uploads/<%= coverImage %>" alt="Story Thumbnail">
                                        <div class="story-details">
                                            <h3><%= storyTitle %></h3>
                                        </div>
                                    </div>
                                </a>
                <%
                            }
                        } catch(Exception e) {
                            e.printStackTrace();
                        } finally {
                            if(rs2 != null) rs2.close();
                            if(pstmt2 != null) pstmt2.close();
                            if(conn2 != null) conn2.close();
                        }
                    }
                %>
            </div>
            <!-- Description / Bio Section -->
            <div class="description">
                <h3>Bio</h3>
                <p><%= bio %></p>
                <div class="social-links">
                    <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                    <a href="#" aria-label="Pinterest"><i class="fab fa-pinterest-p"></i></a>
                </div>
            </div>
        </div>
    </div>
    <script>
    
        document.addEventListener("DOMContentLoaded", function () {
            let followersCount = localStorage.getItem("followersCount");
            let followingCount = localStorage.getItem("followingCount");
            let updateProfile = localStorage.getItem("updateProfile");

            if (updateProfile) {
                if (followersCount !== null) {
                    document.getElementById("followersCount").innerText = followersCount;
                }
                if (followingCount !== null) {
                    document.getElementById("followingCount").innerText = followingCount;
                }
                localStorage.removeItem("updateProfile");
                localStorage.removeItem("followersCount");
                localStorage.removeItem("followingCount");
            }
        });
        function toggleFollow(username) {
            let btn = document.getElementById("followBtn");
            let followersCountElement = document.getElementById("followersCount");

            let xhr = new XMLHttpRequest();
            xhr.open("POST", "FollowServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    let response = xhr.responseText.trim();
                    console.log("Server Response:", response);

                    let parts = response.split("|");
                    if (parts.length === 3) {
                        let status = parts[0];
                        let followersCount = parseInt(parts[1], 10);
                        let followingCount = parseInt(parts[2], 10);

                        if (!isNaN(followersCount)) {
                            followersCountElement.innerText = followersCount;
                        }

                        if (status === "followed") {
                            btn.innerText = "Unfollow";
                        } else if (status === "unfollowed") {
                            btn.innerText = "Follow";
                        } else {
                            alert("Error updating follow status.");
                        }
                    } else {
                        alert("Unexpected response from server.");
                    }
                }
            };

            xhr.send("followingUsername=" + encodeURIComponent(username));
        }
    </script>
</body>
</html>
