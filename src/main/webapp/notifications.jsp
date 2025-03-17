<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Redirect to NotificationServlet if notifications are not set
    if (request.getAttribute("notifications") == null) {
        response.sendRedirect("NotificationServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications</title>
    <!-- Google Fonts for modern typography -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Global Styles */
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

        /* Notifications Container */
        #notifications {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background: var(--glass-background);
            backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            box-shadow: var(--glass-shadow);
            overflow: hidden;
            animation: float 6s ease-in-out infinite;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        #notifications:hover {
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

        /* Clear Notifications Button */
        .clear-notifications-btn {
            display: block;
            margin: 0 auto 20px;
            padding: 10px 20px;
            background-color: var(--primary-color);
            color: var(--background-dark);
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .clear-notifications-btn:hover {
            background-color: #e0ab03;
            transform: scale(1.05);
        }

        /* Notification List */
        #notification-list {
            list-style-type: none;
            padding: 0;
        }
        #notification-list li {
            padding: 15px;
            margin: 10px 0;
            border-radius: 12px;
            background: var(--glass-background);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        #notification-list li:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        /* Notification Content */
        .notification-content {
            flex: 1;
            margin-right: 15px;
        }
        .notification-content strong {
            color: var(--primary-color);
            font-weight: 600;
        }
        .notification-content em {
            color: var(--text-dark);
            font-style: italic;
        }

        /* Notification Date */
        .notification-date {
            font-size: 12px;
            color: var(--text-dark);
            opacity: 0.8;
            white-space: nowrap;
        }
        
        .notification-image {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
            border: 2px solid var(--primary-color);
        }
			        
		.notification-emoji {
            font-size: 20px;
            margin-left: 10px;
            position: absolute;
            bottom: 10px;
            right: 10px;
            cursor: pointer;
            transition: transform 0.3s ease, opacity 0.3s ease;
            opacity: 0.8;
        }

        .notification-emoji:hover {
            transform: scale(1.2);
            opacity: 1;
        }
        
        /* Unread Notification Style */
	    .notification-unread {
	        background: rgba(243, 194, 4, 0.25); /* Stronger yellow background */
	        border-left: 6px solid var(--primary-color); /* Thicker yellow border */
	        opacity: 1; /* Fully visible */
	        box-shadow: 0 0 10px rgba(243, 194, 4, 0.3), 0 0 20px rgba(243, 194, 4, 0.2); /* Glow effect */
	        animation: glow 2s infinite alternate; /* Glow animation */
	    }
	
	    /* Read Notification Style */
	    .notification-read {
	        background: rgba(255, 255, 255, 0.05); /* Very subtle background */
	        border-left: 6px solid transparent; /* No border */
	        opacity: 0.7; /* Faded appearance */
	        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
	    }
	
	    /* Hover effects for unread notifications */
	    #notification-list li.notification-unread:hover {
	        background: rgba(243, 194, 4, 0.35); /* Slightly darker yellow on hover */
	        transform: translateY(-5px);
	        box-shadow: 0 8px 20px rgba(243, 194, 4, 0.4); /* Stronger glow on hover */
	    }
	
	    /* Hover effects for read notifications */
	    #notification-list li.notification-read:hover {
	        background: rgba(255, 255, 255, 0.1); /* Slightly lighter background on hover */
	        transform: translateY(-5px);
	        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); /* Subtle shadow on hover */
	    }
	
	    /* Unread indicator */
	    .unread-indicator {
	        width: 10px;
	        height: 10px;
	        background-color: var(--primary-color);
	        border-radius: 50%;
	        position: absolute;
	        left: 10px;
	        top: 50%;
	        transform: translateY(-50%);
	        animation: pulse 1.5s infinite;
	    }
	
	    /* Checkmark for read notifications */
	    .read-indicator {
	        color: #4CAF50; /* Green checkmark */
	        font-size: 16px;
	        margin-left: 10px;
	        opacity: 0.8;
	    }
	
	    /* Animations */
	    @keyframes pulse {
	        0%, 100% {
	            transform: translateY(-50%) scale(1);
	            opacity: 1;
	        }
	        50% {
	            transform: translateY(-50%) scale(1.2);
	            opacity: 0.8;
	        }
	    }
	
	    @keyframes glow {
	        0% {
	            box-shadow: 0 0 10px rgba(243, 194, 4, 0.3), 0 0 20px rgba(243, 194, 4, 0.2);
	        }
	        100% {
	            box-shadow: 0 0 20px rgba(243, 194, 4, 0.4), 0 0 30px rgba(243, 194, 4, 0.3);
	        }
	    }

        /* Animation for emojis */
        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-5px);
            }
        }

        .notification-emoji.bounce {
            animation: bounce 0.5s ease-in-out;
        }

        /* Specific emoji styles */
        .notification-emoji.like {
            color: #ff6b6b; /* Red for likes */
        }

        .notification-emoji.comment {
            color: #4ecdc4; /* Teal for comments */
        }

        .notification-emoji.follow {
            color: #f3c204; /* Yellow for follows */
        }


        /* Empty State */
        #notification-list li.empty-state {
            text-align: center;
            color: var(--text-dark);
            font-style: italic;
            background: transparent;
            box-shadow: none;
        }
        #notification-list li.empty-state:hover {
            transform: none;
            box-shadow: none;
        }

        /* Responsive Design */
        @media screen and (max-width: 768px) {
            .main-content {
                margin-left: 80px;
                width: calc(100% - 80px);
            }
            #notifications {
                margin: 10px;
                padding: 15px;
            }
            #notification-list li {
                flex-direction: column;
                align-items: flex-start;
            }
            .notification-date {
                margin-top: 5px;
            }
        }
        
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
            color: black;
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
</head>
<body>
    <!-- Include the menu -->
    <jsp:include page="menu.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <h1>Notifications</h1>

        <!-- Notifications Section -->
        <div id="notifications">
            <!-- Clear Notifications Button -->
            <button class="clear-notifications-btn" onclick="clearNotifications()">
                <i class="fas fa-trash"></i> Clear Notifications
            </button>

            <h3>Your Notifications</h3>
            <ul id="notification-list">
                <c:choose>
                    <c:when test="${not empty notifications}">
						<c:forEach var="notification" items="${notifications}">
						    <li class="${notification.is_read ? 'notification-read' : 'notification-unread'}">
						        <!-- Profile picture link -->
						        <a href="http://localhost:8080/Storyline/profile.jsp?username=${notification.liked_by}">
						            <img src="${notification.profile_picture}" alt="Profile Picture" class="notification-image">
						        </a>
						        <div class="notification-content">
						            <c:choose>
						                <c:when test="${notification.type == 'like'}">
						                    <!-- Like notification: Redirect to story -->
						                    <a href="readStory.jsp?id=${notification.story_id}" style="text-decoration: none; color: inherit;">
						                        <strong>${notification.liked_by}</strong> liked your story: <strong>${notification.story_title}</strong>
						                    </a>
						                </c:when>
						                <c:when test="${notification.type == 'comment'}">
						                    <!-- Comment notification: Redirect to story -->
						                    <a href="readStory.jsp?id=${notification.story_id}" style="text-decoration: none; color: inherit;">
						                        <strong>${notification.liked_by}</strong> commented on your story: <strong>${notification.story_title}</strong>
						                    </a>
						                </c:when>
						                <c:when test="${notification.type == 'follow'}">
						                    <!-- Follow notification: Redirect to follower's profile -->
						                    <a href="http://localhost:8080/Storyline/profile.jsp?username=${notification.liked_by}" style="text-decoration: none; color: inherit;">
						                        <strong>${notification.liked_by}</strong> started following you.
						                    </a>
						                </c:when>
						                <c:otherwise>
						                    <!-- Default case -->
						                    <strong>${notification.liked_by}</strong> ${notification.message}
						                </c:otherwise>
						            </c:choose>
						        </div>
						        <span class="notification-date">${notification.created_at}</span>
						        <!-- Add enhanced emoji based on notification type -->
						        <c:choose>
						            <c:when test="${notification.type == 'like'}">
						                <a href="readStory.jsp?id=${notification.story_id}" style="text-decoration: none; color: inherit;">
						                    <div class="notification-emoji like bounce">
						                        <i class="fas fa-heart"></i>
						                    </div>
						                </a>
						            </c:when>
						            <c:when test="${notification.type == 'comment'}">
						                <a href="readStory.jsp?id=${notification.story_id}" style="text-decoration: none; color: inherit;">
						                    <div class="notification-emoji comment bounce">
						                        <i class="fas fa-comment"></i>
						                    </div>
						                </a>
						            </c:when>
						            <c:when test="${notification.type == 'follow'}">
						                <a href="http://localhost:8080/Storyline/profile.jsp?username=${notification.liked_by}" style="text-decoration: none; color: inherit;">
						                    <div class="notification-emoji follow bounce">
						                        <i class="fas fa-user-plus"></i>
						                    </div>
						                </a>
						            </c:when>
						        </c:choose>
						    </li>
						</c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li class="empty-state">No new notifications.</li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
    
    <!-- Custom Confirmation Modal -->
    <div id="customConfirm" class="modal">
        <div class="modal-content">
            <p id="confirmMessage">Are you sure?</p>
            <button onclick="confirmAction(true)">OK</button>
            <button onclick="confirmAction(false)">Cancel</button>
        </div>
    </div>

    <script>
	 	// Function to clear notifications
	    let pendingAction = null;
	
	    function showConfirmBox(message, callback) {
	        document.getElementById("confirmMessage").innerText = message;
	        pendingAction = callback; // Store the callback function
	        document.getElementById("customConfirm").style.display = "block";
	    }
	
	    function confirmAction(confirmed) {
	        document.getElementById("customConfirm").style.display = "none";
	        if (confirmed && pendingAction) {
	            pendingAction(); // Execute the stored callback function
	        }
	    }
	
	    function clearNotifications() {
	        showConfirmBox("Are you sure you want to clear all notifications?", function() {
	            fetch('ClearNotificationsServlet', {
	                method: 'POST',
	                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
	            })
	            .then(response => {
	                if (response.ok) {
	                    // Reload the page to reflect the cleared notifications
	                    window.location.reload();
	                } else {
	                    alert("Failed to clear notifications. Please try again.");
	                }
	            })
	            .catch(error => {
	                alert("An error occurred. Please try again.");
	            });
	        });
	    }

        // Add hover and click effects for emojis
        document.querySelectorAll('.notification-emoji').forEach(emoji => {
            emoji.addEventListener('mouseenter', () => {
                emoji.classList.add('bounce');
            });
            emoji.addEventListener('mouseleave', () => {
                emoji.classList.remove('bounce');
            });
        });
        

        function updateNotificationCount() {
            const notificationCountElement = document.querySelector('.notification-count');
            
            if (notificationCountElement) {
                // Add a class to trigger the hide animation
                notificationCountElement.classList.add('hide');
                
                // Wait for the animation to complete, then update the text content
                setTimeout(() => {
                    notificationCountElement.textContent = '0';
                    notificationCountElement.classList.remove('hide');
                }, 300); // Match the duration of the CSS transition
            }
        }

        window.onload = updateNotificationCount;
        
        function markNotificationsAsRead() {
            fetch('NotificationServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            })
            .then(response => {
                if (response.ok) {
                    // Update the notification count in the menu sidebar
                    updateNotificationCount();
                } else {
                    console.error('Failed to mark notifications as read');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }

        // Call the function when the page loads
        window.onload = markNotificationsAsRead;
    </script>
</body>
</html>