<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
        body {
            margin: 0;
            font-family: Times;
            display: flex;
        }

        /* Sidebar styles */
        .sidebar {
            width: 80px;
            height: 100vh;
            background-color: #1e1e1e;
            color: #fff;
            position: fixed;
            left: 0;
            top: 0;
            padding: 20px 0;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: width 0.3s ease;
            overflow-x: hidden;
        }

        .sidebar:hover {
            width: 250px;
            align-items: flex-start;
            padding-left: 20px;
        }

        /* Logo container */
        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            margin-bottom: 20px;
            transition: justify-content 0.3s;
        }

        .sidebar:hover .logo {
            justify-content: flex-start;
            margin-left:30px;
        }

        .logo span {
            background-color: #f3c204;
            color: #1a202c;
            border-radius: 50%;
            padding: 5px 12px;
            font-size: 1.5rem;
            font-weight: bold;
            margin-right: 10px;
        }

        .logo div {
            display: none;
            font-size: 1.8rem;
            font-weight: bold;
            color: #f3c204;
            font-family: Brush Script MT;
            white-space: nowrap;
        }
        
        .notification-count {
		    transition: opacity 0.3s ease, transform 0.3s ease;
		}
		
		.notification-count.hide {
		    opacity: 0;
		    transform: scale(0);
		}
        
        .notification-count {
		    background-color: red;
		    color: white;
		    border-radius: 50%;
		    padding: 2px 6px;
		    font-size: 12px;
		    margin-left: 5px;
		}

        .sidebar:hover .logo div {
            display: block;
        }

        /* Menu items */
        .menu-item {
            width: 100%;
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-radius: 5px;
            transition: background-color 0.3s;
            white-space: nowrap;
        }

        .menu-item:hover {
            background-color: #2d3748;
        }

        .menu-item a {
            text-decoration: none;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
            justify-content: center;
        }

        .sidebar:hover .menu-item a {
            justify-content: flex-start;
        }

        .menu-item i {
            font-size: 20px;
        }

        .menu-item div {
            display: none;
        }

        .sidebar:hover .menu-item div {
            display: inline;
        }

        /* Write Story button styles */
        .write-box-container {
            margin-top: auto;
            padding: 10px;
            text-align: center;
            width: 100%;
        }

        .write-box-container button {
            width: 80%;
            padding: 10px;
            background-color: #f3c204;
            color: #1a202c;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            font-family: Times;
            transition: background-color 0.3s;
        }

        .write-box-container button:hover {
            background-color: #e0ab03;
        }
        .sidebar:hover .menu-item div {
            display: inline;
        }

        /* Adjust content margin when sidebar expands */
        .main-content {
            margin-left: 80px;
            transition: margin-left 0.3s ease;
            padding: 20px;
            flex: 1;
        }

        .sidebar:hover ~ .main-content {
            margin-left: 250px;
        }
    

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            text-align: center;
        }

        .modal-content h2 {
            margin-top: 0;
        }

        .modal-content button {
            margin: 10px;
            padding: 10px 20px;
            background-color: #f3c204;
            color: #1a202c;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .modal-content button:hover {
            background-color: #e0ab03;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 18px;
            color: #333;
            cursor: pointer;
        }
        .profile-container {
            text-align: center;
            margin-bottom: 20px;
        }

        .profile-container img {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #f3c204;
        }

        .profile-container .profile-name {
            margin-top: 10px;
            font-size: 16px;
            font-weight: bold;
        }
        .sidebar:hover .profile-container img {
        margin-left:70px;
        }
         .sidebar:hover .profile-container  .profile-name {
        margin-left:70px;
        }
    </style>
</head>

<body>
    <div class="sidebar">
        <div class="logo">
            <span>S</span>
            <div>storyline</div>
        </div>
        <div class="profile-container">
            <img src="${sessionScope.profilePicture != null ? sessionScope.profilePicture : 'https://via.placeholder.com/80'}" alt="Profile Picture">
            <div class="profile-name">${sessionScope.name != null ? sessionScope.name : "Guest"}</div>
        </div>
        <div class="menu-item">
            <a href="dashboard.jsp">
                <i class="fas fa-home"></i>
                <div>Home</div>
            </a>
        </div>
        <div class="menu-item">
        <a href="profile.jsp">
                <i class="fas fa-user"></i>
                <div>Profile</div>
            </a>
        </div>
        <div class="menu-item">
            <a href="notifications.jsp">
                <i class="fas fa-bell"></i>
                <div>Notification</div>
                <c:if test="${sessionScope.unreadCount > 0}">
		            <span class="notification-count">${sessionScope.unreadCount}</span>
		        </c:if>            
            </a>
        </div>
        <div class="menu-item">
            <a href="mystory.jsp">
                <i class="fas fa-book-open"></i>
                <div>My Stories</div>
            </a>
        </div>
        <div class="menu-item">
            <a href="library.jsp">
                <i class="fas fa-bars"></i>
                <div>Library</div>
            </a>
        </div>
        <div class="menu-item">
            <a href="browse.jsp">
                <i class="fas fa-globe"></i>
                <div>Browse</div>
            </a>
        </div>
       <div class="menu-item">
            <a href="search.jsp">
                <i class="fas fa-search"></i>
                <div>Search</div>
            </a>
        </div>
        <div class="menu-item">
            <a href="setting.jsp">
                <i class="fas fa-cog"></i>
                <div>Setting</div>
            </a>
        </div>
        <div class="menu-item">
            <a href="login.jsp">
                <i class="fas fa-sign-out-alt"></i>
                <div>Logout</div>
            </a>
        </div>
       <div class="write-box-container">
            <button type="button" onclick="openModal()">Write Story</button>
        </div>
    </div>
     
     
     
     <div id="writeStoryModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Write a Story</h2>
            <button onclick="location.href='newStory.jsp'">Write a New Story</button>
            <button onclick="location.href='mystory.jsp'">My Stories</button>
            <button onclick="location.href='dashboard.jsp'">Back</button>
        </div>
    </div>

    <script>
        // JavaScript for modal behavior
        function openModal() {
            document.getElementById('writeStoryModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('writeStoryModal').style.display = 'none';
        }
    </script>
     
     
</body>
</html>
        