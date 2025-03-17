<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.dashboard.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Stories - Storylines</title>
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
        <header><h1>My Stories</h1></header>
        <nav class="tabs">
            <a href="library.jsp">Library</a>
            <a href="favourite.jsp">Favourite</a>
            <a href="mystory.jsp" class="active">My Stories</a>
        </nav>
        <section id="mystory">
            <h2>My Stories</h2>
            <div class="story-container">
                <%
                    HttpSession userSession = request.getSession();
                    Integer userId = (Integer) userSession.getAttribute("user_id");
                    if (userId == null) {
                        response.sendRedirect("login.jsp");
                        return;
                    }
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        conn = DBConnection.getConnection();
                        String sql = "SELECT id, title, cover_image, status FROM stories WHERE user_id = ?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, userId);
                        rs = stmt.executeQuery();
                        while (rs.next()) {
                            int storyId = rs.getInt("id");
                            String title = rs.getString("title");
                            String coverImage = rs.getString("cover_image");
                            String status = rs.getString("status");
                            if (coverImage == null || coverImage.isEmpty()) coverImage = "resources/images/boys.jpg";
                %>
                <div class="story-card">
                    <img src="uploads/<%= coverImage %>" alt="Story Cover">
                    <div class="story-info">
                        <h3><%= title %></h3>
                        <p>by <%= session.getAttribute("username") %></p>
                    </div>
                    <div class="story-buttons">
                        <button onclick="editStory(<%= storyId %>)">Edit Story</button>
                        <button onclick="editPart(<%= storyId %>)">Edit Part</button>
                        <button onclick="deleteStory(<%= storyId %>)">Delete Story</button>
                         <% if ("draft".equals(status)) { %>
                            <button onclick="publishStory(<%= storyId %>)">Publish</button>
                        <% } else if ("published".equals(status)) { %>
                            <button onclick="draftStory(<%= storyId %>)">Draft</button>
                        <% } %>
                    </div>
                </div>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </section>
    </div>
    <!-- Custom Confirmation Modal -->
    <div id="customConfirm" class="modal">
        <div class="modal-content">
            <p id="confirmMessage">Are you sure?</p>
            <button onclick="confirmAction(true)">OK</button>
            <button onclick="confirmAction(false)">Cancel</button>
        </div>
    </div>

    <style>
    /* Modal Styling */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
    }
    .modal-content {
        background-color: #1e1e1e;
        color: white;
        padding: 20px;
        margin: 15% auto;
        width: 300px;
        text-align: center;
        border-radius: 8px;
    }
    .modal-content button {
        margin: 10px;
        padding: 10px 15px;
        border: none;
        cursor: pointer;
        border-radius: 4px;
    }
    .modal-content button:first-child {
        background-color: #fbc531;
    }
    .modal-content button:last-child {
        background-color: #e74c3c;
    }
    </style>

    <script>
    let pendingAction = null;

    function showConfirmBox(message, callback) {
        document.getElementById("confirmMessage").innerText = message;
        pendingAction = callback;
        document.getElementById("customConfirm").style.display = "block";
    }

    function confirmAction(confirmed) {
        document.getElementById("customConfirm").style.display = "none";
        if (confirmed && pendingAction) {
            pendingAction();
        }
    }

    function editStory(storyId) {
        window.location.href = 'editStory.jsp?storyId=' + storyId;
    }

    function editPart(storyId) {
        fetch("SetStoryIdServlet?storyId=" + storyId)
            .then(() => {
                window.location.href = "myPart.jsp";
            });
    }

    function deleteStory(storyId) {
        showConfirmBox("Are you sure you want to delete this story?", function() {
            window.location.href = 'DeleteStoryServlet?storyId=' + storyId;
        });
    }

    function publishStory(storyId) {
        showConfirmBox("Are you sure you want to publish this story?", function() {
            window.location.href = 'PublishStoryServlet?storyId=' + storyId;
        });
    }

    function draftStory(storyId) {
        showConfirmBox("Are you sure you want to revert this story to draft?", function() {
            window.location.href = "DraftStoryServlet?storyId=" + storyId;
        });
    }
    </script>
</body>
</html>
