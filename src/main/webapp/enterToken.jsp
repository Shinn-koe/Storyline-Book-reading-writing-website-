<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Enter Token and New Password</title>
    <!-- Font Awesome for Eye Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        /* General Styles */
        body {
            font-family: Times;
            background-color: #f4f7fc;
            background: url('${pageContext.request.contextPath}/resources/images/Design.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .input-container {
            position: relative;
            width: 100%;
            margin: 15px 0;
        }

        input[type="email"],
        input[type="password"],
        input[type="text"] {
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            color: #333;
            box-sizing: border-box;
            font-family: Times;
        }

        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="email"]:focus {
            border-color: #4CAF50;
            outline: none;
        }

        /* Eye icon */
        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #777;
            font-size: 18px;
        }

        .toggle-password:hover {
            color: #333;
        }

        button {
            width: 100%;
            padding: 15px;
            background-color: #f37c7c;
            border: none;
            color: white;
            font-size: 18px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-family: Times;
        }

        button:hover {
            background-color: #e85f5f;
        }

        .error {
            color: red;
            font-size: 12px;
            margin-top: -8px;
            margin-bottom: 8px;
            text-align: left;
            width: 80%;
            margin-left: auto;
            margin-right: auto;
            display: none;
        }
    </style>

    <script>
        function togglePassword() {
            let passwordField = document.getElementById("password");
            let eyeIcon = document.getElementById("eye-icon");

            if (passwordField.type === "password") {
                passwordField.type = "text";
                eyeIcon.classList.remove("fa-eye");
                eyeIcon.classList.add("fa-eye-slash"); // Show closed eye
            } else {
                passwordField.type = "password";
                eyeIcon.classList.remove("fa-eye-slash");
                eyeIcon.classList.add("fa-eye"); // Show open eye
            }
        }

        function validateForm() {
            let isValid = true;
            let passwordField = document.getElementById("password");
            let password = passwordField.value.trim();
            let passwordError = document.getElementById("passwordError");

            let passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/;

            passwordError.style.display = "none";
            passwordError.innerText = "";

            if (!passwordRegex.test(password)) {
                passwordError.style.display = "block";
                passwordError.style.color = "red";
                passwordError.innerText = "Password must be at least 6 characters with one letter, one number, and one special character.";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Enter Token and New Password</h2>
        <form action="resetPassword" method="post" onsubmit="return validateForm()">
            <input type="email" name="email" value="${param.email}" placeholder="Enter your email" required>
            <input type="text" name="token" value="${param.token}" placeholder="Enter your reset token" readonly required>

            <!-- Password input with Font Awesome eye icon -->
            <div class="input-container">
                <input type="password" id="password" name="password" placeholder="Enter new password" required>
                <i class="fa fa-eye toggle-password" id="eye-icon" onclick="togglePassword()"></i>
            </div>

            <div id="passwordError" class="error"></div>
            <button type="submit">Update Password</button>
        </form>
    </div>
</body>
</html>
