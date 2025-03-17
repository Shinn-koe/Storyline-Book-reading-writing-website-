<%@ page import="java.util.List" %>
<%@ page import="com.dashboard.servlets.Story" %>
<%@ page import="com.dashboard.servlets.StoryDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Get the user_id from the session
    Integer userId = (Integer) session.getAttribute("user_id");

    // Check if userId is null
    if (userId == null) {
        // If user_id is not available, redirect to login page
        response.sendRedirect("login.jsp");
        return; // Stop further execution
    }

    // Fetch published stories and popular stories
    List<Story> publishedStories = StoryDAO.getPublishedStories();
    List<Story> popularStories = StoryDAO.getMostLikedStories();
    session.setAttribute("publishedStories", publishedStories);
    session.setAttribute("popularStories", popularStories);

    // Fetch userLibraryStories from session (update it if necessary)
    List<Story> userLibraryStories = (List<Story>) session.getAttribute("userLibraryStories");
    if (userLibraryStories == null) {
        userLibraryStories = StoryDAO.getUserLibraryStories(userId);
        session.setAttribute("userLibraryStories", userLibraryStories);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* General Styles */
        :root {
            --primary-color: #f3c204;
            --background-dark: #1a1a1a;
            --background-light: #f0f0f0;
            --text-dark: #fff;
            --text-light: #333;
            --glass-background: rgba(255, 255, 255, 0.1);
            --glass-border: rgba(255, 255, 255, 0.2);
            --glass-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            --neon-glow: 0 0 10px #f3c204, 0 0 20px #f3c204, 0 0 40px #f3c204;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background: var(--background-dark);
            color: var(--text-dark);
            line-height: 1.6;
            transition: background 0.5s ease, color 0.5s ease;
        }
        body.light-mode {
            background: var(--background-light);
            color: var(--text-light);
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* Main Content */
        .main-content {
            margin-left: 80px; /* Default collapsed sidebar width */
            padding: 20px;
            min-height: 100vh;
            width: calc(100% - 80px); /* Adjust for collapsed sidebar width */
            transition: margin-left 0.3s ease, width 0.3s ease; /* Smooth transition */
        }

        /* Adjust main content when sidebar expands */
        .sidebar:hover ~ .main-content {
            margin-left: 250px; /* Expanded sidebar width */
            width: calc(100% - 250px); /* Adjust for expanded sidebar width */
        }

       /* Greeting Section */
        .greeting-section {
            position: relative;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: var(--glass-shadow);
            overflow: hidden;
            animation: float 6s ease-in-out infinite;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .greeting-section:hover {
            transform: scale(1.02);
            box-shadow: 0 8px 32px rgba(243, 194, 4, 0.3);
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        .greeting-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(243, 194, 4, 0.2), transparent 70%);
            animation: rotate 10s linear infinite;
            z-index: -1;
        }

        @keyframes rotate {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }

        .greeting-section h2 {
            font-family: 'Orbitron', sans-serif;
            font-size: 2.5rem;
            color: var(--primary-color);
            margin: 0;
            text-shadow: var(--neon-glow);
            animation: glow 2s infinite alternate;
        }

        @keyframes glow {
            0% {
                text-shadow: 0 0 10px #f3c204, 0 0 20px #f3c204, 0 0 40px #f3c204;
            }
            100% {
                text-shadow: 0 0 20px #f3c204, 0 0 40px #f3c204, 0 0 60px #f3c204;
            }
        }

        .greeting-section p {
            font-size: 1.1rem;
            color: var(--text-dark);
            margin: 10px 0 0;
            opacity: 0.9;
            position: relative;
            overflow: hidden;
            white-space: nowrap;
            animation: typing 3s steps(40, end);
        }

        @keyframes typing {
            from {
                width: 0;
            }
            to {
                width: 100%;
            }
        }

        /* Particle Animation */
        .particles {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }

        .particle {
            position: absolute;
            width: 2px;
            height: 2px;
            background: #f3c204;
            border-radius: 50%;
            animation: particle-float 5s infinite ease-in-out;
        }

        @keyframes particle-float {
            0%, 100% {
                transform: translateY(0) translateX(0);
            }
            50% {
                transform: translateY(-20px) translateX(20px);
            }
        }

        /* Parallax Effect */
        .parallax {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: radial-gradient(circle, rgba(243, 194, 4, 0.1), transparent 70%);
            animation: parallax 10s infinite linear;
        }

        @keyframes parallax {
            0% {
                transform: translateY(0) translateX(0);
            }
            50% {
                transform: translateY(-20px) translateX(-20px);
            }
            100% {
                transform: translateY(0) translateX(0);
            }
        }

        /* Section Cards */
        .section-card {
            background: var(--glass-background);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: var(--glass-shadow);
        }

        .section-card h2 {
            font-size: 1.2rem;
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        /* Book Section */
        .book-section {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 20px;
            padding: 10px;
        }

        /* Book Card */
        .book-card {
            background: var(--glass-background);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            box-shadow: var(--glass-shadow);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .book-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .book-card .book-details {
            padding: 15px;
            text-align: center;
        }

        .book-card .book-details h3 {
            font-size: 1rem;
            margin: 0;
            color: var(--text-dark);
        }

        .book-card .book-details p {
            font-size: 0.8rem;
            color: var(--text-dark);
            margin: 5px 0;
        }

        .book-card .book-details button {
            margin-top: 10px;
            padding: 8px 16px;
            background-color: var(--primary-color);
            border: none;
            color: var(--background-dark);
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
            font-size: 0.9rem;
        }

        .book-card .book-details button:hover {
            background-color: #e0ab03;
            transform: scale(1.05);
        }

        /* Floating Action Button (FAB) */
        .fab {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: var(--primary-color);
            color: var(--background-dark);
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 1.2rem;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .fab:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: var(--background-dark);
        }

        ::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #e0ab03;
        }

        /* Responsive Design */
        @media screen and (max-width: 768px) {
            .main-content {
                margin-left: 80px;
                width: calc(100% - 80px);
            }

            .book-section {
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            }
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />

    <!-- Main Content -->
    <div class="main-content">
         <!-- Greeting Section -->
        <div class="greeting-section">
            <!-- Particle Animation -->
            <div class="particles">
                <div class="particle" style="top: 10%; left: 20%; animation-delay: 0s;"></div>
                <div class="particle" style="top: 30%; left: 50%; animation-delay: 1s;"></div>
                <div class="particle" style="top: 70%; left: 80%; animation-delay: 2s;"></div>
                <div class="particle" style="top: 50%; left: 10%; animation-delay: 3s;"></div>
            </div>

            <!-- Parallax Effect -->
            <div class="parallax"></div>

            <!-- Greeting Content -->
            <h2>Hi, <span id="username">${username}</span>!</h2>
            <p>The library serves as a welcoming home for knowledge seekers and avid readers alike.</p>
        </div>
        <!-- Recently Added Section -->
        <div class="section-card">
            <h2>Recently Added</h2>
            <div class="book-section">
                <c:forEach var="story" items="${publishedStories}">
                    <div class="book-card">
                        <img src="uploads/${story.coverImage}" alt="${story.title}">
                        <div class="book-details">
                            <h3>${story.title}</h3>
                            <button onclick="location.href='readStory.jsp?id=${story.id}'" style="font-family:Times;">Read More</button>
                            <c:set var="isInLibrary" value="false"/>
                            <c:forEach var="libraryStory" items="${sessionScope.userLibraryStories}">
                                <c:if test="${libraryStory.id == story.id}">
                                    <c:set var="isInLibrary" value="true"/>
                                </c:if>
                            </c:forEach>
    
                            <button class="download-btn ${isInLibrary ? 'in-library' : ''}" data-storyid="${story.id}" style="font-family:Times;">
                                <c:choose>
                                    <c:when test="${isInLibrary}">Remove from Library</c:when>
                                    <c:otherwise>Add to Library</c:otherwise>
                                </c:choose>
                            </button>                    
                            </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Popular Now Section -->
        <div class="section-card">
            <h2>Popular Now</h2>
            <div class="book-section">
                <c:forEach var="story" items="${popularStories}">
                    <div class="book-card">
                        <img src="uploads/${story.coverImage}" alt="${story.title}">
                        <div class="book-details">
                            <h3>${story.title}</h3>
                            <p>Likes: ${story.likeCount}</p>
                            <button onclick="location.href='readStory.jsp?id=${story.id}'" style="font-family:Times;">Read More</button>
                            <c:set var="isInLibrary" value="false"/>
                            <c:forEach var="libraryStory" items="${sessionScope.userLibraryStories}">
                                <c:if test="${libraryStory.id == story.id}">
                                    <c:set var="isInLibrary" value="true"/>
                                </c:if>
                            </c:forEach>
    
                            <button class="download-btn ${isInLibrary ? 'in-library' : ''}" data-storyid="${story.id}" style="font-family:Times;">
                                <c:choose>
                                    <c:when test="${isInLibrary}">Remove from Library</c:when>
                                    <c:otherwise>Add to Library</c:otherwise>
                                </c:choose>
                            </button>                    
                            </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Floating Action Button (FAB) -->
    <button class="fab" onclick="location.href='newStory.jsp'">
        <i class="fas fa-plus"></i>
    </button>

    <script>
     document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll('.download-btn').forEach(button => {
                button.addEventListener('click', function () {
                    let storyId = this.getAttribute('data-storyid');
                    let currentButton = this;

                    currentButton.disabled = true;
                    currentButton.innerText = "Processing...";

                    fetch('DownloadServlet', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'storyId=' + storyId
                    })
                    .then(response => response.text())
                    .then(data => {
                        if (data === "Added") {
                            currentButton.innerText = "Remove from Library";
                            currentButton.classList.add("in-library");
                        } else if (data === "Removed") {
                            currentButton.innerText = "Add to Library";
                            currentButton.classList.remove("in-library");
                        } else {
                            currentButton.innerText = "Error, Try Again";
                        }
                        currentButton.disabled = false;
                    })
                    .catch(error => {
                        currentButton.innerText = "Error, Try Again";
                        currentButton.disabled = false;
                        console.error('Fetch error:', error);
                    });
                });
            });
        });
    </script>
</body>
</html>