<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favourite - Storylines</title>
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
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .story-card:hover .story-buttons {
            opacity: 1;
        }

        .story-buttons button {
            background-color: #fbc531;
            border: none;
            padding: 10px 15px;
            margin: 5px 0;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
            width: 150px;
        }

        .story-buttons button:hover {
            background-color: #e1a600;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }

        .tabs a {
            padding: 10px 20px;
            text-decoration: none;
            color: #fbc531;
            border-bottom: 2px solid transparent;
        }

        .tabs a.active {
            border-bottom: 2px solid #fbc531;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <div class="main-content">
        <header>
            <h1>Favourite</h1>
        </header>

        <nav class="tabs">
            <a href="library.jsp">Library</a>
            <a href="favourite.jsp" class="active">Favourite</a>
            <a href="mystory.jsp">Mystory</a>
        </nav>

        <section id="favourite-stories">
            <h2>Favourite Stories</h2>
            <div class="story-container">
                <%
                    Integer userId = (Integer) session.getAttribute("user_id");
                    if (userId == null) {
                        response.sendRedirect("login.jsp");
                    } else {
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/storyline", "root", "shinn");
                            String query = "SELECT s.id, s.title, s.description, s.cover_image FROM favorites f JOIN stories s ON f.story_id = s.id WHERE f.user_id = ?";
                            stmt = conn.prepareStatement(query);
                            stmt.setInt(1, userId);
                            rs = stmt.executeQuery();
                            boolean hasFavorites = false;
                            while (rs.next()) {
                                hasFavorites = true;
                %>
                <div class="story-card">
                    <img src="uploads/<%= rs.getString("cover_image") %>" alt="<%= rs.getString("title") %>">
                    <div class="story-info">
                        <h3><%= rs.getString("title") %></h3>
                        <p>by <%= session.getAttribute("username") %></p>
                    </div>
                    <div class="story-buttons">
                        <button onclick="startReading('<%= rs.getInt("id") %>')">Read More</button>

                        <form action="RemoveFavouriteServlet" method="post">
                            <input type="hidden" name="storyId" value="<%= rs.getInt("id") %>">
                            <button type="submit">Remove from Favourite</button>
                        </form>
                    </div>
                </div>
                <%
                            }
                            if (!hasFavorites) {
                %>
                <p>No favourite stories yet.</p>
                <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    }
                %>
            </div>
        </section>
    </div>

    <script>
        function startReading(storyId) {
            window.location.href = "readStory.jsp?id=" + storyId;
        }

    </script>
</body>
</html>