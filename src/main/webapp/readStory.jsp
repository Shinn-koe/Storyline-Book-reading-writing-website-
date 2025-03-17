<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.dashboard.utils.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.dashboard.servlets.storyPart" %>
<%@ page import="com.dashboard.servlets.PartDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
	// Retrieve storyId from request or session
	String storyIdParam = request.getParameter("id");
	HttpSession sessionObj = request.getSession();
	Integer storyId = (storyIdParam != null) ? Integer.parseInt(storyIdParam) : (Integer) sessionObj.getAttribute("storyId");
	
	// If storyId is in the request, store it in the session for later use
    if (storyIdParam != null) {
        sessionObj.setAttribute("storyId", storyId);
    }
	
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
 	// Retrieve user session
    String title = "";
    String content = "";
    String coverImage = "";
    String author = "";
    String category = "";
    int likeCount = 0;
    boolean isLiked = false;
    int publishedPartCount = 0;

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT s.title, s.content, s.cover_image, s.category, u.username, " +
                     "(SELECT COUNT(*) FROM likes WHERE story_id = s.id) AS like_count, " +
                     "(SELECT COUNT(*) FROM likes WHERE story_id = s.id AND user_id = ?) AS user_liked " +
                     "FROM stories s " +
                     "JOIN users u ON s.user_id = u.id " +
                     "WHERE s.id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, storyId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    title = rs.getString("title");
                    content = rs.getString("content");
                    coverImage = rs.getString("cover_image");
                    category = rs.getString("category");
                    author = rs.getString("username");
                    likeCount = rs.getInt("like_count");
                    isLiked = rs.getInt("user_liked") > 0;
                } else {
                    response.sendRedirect("dashboard.jsp");
                    return;
                }
            }
        }
    
     	// Count the number of published parts
        String countSql = "SELECT COUNT(*) AS published_count FROM parts WHERE story_id = ? AND status = 'published'";
        try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
            countStmt.setInt(1, storyId);
            try (ResultSet countRs = countStmt.executeQuery()) {
                if (countRs.next()) {
                    publishedPartCount = countRs.getInt("published_count"); // Assign value here
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    // Fetch published parts related to this story
    PartDAO partDAO = new PartDAO();
    List<storyPart> publishPart = partDAO.selectPartsByStatus(storyId);
    request.setAttribute("publishPart", publishPart);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %></title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { font-family: 'Arial', sans-serif; background-color: #f9f9f9; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
		.story-container { flex: 3; background: #ffffff; padding: 30px; max-width: 700px; width: 100%; border-radius: 12px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); text-align: center; }
		.story-cover { width: 100%; max-height: 300px; object-fit: cover; border-radius: 10px; margin-bottom: 20px; }
		.story-title { font-size: 26px; font-weight: bold; color: #333; }
		.story-meta { font-size: 14px; color: #666; margin: 10px 0; }
		.story-content { text-align: left; font-size: 16px; line-height: 1.6; color: #444; margin-top: 20px; }
		.like-container { margin-top: 20px; }
		.like-btn { font-size: 26px; cursor: pointer; transition: 0.3s; color: <%= isLiked ? "red" : "gray" %>; }
		.like-btn:hover { transform: scale(1.2); }
		#like-count { font-size: 18px; margin-left: 8px; color: #333; }
		.back-btn { display: inline-block; margin-top: 20px; padding: 10px 18px; background-color: #007BFF; color: white; text-decoration: none; font-size: 16px; border-radius: 5px; transition: 0.3s; }
		.back-btn:hover { background-color: #0056b3; }
		.action-buttons { display: flex; align-items: center; gap: 15px; margin-top: 15px; }
		.comment-btn {
            font-size: 24px;
            cursor: pointer;
            transition: 0.3s;
        }

        .comment-btn:hover {
            transform: scale(1.2);
        }

        
        .comment-section {
            margin-top: 20px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 8px;
        }

        #comment-input {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        #submit-comment {
            margin-top: 10px;
            padding: 8px 15px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        #submit-comment:hover {
            background-color: #0056b3;
        }

        /* Comments List */
        .comment {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        .comment strong {
            color: #333;
        }

        .comment-date {
            font-size: 12px;
            color: #777;
            margin-left: 10px;
        }
		.main-container { display: flex; justify-content: center; align-items: flex-start; gap: 20px; max-width: 1000px; width: 100%; margin: 20px auto; margin-left: 400px; }
		.part-section { flex: 1; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); }
		.part-section h3 { font-size: 18px; margin-bottom: 15px; }
		.action-buttons button { padding: 10px 20px; font-size: 16px; background-color: grey; border: none; border-radius: 5px; cursor: pointer; font-family: Times; color: white; }
		.action-buttons button:hover { background-color: #ffcc66; }
		.related-story ul { list-style: none; padding: 0; margin: 0; }
		.related-story li { background-color: #fff; margin: 10px 0; padding: 10px; border-radius: 6px; transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out; }
		.related-story li:hover { transform: translateY(-5px); box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.8); }
		.related-story a { text-decoration: none; color: #000; display: block; }
		.related-story a:hover { color: gray; }
		.locked-part { color: gray; font-style: italic; cursor: not-allowed; }
    	.action-buttons button { padding: 10px 20px; font-size: 16px; background-color: grey; border: none; border-radius: 5px; cursor: pointer;font-family: Times;color:white; }
        .action-buttons button:hover { background-color: #ffcc66; }
        .back-arrow { text-decoration: none; font-size: 28px; color: #f3c204; margin-left: 100px; }
    .back-arrow:hover { color: gray; }
</style>
</head>
<body>
    <%@ include file="menu.jsp" %>
<div class="main-container">
<a href="javascript:history.back()" class="back-arrow">
            <i class="fa fa-arrow-left"></i>
        </a>
<!-- Story Container -->
    <div class="story-container">
        <% if (coverImage != null && !coverImage.isEmpty()) { %>
            <img src="uploads/<%= coverImage %>" alt="Cover Image" class="story-cover">
        <% } %>
        
        <h1 class="story-title"><%= title %></h1>
        <p class="story-meta">
         By <a href="profile.jsp?username=<%= author %>" style="text-decoration:none;color:#666"><strong><%= author %></strong></a>
         | Category: <a href="BrowseStory.jsp?category=<%= category %>" style="text-decoration:none;color:#666"><strong><%= category %></strong></a>
         | Part: <strong><%= publishedPartCount %></strong></p>
        
        <div class="story-content">
            <%= content.replace("\n", "<br>") %>
        </div>
        
        <%
		    // Fetch the first published part related to this story
		    storyPart firstPublishedPart = null;
		    if (publishPart != null && !publishPart.isEmpty()) {
		        firstPublishedPart = publishPart.get(0); // Get the first part
		    }
		%>
		
        <!-- Like Button -->
       <div class="action-buttons">
		    <span id="like-btn" class="like-btn" data-story-id="<%= storyId %>">❤️</span> 
		    <span id="like-count"><%= likeCount %></span>
		
		    <span id="comment-btn" class="comment-btn">💬</span> 
		     <% if (firstPublishedPart != null) { %>
		        <a href="readPart.jsp?id=<%= firstPublishedPart.getId() %>"><button>Start reading</button></a>
		    <% } %>
		</div>

		<!-- Comment Section -->
        <div id="comment-section" class="comment-section">
            <h3>Comments</h3>
            <ul id="comments-container">
                <c:choose>
                    <c:when test="${not empty comments}">
                        <c:forEach var="comment" items="${comments}">
                            <li class="comment">
                                <strong>${comment.username}</strong>: ${comment.comment_text}
                                <span class="comment-date">${comment.created_at}</span>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li>Click and Comment if you want to see more.</li>
                    </c:otherwise>
                </c:choose>
            </ul>

            <!-- Add Comment Form -->
           <form action="CommentServlet" method="POST">
                <input type="hidden" name="storyId" value="<%= storyId %>" />
                <textarea id="comment-input" name="comment" placeholder="Write a comment..." required></textarea>
                <button id="submit-comment" type="submit" style="font-family:Times;">Submit</button>
            </form>
        </div>
	</div>
	<!-- Part Section -->
	<div class="part-section">
		<h3>Story's Part</h3>
		<% if (publishPart != null && !publishPart.isEmpty()) { %>
	    <div class="related-story">
		    <ul>
		        <% for (storyPart part : publishPart) { 
		            boolean isPaid = "paid".equals(part.getPayment());
		            boolean isPurchased = false;
		            boolean isAuthor = false;
		            
		         	// Get the author's user_id from the stories table
                    String authorCheckQuery = "SELECT user_id FROM stories WHERE id = ?";
                    try (Connection conn = DBConnection.getConnection();
                         PreparedStatement authorStmt = conn.prepareStatement(authorCheckQuery)) {
                        authorStmt.setInt(1, part.getStoryId());
                        try (ResultSet authorRs = authorStmt.executeQuery()) {
                            if (authorRs.next() && authorRs.getInt("user_id") == userId) {
                                isAuthor = true;
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
		
                 	// Check if user has purchased this part
                    if (!isAuthor) { // Only check purchase if not the author
                        String purchaseCheckQuery = "SELECT COUNT(*) FROM purchases WHERE user_id = ? AND part_id = ?";
                        try (Connection conn = DBConnection.getConnection();
                             PreparedStatement purchaseStmt = conn.prepareStatement(purchaseCheckQuery)) {
                            purchaseStmt.setInt(1, userId);
                            purchaseStmt.setInt(2, part.getId());
                            try (ResultSet purchaseRs = purchaseStmt.executeQuery()) {
                                if (purchaseRs.next() && purchaseRs.getInt(1) > 0) {
                                    isPurchased = true;
                                }
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
		        %>
		            <li>
		                <% if (isPaid && !isPurchased && !isAuthor) { %>
		                    <span class="locked-part">
		                        <a href="readPart.jsp?id=<%= part.getId() %>"><%= part.getTitle() %> 🔒 </a>
		                    </span>
		                <% } else { %>
		                    <a href="readPart.jsp?id=<%= part.getId() %>"> <%= part.getTitle() %> </a>
		                <% } %>
		            </li>
		        <% } %>
		    </ul>
		</div>

	    <% } else { %>
	    <p>No published parts available.</p>
		<% } %>
	</div>
    
</div>
<script>
$(document).ready(function() {
    let storyId = "<%= storyId %>";

    // Like button functionality
    $('#like-btn').click(function() {
        $.post('LikeServlet', { storyId: storyId }, function(response) {
            $('#like-count').text(response.likeCount);
            $('#like-btn').css('color', response.isLiked ? 'red' : 'gray');
        }, 'json');
    });

   

    // Show/hide comment section
    $('#comment-btn').click(function() {
        $('#comment-section').toggle();
    });
});
</script>

</body>
</html>
