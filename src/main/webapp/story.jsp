<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Story Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #121212;
            color: #fff;
        }
        header {
            background-color: #ffe4b5;
            padding: 15px;
            display: flex;
            align-items: center;
        }
        header img {
            height: 40px;
            margin-right: 10px;
        }
        header h1 {
            font-size: 24px;
            color: #000;
        }
        .container {
            max-width: 1200px;
            padding: 20px;
        }
        .story-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 2px solid #ffcc66;
            padding-bottom: 15px;
            margin-bottom: 20px;
            margin-left: 600px ;
        }
        .story-header img {
            height: 150px;
            border-radius: 10px;
        }
        .story-header .info {
            flex-grow: 1;
            margin-left: 20px;
        }
        .story-header h2 {
            font-size: 28px;
            margin: 0;
        }
        .story-header .stats {
            margin: 10px 0;
            font-size: 16px;
        }
        .story-header button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #f3c204;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-family: Times;
            
        }
        .story-header button:hover {
            background-color: #ffcc66;
        }
        .content {
            display: flex;
            gap: 20px;
            width: 100%;
            margin-left: 285px ;
        }
        .reviews, .table-of-contents {
            flex: 1;
            border: 2px solid #ffcc66;
            border-radius: 10px;
            padding: 15px;
        }
        .reviews .review {
            margin-bottom: 15px;
            border-bottom: 1px solid #555;
            padding-bottom: 10px;
        }
        .table-of-contents h3 {
            margin-bottom: 10px;
            font-size: 20px;
            color: #ffe4b5;
        }
        .table-of-contents ul {
            list-style: none;
            padding: 0;
        }
        .table-of-contents li {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #555;
        }
        .icon {
            font-size: 16px;
            vertical-align: middle;
        }
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            vertical-align: middle;
            margin-right: 10px;
        }
        .table-of-contents a {
            margin-top: 10px;
            display: block;
            font-size: 14px;
            color: #f1c40f;
            text-decoration: none;
            cursor: pointer;
        }

        .table-of-contents a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%@ include file="menu.jsp"%>
    <div class="container">
        <!-- Story Header -->
        <div class="story-header">
            <img src="image/3.jpg" alt="Story Thumbnail">
            <div class="info">
                <h2>Story name</h2>
                <div class="stats">
                   <i class="fas fa-eye"></i> Reads: 10.8K | <i class="fas fa-star"></i> Votes: 5K |  <i class="fas fa-tasks"></i> Parts: 10
                </div>
                <a href="storypart.jsp"><button>Start reading </button></a>  <button><b>+</b></button>
            </div>
        </div>

        <!-- Content Section -->
        <div class="content">
            <!-- Reviews Section -->
            <div class="reviews">
                <h3>Reviews</h3>
                <div class="review">
                    <img src="image/2.jpg" alt="User Avatar" class="avatar">
                    <strong>username</strong>
                    <p>Story review</p>
                </div>
            </div>

            <!-- Table of Contents -->
            <div class="table-of-contents">
                <h3>Table of Contents</h3>
                <ul>
                    <li> <a href="#">Chapter 1</a> <span>Date</span></li>
                    <li> <a href="#">Chapter 2</a><span>Date</span></li>
                    <li> <a href="#">Chapter 3</a> <span>Date</span></li>
                    <li> <a href="#">Chapter 4 </a><span>Date</span></li>
                    <li> <a href="#">Chapter 5 </a><span>Date</span></li>
                    <li> <a href="#">Chapter 6 </a><span>Date</span></li>
                    <li> <a href="#">Chapter 7 </a><span>Date</span></li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>
