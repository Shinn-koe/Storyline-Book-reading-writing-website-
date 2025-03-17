<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write Story</title>
    <script src="https://cdn.tiny.cloud/1/2lkqpntqnmfw1julymytyhh86mp4o1bpjy1pxaip43pkn108/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
    <script>
        tinymce.init({
            selector: '#storyContent',
            plugins: 'lists link image table code help autosave',
            toolbar: 'undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist | link image | code',
            menubar: false,
            height: 400,
            autosave_interval: "30s", // Auto-save feature
        });
    </script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: black;
            color: white;
        }

        .container {
            background-color: white;
            color: black;
            padding: 20px;
            margin: 50px auto;
            border-radius: 10px;
            max-width: 800px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }

        h2 {
            text-align: center;
        }

        .button-group {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        button {
            padding: 10px 20px;
            background-color: #1e1e1e;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #333;
        }

        .save-button {
            background-color: #007bff;
        }

        .save-button:hover {
            background-color: #0056b3;
        }

        .publish-button {
            background-color: #28a745;
        }

        .publish-button:hover {
            background-color: #218838;
        }
        .back-button {
            background-color: #6c757d;
        }

        .back-button:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <%@ include file="menu.jsp" %>

<div class="container">
    <h2>Description</h2>
    <form action="StoryServlet" method="POST">
        <!-- Hidden fields to store title, description, and other info -->
       <input type="hidden" name="storyId" value="<%= request.getParameter("storyId") %>">
        <textarea id="storyContent" name="storyContent"></textarea>
        <div class="button-group">
            <button type="submit" name="action" value="save" class="save-button">Save</button>
            <button type="submit" name="action" value="publish" class="publish-button">Publish</button>
        </div>
    </form>
    <div class="button-group">
        <!-- Back Button: Change the URL here if needed -->
        <button onclick="window.history.back()" class="back-button">Back</button>
    </div>
</div>
</body>
</html>
