<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.dashboard.utils.DBConnection" %>
<%@ page import="javax.servlet.http.HttpSession" %>
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
 	// Retrieve the user's coin balance from the database
    int total_coins = 0; // Default balance
    int clickCount = 0; // Default click count
    try {conn = DBConnection.getConnection(); 
        String sql = "SELECT total_coins FROM users WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();
        
        if (rs.next()) {
        	total_coins = rs.getInt("total_coins"); // Assuming the column name is total_coins
        }
        
     	// Query to retrieve click_count
        String sqlClicks = "SELECT click_count FROM user_clicks WHERE user_id = ?";
        PreparedStatement stmtClicks = conn.prepareStatement(sqlClicks);
        stmtClicks.setInt(1, userId);
        ResultSet rsClicks = stmtClicks.executeQuery();
        
        if (rsClicks.next()) {
            clickCount = rsClicks.getInt("click_count"); // Assuming the column name is click_count
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
        response.getWriter().println("Error retrieving coin balance: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Earn Coins</title>
	
	<!-- Font Awesome CDN -->
  	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  	
  	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  	
  	<style>
		body {
			margin: 0;
			font-family: Arial, sans-serif;
			background-color: #141414;
			color: white;
		}
		
		.main-content {
			flex: 1;
			padding: 20px;
			margin-left: 250px;
		}
		
		.own-coins {
			background-color: #636363;
			border-radius: 5px;
			margin: 20px;
			padding: 50px;
			width: 87%;
		}
		
		.own-coins .current-total-coins {
			position: absolute;
			top: 29%;
		}
		
		.own-coins .current-total-coins i {
			color: #f3c204;
			font-size: 2rem;
			margin-right: 8px;
		}
		
		.own-coins .current-total-coins span {
			font-weight: bold;
			font-size: 23px;
			color: #fff;
		}
		
		.tabs {
			display: flex;
			margin-bottom: 20px;
		}
		
		.tabs a {
			padding: 10px 20px;
			text-decoration: none;
			color: #fff;
			border-bottom: 2px solid transparent;
			font-size: 16px;
		}
		
		.tabs a.active {
			color: #ffce00;
			border-bottom: 2px solid #ffce00;
		}
		
		.watch-video-ads {
			background-color: #636363;
			border-radius: 5px;
			margin: 20px;
			padding: 65px 50px;
			width: 87%;
		}
		
		.watch-video-ads .video {
			position: absolute;
			font-size: 28px;
			top: 42%;
			right: 7%;
		}
		
		.watch-video-ads .video-ads {
			position: absolute;
			top: 41%;
			line-height: 0.18em;
		}
		
		.watch-video-ads .video-link {
			background-color: #919191;
			border: 2px solid white;
			border-radius: 30px;
			color: white;
			display: inline-block;
			padding: 5px;
			text-align: center;
			text-decoration: none;
			font-family: Times;
			cursor: pointer;
			position: absolute;
			top: 50%;
			width: 20%;
		}
		
		.ads-popup {
			position: fixed;
		    visibility: hidden;
		    opacity: 0;
		    z-index: 1;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    top: 0;
		    left: 0;
		    right: 0;
		    bottom: 0; /* Make the popup cover the entire viewport */
		}
		
		.ads-popup.active {
			visibility: visible;
			opacity: 1;
		}
		
		.ads-popup video {
			position: absolute; /* Changed to absolute to position correctly */
		    top: 0;
		    left: 0;
		    width: 100vw; /* Full width of the viewport */
		    height: 100vh; /* Full height of the viewport */
		    outline: none;
		    box-shadow: 0 0 10px 10px rgba(255, 255, 255, 0.4);
		    object-fit: cover; /* Ensures the video covers the area without distortion */
		}
		
		#icon {
			position: absolute;
			top: 10px;
			right: 20px;
			cursor: pointer;
			display: none;
			font-size: 35px;
		}
		
		.modal {
			display: none;
			position: fixed;
			z-index: 1;
			left: 0;
			top: 0;
			width: 100%;
			height: 100%;
			background-color: rgba(0, 0, 0, 0.5);
		}
		
		.modal-content {
			background-color: white;
			margin: 15% auto;
			padding: 20px;
			border-radius: 10px;
			width: 300px;
			text-align: center;
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
  	<script>
  		let timeoutId;
  		// Watch Video after clicking button
  		function show() {
  			var popup = document.querySelector(".ads-popup");
  			var video = document.querySelector("video");
  			const icon = document.getElementById("icon");
  			popup.classList.toggle("active");
  			
  			if (popup.classList.contains("active")) {
  		        video.play();
  		      	clearTimeout(timeoutId);
  		      	icon.style.display = "none";
	  		    timeoutId = setTimeout(function() {
	  	            icon.style.display = "inline-block";
	  	        }, 10000);
  		    } else {
  		        video.pause(); // Pause the video when closing the popup
  		        video.currentTime = 0; // Optionally, reset the video to the beginning
  		    }
  		}
  		// Call this function to initialize the close icon visibility
  		function initializeCloseIcon() {
  		    const icon = document.getElementById("icon");
  		    icon.style.display = "none"; // Hide the icon initially
  		}
  		// Call the initialize function on page load
  		window.onload = initializeCloseIcon;
  		function onVideoLinkClick() {
  		    show(); // Call show function to display the popup and play the video
  		}
        function openModal() {
            document.getElementById("customModal").style.display = "block";
        }
        function closeModal() {
            document.getElementById("customModal").style.display = "none";
        }
  	</script>
</head>
<body>
	
	<!-- Side bar -->
	<jsp:include page="menu.jsp" />
	
	<div class="content">
		<div class="ads-popup"> 
		    <video id="myVideo">
		        <source src="resources/images/watchVideo.mp4" type="video/mp4">
		    </video>
		    <i id="icon" class="fa fa-times" onclick="show();"></i>
		</div>

		<!-- Main Content -->
		<div class="main-content">
			<header>
				<h1>Coin Shop</h1>
	        </header>
	        
	        <nav class="tabs">
	        	<a href="earnCoin.jsp" class="active">Earn Coins</a>
	        </nav>
	        
	        <form action="earnCoin" method="post"> 
		        <div class="own-coins">
		        	<div class="current-total-coins">
		        		<i class="fas fa-coins"></i>
		        		<span id="ownCoins"> <%= total_coins %> </span>
		        	</div>
		        </div>
		        
		        <div class="watch-video-ads">
		        	<div class="video-ads">
		        		<h2>Video ads</h2>
		        		<small>Watch ads to earn Bonus Coins</small>
		        	</div>
		        	<div class="video">
		        		<img src="resources/images/video.svg" alt="video" width="60" height="60">
		        	</div>
		        	
					<a href="#" onclick="earnCoin(); onVideoLinkClick();" id="videoLink" class="video-link"> Earn up to 10 Coins daily </a>
					
		        </div>
		        
		
			</form>
	 	</div>
 	
	</div>
	<!-- Custom Confirmation Modal -->
    <div id="customConfirm" class="modal">
        <div class="modal-content">
            <p id="confirmMessage">Are you sure?</p>
            <button onclick="confirmAction(true)">OK</button>
            
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
        background-color: #fbc531;
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
        let clickCount = <%= clickCount %>;
        const maxClicks = 10;
        const userId = <%= userId %>;
        
     	// Disable link if user already reached max clicks
        window.onload = function() {
            if (clickCount >= maxClicks) {
                disableVideoLink();
            }
        };

        function earnCoin() {
            if (clickCount < maxClicks) {
                let ownCoinsElement = document.getElementById("ownCoins");
                let currentCoins = parseInt(ownCoinsElement.textContent);
                
                ownCoinsElement.textContent = currentCoins + 1;
                clickCount++;
                
             // Send request to update the total_coins in the database
                fetch("UpdateCoinsServlet", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "userId=" + userId
                })
                .then(response => response.text())
                .then(data => console.log(data))
                .catch(error => console.error("Error:", error));


                if (clickCount >= maxClicks) {
                    disableVideoLink();
                    showConfirmBox("You have already collected the daily maximum of 10 coins!");
                }
            }
        }
        
     	// Function to disable the video link
        function disableVideoLink() {
            let videoLink = document.getElementById("videoLink");
            videoLink.style.pointerEvents = "none";
            videoLink.style.opacity = "0.5";
        }
     
     	// Reset click count every 24 hours
        function resetClickCount() {
            fetch("ResetClickVideoCountServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "userId=" + userId
            })
            .then(response => response.text())
            .then(data => {
                clickCount = 0; // Reset local click count
                let videoLink = document.getElementById("videoLink");
                videoLink.style.pointerEvents = "auto";
                videoLink.style.opacity = "1";
                console.log(data);
            })
            .catch(error => console.error("Error:", error));
        }

        setInterval(resetClickCount, 86400); // Reset every 24 hours
    </script>
</body>
</html>
  	