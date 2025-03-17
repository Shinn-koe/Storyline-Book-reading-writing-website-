<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile & Account</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #121212;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Times;
        }

        .container {
            width: 30%;
            background-color: #1e1e1e;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

.container:hover {
            transform: scale(1.02);
            box-shadow: 0 8px 32px rgba(243, 194, 4, 0.3);
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }

        .header h1 {
            font-size: 24px;
            margin: 0;
        }

        .images {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .image {
            width: 48%;
            text-align: center;
        }

        .image img {
            width: 100%;
            max-width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #f1c40f;
        }

        .image a {
            margin-top: 10px;
            display: block;
            font-size: 14px;
            color: #f1c40f;
            text-decoration: none;
            cursor: pointer;
        }

        .image a:hover {
            text-decoration: underline;
        }

        .details {
            margin-bottom: 30px;
            margin-right: 20px;
            font-family: Times;
        }

        .details div {
            margin-bottom: 15px;
        }

        .details label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .details input {
            width: 100%;
            padding: 8px;
            border: 1px solid #444;
            border-radius: 5px;
            background-color: #2c2c2c;
            color: white;
            font-size: 14px;
            font-family: Times;
        }

        .submit-btn {
            text-align: center;
        }

        .submit-btn button {
            background-color: #f1c40f;
            color: black;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            font-family: Times;
        }

        .submit-btn button:hover {
            background-color: #e2b607;
        }

        input[type="file"] {
            display: none;
        }
    </style>
</head>
<body>
<%@ include file="menu.jsp"%>
<%
    // Retrieve user details from the session
    String name = (String) session.getAttribute("name");
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    String password = (String) session.getAttribute("password");
    String bio = (String) session.getAttribute("bio");
    String profilePicture = (String) session.getAttribute("profilePicture");
    String coverPicture = (String) session.getAttribute("coverPicture");

    // Default placeholders if no images exist
    if (profilePicture == null || profilePicture.isEmpty()) {
        profilePicture = "https://via.placeholder.com/100";
    }
    if (coverPicture == null || coverPicture.isEmpty()) {
        coverPicture = "https://via.placeholder.com/100";
    }
%>

    <div class="container">
        <div class="header">
            <h1>Profile & Account</h1>
        </div>
        <form action="updateProfile" method="post" enctype="multipart/form-data">
            <!-- Profile & Cover Picture -->
            <div class="images">
                <div class="image">
                    <img src="<%= profilePicture %>" alt="Profile picture" id="profilePreview">
                    <a onclick="document.getElementById('profilePicture').click()">Change profile photo</a>
                    <input type="file" name="profilePicture" id="profilePicture" accept="image/*" onchange="previewImage(event, 'profilePreview')">
                </div>
                <div class="image">
                    <img src="<%= coverPicture %>" alt="Cover picture" id="coverPreview">
                    <a onclick="document.getElementById('coverPicture').click()">Change cover photo</a>
                    <input type="file" name="coverPicture" id="coverPicture" accept="image/*" onchange="previewImage(event, 'coverPreview')">
                </div>
            </div>

            <!-- Editable Details -->
            <div class="details">
                <div>
                    <label for="fullname">Name</label>
                    <input type="text" id="name" name="name" value="<%= (name != null) ? name : "" %>">
                </div>
                <div>
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" value="<%= (username != null) ? username : "" %>" readonly>
                </div>
                <div>
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<%= (email != null) ? email : "" %>">
                </div>
                <div>
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" value="<%= (password != null) ? password : "" %>">     
                </div>
             <div>
             <label for="bio">Bio</label>
             <input type="text" id="bio" name="bio" value="<%= (bio != null) ? bio : "" %>">
             </div>

            <!-- Submit Button -->
            <div class="submit-btn">
                <button type="submit">Save Changes</button>
            </div>
        </form>
    </div>
    </div>

    <script>
    document.getElementById("profilePicture").addEventListener("change", function (event) {
        previewImage(event, "profilePreview");
    });

    document.getElementById("coverPicture").addEventListener("change", function (event) {
        previewImage(event, "coverPreview");
    });

    function previewImage(event, previewId) {
        const reader = new FileReader();
        reader.onload = function () {
            document.getElementById(previewId).src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }

        
    </script>
</body>
</html>
