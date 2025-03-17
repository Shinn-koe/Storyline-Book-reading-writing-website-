<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.dashboard.servlets.PartDAO" %>
<%@ page import="com.dashboard.servlets.storyPart" %>
<%@ page import="java.util.*" %>

<%
    PartDAO partDAO = new PartDAO();
    String idParam = request.getParameter("id");
    int partId = (idParam != null) ? Integer.parseInt(idParam) : 0;

    storyPart part = partDAO.getPartById(partId);
    if (part == null) {
        response.sendRedirect("myPart.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write Part - Storyline</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://cdn.tiny.cloud/1/slool38ypci64f6uv0b6fx6lx4zuzee0ydu7wuhh0b0m86rf/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
    <script>
        tinymce.init({
            selector: '#storyContent',
            plugins: 'lists link image table code help autosave',
            toolbar: 'undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist | link image | code',
            menubar: false,
            height: 500,
        });
    </script>
    <style>
        body { background-color: #1e1e1e; }
        .btn-primary {
            border: none;
            background-color: #ffce00;
            color: #000;
        }
        .btn-primary:hover {
            background-color: #e6b800;
            color: #000;
        }
        .form-control:focus {
            border: none !important;
            outline: none !important;
            box-shadow: none !important;
        }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />
    <div class="container col-md-7">
        <div class="card">
            <div class="card-body">
            
		        <form action="UpdatePartServlet" method="post">
		            <input type="hidden" name="id" value="<%= part.getId() %>">
		            <input type="hidden" name="story_id" value="<%= part.getStoryId() %>">
		            
		            <div class="row d-flex justify-content-center">
                    	<h2><input type="text" name="title" style="text-align: center; " class="border-0" value="<%= part.getTitle() %>" required /></h2>
                    </div>
            
            		<fieldset class="form-group">
                        <textarea id="storyContent" name="content" class="form-control w-100" style="height: 60vh;"><%= part.getContent() %></textarea>
                    </fieldset>
            
            		<fieldset class="form-group">
                        <label>Status</label>
                        <select name="status" class="form-control" id="statusSelect">
                            <option value="draft" <%= part.getStatus().equals("draft") ? "selected" : "" %>>Draft</option>
                            <option value="published" <%= part.getStatus().equals("published") ? "selected" : "" %>>Published</option>
                        </select>
                    </fieldset>
					
					<fieldset class="form-group" id="paymentOptions" style="display: none;">
					    <label>Payment</label>
					    <select name="payment" class="form-control">
					        <option value="free" <%= part.getPayment().equals("free") ? "selected" : "" %>>Free</option>
					        <option value="paid" <%= part.getPayment().equals("paid") ? "selected" : "" %>>Paid</option>
					    </select>
					</fieldset>
					
					<button id="cancel" name="cancel" class="btn btn-default" onclick="history.back()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save</button>
            
       			</form>
            </div>
        </div>
    </div>
    
    <script>
	    document.addEventListener("DOMContentLoaded", function() {
	        var statusSelect = document.getElementById("statusSelect");
	        var paymentOptions = document.getElementById("paymentOptions");
	
	        function togglePaymentOptions() {
	            if (statusSelect.value === "published") {
	                paymentOptions.style.display = "block";
	            } else {
	                paymentOptions.style.display = "none";
	            }
	        }
	
	        // Run on page load (in case of edit mode)
	        togglePaymentOptions();
	
	        // Add event listener for dropdown change
	        statusSelect.addEventListener("change", togglePaymentOptions);
	    });
	</script>
</body>
</html>
