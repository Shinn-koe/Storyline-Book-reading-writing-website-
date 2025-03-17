<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Selection</title>
    <style>
        body {
            background-color: #141210;
            color: #ffb800;
            text-align: center;
            font-family: Arial, sans-serif;
            
        }
        h1 {
            margin-bottom: 20px;
        }
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
            max-width: 800px;
            margin: auto;
           
        }
        .category-button {
            background-color: white;
            color: black;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
             font-family:Times;
        }
        .category-button:hover {
            background-color: #f3c204;
        }
        .content {
 margin-left: 80px; /* Default collapsed sidebar width */
            padding: 20px;
            background-color: #000000;
            min-height: 100vh;
            width: calc(100% - 80px); /* Adjust for collapsed sidebar width */
            transition: margin-left 0.3s ease, width 0.3s ease;     }
    .sidebar:hover ~ .content {
            margin-left: 250px; /* Expanded sidebar width */
            width: calc(100% - 250px); /* Adjust for expanded sidebar width */
        }
        media screen and (max-width: 768px) {
            .content {
                margin-left: 80px;
                width: calc(100% - 80px);
            }
        }
    </style>
</head>
<body>
    <%@ include file="menu.jsp" %>
    <div class="content">
    <h1>Category</h1>
    <div class="container">
      <a href="BrowseStory.jsp?category=action"><button class="category-button">Action</button></a>
      <a href="BrowseStory.jsp?category=adventure"><button class="category-button">Adventure</button></a>
       <a href="BrowseStory.jsp?category=chickLit"><button class="category-button">ChickLit</button></a>
        <a href="BrowseStory.jsp?category=classics"><button class="category-button">Classics</button></a>
        <a href="BrowseStory.jsp?category=fiction"><button class="category-button">Fiction</button></a>
        <a href="BrowseStory.jsp?category=fantasy"><button class="category-button">Fantasy</button></a>
        <a href="BrowseStory.jsp?category=general"><button class="category-button">General</button></a>
        <a href="BrowseStory.jsp?category=historical"><button class="category-button">Historical</button></a>
        <a href="BrowseStory.jsp?category=horror"><button class="category-button">Horror</button></a>
        <a href="BrowseStory.jsp?category=humor"><button class="category-button">Humor</button></a>
        <a href="BrowseStory.jsp?category=mystery"><button class="category-button">Mystery</button></a>
        <a href="BrowseStory.jsp?category=non-Fiction"><button class="category-button">Non-Fiction</button></a>
        <a href="BrowseStory.jsp?category=paranormal"><button class="category-button">Paranormal</button></a>
        <a href="BrowseStory.jsp?category=poetry"><button class="category-button">Poetry</button></a>
        <a href="BrowseStory.jsp?category=random"><button class="category-button">Random</button></a>
        <a href="BrowseStory.jsp?category=romance"><button class="category-button">Romance</button></a>
        <a href="BrowseStory.jsp?category=science"><button class="category-button">Science</button></a>
        <a href="BrowseStory.jsp?category=short"><button class="category-button">Short</button></a>
        <a href="BrowseStory.jsp?category=spiritual"><button class="category-button">Spiritual</button></a>
        <a href="BrowseStory.jsp?category=teen"><button class="category-button">Teen</button></a>
        <a href="BrowseStory.jsp?category=thriller"><button class="category-button">Thriller</button></a>
        <a href="BrowseStory.jsp?category=vampire"><button class="category-button">Vampire</button></a>
        <a href="BrowseStory.jsp?category=werewolf"><button class="category-button">Werewolf</button></a>
        <a href="BrowseStory.jsp?category=hot"><button class="category-button">Hot</button></a>
        <a href="BrowseStory.jsp?category=knowledge"><button class="category-button">Knowledge</button></a>
    </div>
    </div>
</body>
</html>
