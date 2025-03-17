<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.dashboard.servlets.storyPart" %>
<%@ page import="com.dashboard.servlets.PartDAO" %>
<%@ page import="com.dashboard.servlets.StoryDAO" %>
<%@ page import="com.dashboard.servlets.Story" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
	StoryDAO storyDAO = new StoryDAO();
	PartDAO partDAO = new PartDAO();
	HttpSession sessionObj = request.getSession();
	Integer storyId = (Integer) sessionObj.getAttribute("storyId");
	if (storyId == null) {
        out.println("<script>alert('Story ID is missing. Please go back and try again.');</script>");
    } else {
        List<storyPart> publishPart = partDAO.selectPartsByStatus(storyId);
        request.setAttribute("publishPart", publishPart);
        
     	// Fetch the story title
        Story story = storyDAO.getStoryById(storyId);
        if (story != null) {
            request.setAttribute("storyTitle", story.getTitle());
        } else {
            request.setAttribute("storyTitle", "Unknown Story");
        }
    }
   
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Published Part - Storylines</title>
</head>
<style>
	body {
        font-family: Arial, sans-serif;
        background-color: #1e1e1e;
        color: #fff;
        margin: 0;
        padding: 0;
    }
    .container {
    	position: relative;
        width: 50%;
        height: 85%;
        margin: 50px auto;
        background: #2c2c2c;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0px 0px 10px rgba(255, 255, 255, 0.1);
        overflow-y: scroll; /* Add the ability to scroll */
        -ms-overflow-style: none;
  		scrollbar-width: none;
    }
	.container::-webkit-scrollbar {
    	display: none;
    }
    h2 {
        text-align: center;
        color: #ffce00;
    }
    .form-container {
    	position: absolute;
		top: 25%;
		right: 3%;
    }
    .form-container .button {
        background-color: #ffce00;
        color: #000;
        border: none;
        font-weight: bold;
        padding: 5px 10px;
        border-radius: 5px;
        cursor: pointer;
        transition: background 0.3s;
        float: right;
        text-decoration: none;
    }
    .form-container .button:hover {
        background-color: #e6b800;
        color: #fff;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        table-layout: auto;
    }
    th, td {
        padding: 10px;
        border-bottom: 1px solid #444;
    }
    .edit-delete a:link, a:visited {
	  background-color: #343132;
	  color: white;
	  padding: 9px 18px;
	  text-align: center;
	  text-decoration: none;
	  display: inline-block;
	}
	.edit-delete a:hover, a:active {
	  	background-color: #2A2728;
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
	.publish-title {
		text-decoration: none;
		color: inherit;
	}
	.publish-title:visited, .publish-title:link {
        color: inherit; /* Disable visited and unvisited link color */
    }
</style>
<body>
    <jsp:include page="menu.jsp" />
    
    <div class="container">
    	<div class="title-container">
        <h2> <span style="color: #ffce00;">${storyTitle}</span> - Edit Parts </h2>
        <nav class="tabs">
        	<a href="publishPart.jsp" class="active">Published</a>
        	<a href="myPart.jsp">All Parts</a>
        </nav>
        <div class="form-container">
            <form action="writePart.jsp" method="get">
            	<input type="hidden" name="story_id" value="${story.id}">
                <button type="submit" class="button"> + New Part </button>
            </form>
        </div>
        </div>
        
        <table>
            <c:forEach var="part" items="${publishPart}">
                <tr>
                    <td>
                    	<a href="readPartPreview.jsp?id=${part.id}" class="publish-title">
                    		<c:out value="${part.title}" />
                    	</a>
                    	<small>
                    		<c:out value=" ${part.payment == 'paid' ? '(paid)' : '(free)'}" />
                    	</small>
                    </td>
                    
                    <td class="edit-delete">
                    	<a href="editPart.jsp?id=${part.id}">Edit</a>
						<a href="#" onclick="deletePart(${part.id})">Delete</a>

					</td>
                </tr>
            </c:forEach>
        </table>
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

function deletePart(partId) {
    showConfirmBox("Are you sure you want to delete this part?", function() {
        window.location.href = "DeletePartServlet?id=" + partId;
    });
}
</script>
</body>
</html>