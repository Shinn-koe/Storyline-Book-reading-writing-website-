<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.dashboard.servlets.Story" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library - Storylines</title>
    <link rel="stylesheet" href="resources/css/library.css">
    <style>
        .story-container {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: flex-start;
            margin-top: 20px;
        }

        .story-card {
            flex: 0 0 calc(20% - 15px);
            max-width: calc(20% - 15px);
            box-sizing: border-box;
            padding: 10px;
            background: #1e1e1e;
            border: 1px solid #333;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: transform 0.3s;
        }

        .story-card:hover {
            transform: translateY(-5px);
        }

        .story-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 6px;
        }

        .story-info {
            margin-top: 10px;
            padding: 8px;
            background: #333;
            border-radius: 6px;
            width: 100%;
            box-sizing: border-box;
            text-align: center;
        }

        .story-info h3 {
            font-size: 16px;
            color: #fbc531;
        }

        .story-info p {
            font-size: 12px;
            color: #ccc;
        }

        .story-buttons {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.8);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .story-card:hover .story-buttons {
            opacity: 1;
        }

        .story-buttons button {
            background-color: #fbc531;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
            width: 150px;
        }

        .story-buttons button:hover {
            background-color: #e1a600;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <div class="main-content">
        <header>
            <h1>Library</h1>
        </header>
        <nav class="tabs">
            <a href="library.jsp" class="active">Library</a>
            <a href="favourite.jsp">Favourite</a>
            <a href="mystory.jsp">Mystory</a>
        </nav>
        <section id="current-read">
            <h2>Library</h2>
            <div class="story-container">
                <% 
                int userId = (int) session.getAttribute("user_id");
                List<Story> downloads = getDownloadedStories(userId);
                if (downloads != null && !downloads.isEmpty()) {
                    for (Story story : downloads) { 
                %>
                        <div class="story-card">
                            <img src="uploads/<%= story.getCoverImage() %>" alt="<%= story.getTitle() %>">
                            <div class="story-info">
                                <h3><%= story.getTitle() %></h3>
                              <p>by <%= session.getAttribute("username") %></p>
                            </div>
                            <div class="story-buttons">
                                <!-- Updated Start Reading Button -->
                                <button onclick="startReading('<%= story.getId() %>')">Read More</button>
                                <form action="AddToFavouriteServlet" method="post">
                                    <input type="hidden" name="storyId" value="<%= story.getId() %>">
                                    <button type="submit">Add to Favourite</button>
                                </form>
                                <form action="DeleteDownloadServlet" method="post">
                                    <input type="hidden" name="storyId" value="<%= story.getId() %>">
                                    <button type="submit">Remove from Library</button>
                                </form>
                            </div>
                        </div>

                <%
                    }
                } else {
                %>
                        <p>No downloaded stories found.</p>
                <%
                }
                %>
            </div>
        </section>
    </div>
    <script>
        // Updated startReading function to redirect to readStory.jsp
        function startReading(storyId) {
            window.location.href = "readStory.jsp?id=" + storyId;
        }

        
    </script>
</body>
</html>
    
</body>
</html>
<%! 
// Method to get downloaded stories from the database for the user
public List<Story> getDownloadedStories(int userId) {
    List<Story> downloadedStories = new ArrayList<>();
    String query = "SELECT s.id, s.title, s.description, s.cover_image FROM downloads d JOIN stories s ON d.story_id = s.id WHERE d.user_id = ?";
    
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/storyline", "root", "shinn");
         PreparedStatement stmt = conn.prepareStatement(query)) {
        
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Story story = new Story();
            story.setId(rs.getInt("id"));
            story.setTitle(rs.getString("title"));
            story.setDescription(rs.getString("description"));
            story.setCoverImage(rs.getString("cover_image"));
            downloadedStories.add(story);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return downloadedStories;
}
%>