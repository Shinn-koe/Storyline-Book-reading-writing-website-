<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign Up Page</title>
  <!-- Font Awesome for Eye Icons -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Times;
      background-color: #000;
      color: #fff;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background: url('${pageContext.request.contextPath}/resources/images/k.jpg') no-repeat center center fixed;
      background-size: cover;
    }

    .container {
      text-align: center;
    }

    .logo {
      font-size: 2rem;
      font-weight: bold;
      color: #ec9034;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin-bottom: 20px;
      font-family: "Brush Script MT", cursive;
    }

    .logo span {
      background-color: #ec9034;
      color: #fff;
      border-radius: 50%;
      padding: 4px 10px;
      font-size: 1.2rem;
    }

    .form-container {
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      max-width: 300px;
      margin: auto;
      color: black;
    }

    h2 {
      margin-bottom: 15px;
    }

    input {
      width: 90%;
      padding: 12px;
      margin: 10px 0;
      border-radius: 6px;
      border: 1px solid #ccc;
      background-color: white;
      color: black;
      font-size: 14px;
       font-family: Times;
    }

    input::placeholder {
      color: #aaa;
    }

    .password-container {
      position: relative;
      width: 100%;
    }

    .eye-icon {
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      cursor: pointer;
      color: #777;
      font-size: 18px;
    }

    .eye-icon:hover {
      color: #333;
    }

    .error {
      color: red;
      font-size: 12px;
      margin-top: -8px;
      margin-bottom: 8px;
      text-align: left;
      width: 90%;
      margin-left: auto;
      margin-right: auto;
      display: none;
    }

    button {
      width: 100%;
      padding: 12px;
      margin-top: 15px;
      background-color: #ec9034;
      color: #000;
      font-weight: bold;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background-color 0.3s ease;
       font-family: Times;
    }

    button:hover {
      background-color: #ea851f;
    }
  </style>

  <script>
    function validateForm() {
      let isValid = true;
      let name = document.getElementById("name").value.trim();
      let username = document.getElementById("username").value.trim();
      let email = document.getElementById("email").value.trim();
      let password = document.getElementById("password").value.trim();

      let nameError = document.getElementById("nameError");
      let usernameError = document.getElementById("usernameError");
      let emailError = document.getElementById("emailError");
      let passwordError = document.getElementById("passwordError");

      nameError.style.display = "none";
      usernameError.style.display = "none";
      emailError.style.display = "none";
      passwordError.style.display = "none";

      let nameRegex = /^[A-Za-z\s]{3,}$/;
      if (!nameRegex.test(name)) {
        nameError.style.display = "block";
        nameError.innerText = "Name must be at least 3 characters and contain only letters.";
        isValid = false;
      }

      let usernameRegex = /^[a-zA-Z0-9_]{4,15}$/;
      if (!usernameRegex.test(username)) {
        usernameError.style.display = "block";
        usernameError.innerText = "Username must be 4-15 characters and contain only letters, numbers, or underscores.";
        isValid = false;
      }

      let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      if (!emailRegex.test(email)) {
        emailError.style.display = "block";
        emailError.innerText = "Enter a valid email address.";
        isValid = false;
      }

      let passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/;
      if (!passwordRegex.test(password)) {
        passwordError.style.display = "block";
        passwordError.innerText = "Password must be at least 6 characters with one letter, one number, and one special character.";
        isValid = false;
      }

      return isValid;
    }

    function togglePasswordVisibility() {
      let passwordField = document.getElementById("password");
      let eyeIcon = document.getElementById("eye-icon");

      if (passwordField.type === "password") {
        passwordField.type = "text";
        eyeIcon.classList.remove("fa-eye");
        eyeIcon.classList.add("fa-eye-slash");
      } else {
        passwordField.type = "password";
        eyeIcon.classList.remove("fa-eye-slash");
        eyeIcon.classList.add("fa-eye");
      }
    }
  </script>
</head>
<body>
  <div class="container">
    <div class="form-container">
      <div class="logo">
        <div>storyline</div><span>S</span>
      </div>
      <h2>Tell us about yourself!</h2>
      <form role="form" action="insert" method="post" onsubmit="return validateForm()">
        <input type="text" id="name" name="name" placeholder="Name" required>
        <div id="nameError" class="error"></div>

        <input type="text" id="username" name="username" placeholder="Username" required>
        <div id="usernameError" class="error"></div>

        <input type="email" id="email" name="email" placeholder="Email" required>
        <div id="emailError" class="error"></div>

        <div class="password-container">
          <input id="password" type="password" name="password" placeholder="Password" required>
          <i class="fas fa-eye eye-icon" id="eye-icon" onclick="togglePasswordVisibility()"></i>
        </div>
        <div id="passwordError" class="error"></div>

        <button type="submit">Sign up</button>
        <p style="margin-top: 15px; font-size: 14px;">
          Already have an account? <a href="login.jsp" style="color: #ec9034; text-decoration: none;"><b>Log in</b></a>
        </p>
      </form>
    </div>
  </div>
</body>
</html>
