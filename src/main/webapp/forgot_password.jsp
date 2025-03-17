<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Forgot Password</title>
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
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        input[type="email"] {
            width: 94%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            color: #333;
            font-family: Times;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #f37c7c;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-family: Times;
        }

        button:hover {
            background-color: #e85f5f;
        }

       
    </style>
</head>
<body>
    <div class="container">
        <h2>Forgot Password</h2>
        <form action="generateToken" method="post">
            <input type="email" name="email" placeholder="Enter your email" required>
            <button type="submit">Get Token</button>
        </form>
    </div>
    
</body>
</html>
