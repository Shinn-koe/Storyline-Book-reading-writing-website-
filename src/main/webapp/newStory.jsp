<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write a New Story</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color:white;
        }
        
        .sidebar {
            width: 250px;
            height: 100vh;
            background-color: #1e1e1e; /* Dark mode */
            color: #fff;
            position: fixed;
            left: 0;
            top: 0;
            padding: 20px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .logo {
            font-size: 2rem;
            font-weight: bold;
            color: #f3c204;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            font-family: 'Brush Script MT', cursive;
        }

        .logo span {
            background-color: #f3c204;
            color: #1a202c;
            border-radius: 50%;
            padding: 4px 10px;
            font-size: 1.2rem;
        }

        .menu-item {
            display: flex;
            align-items: center;
            margin: 10px 0;
            padding: 10px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .menu-item:hover {
            background-color: #2d3748;
        }

        .menu-item a {
            text-decoration: none;
            color: #fff;
            display: flex;
            align-items: center;
            width: 100%;
        }

        .menu-item i {
            margin-right: 10px;
            font-size: 18px;
        }

        .menu-item .badge {
            margin-left: auto;
            background-color: #e53e3e;
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
        }

        .story-form-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            width: 500px;
            margin-left: 260px; /* Offset for the sidebar */
        }

        .story-form-container h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-group textarea {
            resize: none;
        }

        .form-group button {
            width: 100%;
            padding: 10px;
            background-color: #1e1e1e;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .form-group button:hover {
            background-color: #333;
        }

        .cover-preview {
            width: 100%;
            max-height: 300px;
            object-fit: cover;
            border-radius: 5px;
            margin-top: 10px;
            display: none; /* Hidden initially */
        }
    </style>
</head>
<body>

    <%@ include file="menu.jsp" %>


<div class="story-form-container">
    <h2>Create Your Story</h2>
    <form action="StoryServlet" method="POST" enctype="multipart/form-data">

        <div class="form-group">
            <label for="cover">Add a Cover</label>
            <input type="file" id="cover" name="cover" accept="image/*" onchange="previewImage(event)">
            <img id="coverPreview" class="cover-preview" alt="Cover Preview">
        </div>
        <div class="form-group">
            <label for="title">Title</label>
            <input type="text" id="title" name="title" placeholder="Enter your story title" required>
        </div>
        
        <div class="form-group">
            <label for="category">Category</label>
            <select id="category" name="category" required>
                <option value="fiction">Fiction</option>
                <option value="non-fiction">Non-Fiction</option>
                <option value="fantasy">Fantasy</option>
                <option value="romance">Romance</option>
                <option value="thriller">Thriller</option>
                 <option value="action">Action</option>
                <option value="adventure">Adventure</option>
                <option value="chickLit">ChickLit</option>
                <option value="classics">Classics</option>
                <option value="knowledge">Knowledge</option>
                 <option value="general">General</option>
                <option value="historical">Historical</option>
                <option value="horror">Horror</option>
                <option value="humor">Humor</option>
                <option value="mystery">Mystery</option>
                 <option value="paranormal">Paranormal</option>
                <option value="poetry">Poetry</option>
                <option value="random">Random</option>
                <option value="science">Science</option>
                <option value="short">Short</option>
                 <option value="spiritual">Spiritual</option>
                <option value="teen">Teen</option>
                <option value="vampire">Vampire</option>
                <option value="werewolf">Werewolf</option>
                <option value="hot">Hot</option>
            </select>
        </div>
        <div class="form-group">
            <button type="submit">Next</button>
        </div>
    </form>
</div>

<script>
    function previewImage(event) {
        const file = event.target.files[0];
        const preview = document.getElementById('coverPreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block'; // Show the preview
            };
            reader.readAsDataURL(file);
        }
    }
</script>
</body>
</html>
