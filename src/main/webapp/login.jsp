<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login Page</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet"> <!-- Font Awesome for eye icon -->
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Times;
      background: url('${pageContext.request.contextPath}/resources/images/k.jpg') no-repeat center center fixed;
      background-size: cover;
      color: #fff;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .container {
      text-align: center;
      max-width: 400px;
      width: 100%;
    }

    .logo {
      font-size: 2.5rem;
      font-weight: bold;
      color: #ec9034;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin-bottom: 30px;
      font-family: 'Brush Script MT', cursive;
    }

    .logo span {
      background-color: #ec9034;
      color: #fff;
      border-radius: 50%;
      padding: 4px 12px;
      font-size: 1.5rem;
    }

    .form-container {
      background-color: white;
      padding: 30px;
      border-radius: 12px;
      max-width: 400px;
      margin: auto;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
      color:black;
    }

    h2 {
      margin-bottom: 20px;
      font-size: 1.8rem;
      color: black;
      font-weight: 600;
    }

    input {
      width: 90%;
      padding: 12px;
      margin: 10px 0;
      border-radius: 8px;
      border: 1px solid #444;
      background-color: white;
      color: black;
      font-size: 16px;
      font-family: Times;
    }

    input::placeholder {
      color: #aaa;
    }

    button {
      width: 90%;
      padding: 12px;
      margin-top: 15px;
      background-color: #ec9034;
      color: #000;
      font-weight: bold;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-family: Times;
    }

    button:hover {
      background-color: #ea851f;
    }

    .error-message {
      color: red;
      font-size: 14px;
      margin-bottom: 10px;
    }

    .eye-icon {
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      cursor: pointer;
      color: #aaa;
    }

    .password-container {
      position: relative;
      width: 100%;
    }

    .form-footer {
      margin-top: 20px;
      font-size: 14px;
      color: black;
    }

    .form-footer a {
      color: #ec9034;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <div class="container">
   
    <div class="form-container">
     <div class="logo">
      <div>storyline</div><span>S</span>
    </div>
      <h2>Welcome Back!</h2>
      <form action="login" method="post">
        <!-- Display error message if present -->
        <c:if test="${not empty errorMessage}">
          <p class="error-message">${errorMessage}</p>
        </c:if>
        <input type="email" name="email" placeholder="Email" required>
        
        <!-- Password container with eye icon toggle -->
        <div class="password-container">
          <input id="password" type="password" name="password" placeholder="Password" required>
          <i class="fas fa-eye eye-icon" id="eye-icon" onclick="togglePasswordVisibility()"></i>
        </div>

        <button type="submit">Login</button>
        <p class="form-footer">
          Don't have an account? <a href="insert.jsp"><b>Sign up</b></a>
        </p>
        <p class="form-footer">
        <a href="forgot_password.jsp" style="color: #ec9034; text-decoration: none;"><b>Forgot Password?</b></a>
       </p>
        
      </form>
    </div>
  </div>

  <script>
    function togglePasswordVisibility() {
      var passwordField = document.getElementById('password');
      var eyeIcon = document.getElementById('eye-icon');

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
</body>
</html>
