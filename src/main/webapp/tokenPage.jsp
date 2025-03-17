<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Your Token</title>
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
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        p {
            font-size: 16px;
            color: #555;
            margin-bottom: 20px;
        }

        .token {
            display: inline-block;
            padding: 10px;
            background-color: #e0e0e0;
            border-radius: 4px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        button {
            width: 81%;
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
        <h2>Your Reset Token</h2>
        <p>Your reset token is:</p>
        <div class="token"><strong>${resetToken}</strong></div>

        <form action="enterToken.jsp" method="get">
            <input type="hidden" name="token" value="${resetToken}">
            <button type="submit">Enter Token and Reset Password</button>
        </form>
    </div>
    
</body>
</html>
