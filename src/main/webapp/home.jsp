<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StoryVerse - Your World of Stories</title>
    <style>
        /* General Styles */
        body {
            font-family:Times;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #1a1a1a, #2c3e50);
            color: #fff;
            line-height: 1.6;
            transition: background 0.5s ease, color 0.5s ease;
        }

        body.light-mode {
            background: linear-gradient(135deg, #ffffff, #f0f0f0);
            color: #333;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* Header */
        header {
            background: rgba(26, 26, 26, 0.9);
            backdrop-filter: blur(10px);
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        body.light-mode header {
            background: rgba(255, 255, 255, 0.9);
        }

        nav ul {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            gap: 20px;
        }

        nav ul li a {
            font-weight: 600;
            transition: color 0.3s ease;
            position: relative;
            color: #fff;
            text-decoration: none;
        }

        body.light-mode nav ul li a {
            color: #333;
        }

        nav ul li a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: #f3c204;
            transition: width 0.3s ease;
        }

        nav ul li a:hover::after {
            width: 100%;
        }

        nav ul li a.active {
            color: #f3c204;
        }

        nav ul li a.active::after {
            width: 100%;
        }
/* Dark Mode Toggle */
        .dark-mode-toggle {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }

        .dark-mode-toggle input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.4s;
            border-radius: 34px;
        }

        .slider::before {
            position: absolute;
            content: '';
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: 0.4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #f3c204;;
        }

        input:checked + .slider::before {
            transform: translateX(26px);
        }
        /* Hero Section - Advanced Design */
        .hero {
            position: relative;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: white;
        }

        .hero-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('${pageContext.request.contextPath}/resources/images/book.jpg') no-repeat center center/cover;
            z-index: 0;
            transform: translateZ(0); /* Remove scaling for clarity */
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: float 6s ease-in-out infinite;
        }

        .glass-card h1 {
            font-size: 4rem;
            margin-bottom: 20px;
            animation: fadeIn 1.5s ease-in-out;
            color:#f37c7c;
        }

        .glass-card p {
            font-size: 1.5rem;
            margin-bottom: 40px;
            animation: fadeIn 2s ease-in-out;
            color:#f37c7c;
        }

        .glass-card button {
            background: #f37c7c;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            font-family:Times;
        }

        .glass-card button:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        /* Features Section */
        .features {
            padding: 100px 20px;
            background: rgba(255, 255, 255, 0.01);
            backdrop-filter: blur(10px);
            text-align: center;
        }

        .features h2 {
            font-size: 3rem;
            margin-bottom: 40px;
            color: #ff6f61;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            padding: 0 20px;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
             box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(100deg, #f0a93e, #f9d86e);
            z-index: -1;
            border-radius: 20px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .feature-card:hover::before {
            opacity: 1;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #ff6f61;
        }

        .feature-card h3 {
            font-size: 1.8rem;
            margin-bottom: 15px;
            color: #ff6f61;
        }

        .feature-card p {
            font-size: 1.1rem;
            margin-bottom: 20px;
        }

        .feature-details {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.5s ease, opacity 0.5s ease;
            opacity: 0;
        }

        .feature-card:hover .feature-details {
            max-height: 200px; /* Adjust based on content */
            opacity: 1;
        }

        .feature-details button {
            background: #f37c7c;
            color: white ;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            font-family:Times;
        }

        .feature-details button:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        /* Footer */
        footer {
            background: #1a1a1a;
            color: white;
            text-align: center;
            padding: 20px;
        }

        body.light-mode footer {
            background: #333;
        }

        /* Floating Action Button */
        .fab {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #ff6f61;
            color: white;
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            font-size: 1.5rem;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .fab:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
        }

        /* Animations */
        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Smooth Scrolling */
        html {
            scroll-behavior: smooth;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-content {
                max-width: 100%;
                text-align: center;
            }

            .feature-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <nav>
            <ul>
                <li><a href="#home" class="nav-link active">Home</a></li>
                <li><a href="#about" class="nav-link">About</a></li>
                <li><a href="insert.jsp" class="nav-link">Sign Up</a></li>
            </ul>
        </nav>
        <div class="dark-mode-toggle">
                <input type="checkbox" id="dark-mode-toggle" onclick="toggleDarkMode()">
                <label for="dark-mode-toggle" class="slider"></label>
        </div>
    </header>

    <!-- Hero Section -->
    <section id="home" class="hero">
        <div class="hero-background"></div>
        <div class="hero-content">
            <div class="glass-card">
                <h1>Welcome to StoryLine</h1>
                <p>Discover, Read, and Share Your Stories</p>
                <button onclick="getItNow()">Start Reading</button>
            </div>
        </div>
    </section>

    <!-- Features Section -->
<section id="about" class="features">
    <h2>Why Choose StoryLine?</h2>
    <div class="feature-grid">
        <div class="feature-card">
            <div class="feature-icon">📚</div>
            <h3>Unlimited Stories</h3>
            <p>Explore a vast library of stories across genres. From romance to sci-fi, we have it all.</p>
            <div class="feature-details">
                <p><strong>New stories added daily!</strong></p>
                <button onclick="exploreStories()">Explore Now</button>
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-icon">✍️</div>
            <h3>Write & Share</h3>
            <p>Create your own stories and share them with the world. Get feedback from readers.</p>
            <div class="feature-details">
                <p><strong>Join our writing community!</strong></p>
                <button onclick="startWriting()">Start Writing</button>
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📱</div>
            <h3>Read Anywhere</h3>
            <p>Access your favorite stories on any device. Read offline with our mobile app.</p>
            <div class="feature-details">
                <p><strong>Download the app now!</strong></p>
                <button onclick="downloadApp()">Download</button>
            </div>
        </div>
    </div>
</section>

    <!-- Footer -->
    <footer>
        <p>&copy; 2025 Storyline. All rights reserved.</p>
    </footer>

    <!-- Floating Action Button -->
    <button class="fab" onclick="scrollToTop()">↑</button>

    <!-- JavaScript -->
    <script>
        // Dark Mode Toggle
        function toggleDarkMode() {
            document.body.classList.toggle('light-mode');
        }

        // Button Actions
        function getItNow() {
            alert("Start Reading button clicked!");
        }

        function exploreStories() {
            alert("Explore Stories button clicked!");
        }

        function startWriting() {
            alert("Start Writing button clicked!");
        }

        function downloadApp() {
            alert("Download App button clicked!");
        }

        // Scroll to Top
        function scrollToTop() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        
     // Smooth Scrolling and Active Link Highlighting
        document.addEventListener('DOMContentLoaded', function () {
            const navLinks = document.querySelectorAll('.nav-link');
            const sections = document.querySelectorAll('section');

            // Function to highlight active link
            function highlightActiveLink() {
                let index = sections.length;

                while (--index && window.scrollY + 50 < sections[index].offsetTop) {}

                navLinks.forEach((link) => link.classList.remove('active'));
                navLinks[index].classList.add('active');
            }

            // Add event listeners to nav links
            navLinks.forEach((link) => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const targetId = link.getAttribute('href');
                    if (targetId.startsWith('#')) {
                        const targetSection = document.querySelector(targetId);
                        targetSection.scrollIntoView({ behavior: 'smooth' });
                    } else {
                        window.location.href = targetId; // Navigate to external links (e.g., insert.jsp)
                    }
                });
            });

            // Highlight active link on scroll
            window.addEventListener('scroll', highlightActiveLink);
        });

        // Button Actions
        function getItNow() {
            window.location.href = 'insert.jsp'; // Navigate to insert.jsp
        }

        function exploreStories() {
            window.location.href = 'insert.jsp'; // Navigate to insert.jsp
        }

        function startWriting() {
            window.location.href = 'insert.jsp'; // Navigate to insert.jsp
        }
        
        function downloadApp() {
            window.location.href = 'insert.jsp'; // Navigate to insert.jsp
        }
    </script>
</body>
</html>