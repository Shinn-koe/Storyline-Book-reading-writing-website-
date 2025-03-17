package com.dashboard.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchInput = request.getParameter("search");
        String loggedInUser = (String) request.getSession().getAttribute("username");

        String jdbcURL = "jdbc:mysql://localhost:3306/storyline";
        String dbUser = "root";
        String dbPassword = "shinn";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<User> users = new ArrayList<>();
        List<Story> stories = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Fetch users
            String sqlUsers = "SELECT u.id, u.username, u.name, u.profile_picture, " +
                              "(SELECT COUNT(*) FROM followers f WHERE f.follower_id = (SELECT id FROM users WHERE username = ?) " +
                              "AND f.following_id = u.id) AS isFollowing " +
                              "FROM users u WHERE u.username LIKE ? OR u.name LIKE ?";
            pstmt = conn.prepareStatement(sqlUsers);
            pstmt.setString(1, loggedInUser);
            pstmt.setString(2, "%" + searchInput + "%");
            pstmt.setString(3, "%" + searchInput + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                boolean isFollowing = rs.getInt("isFollowing") > 0;
                users.add(new User(rs.getString("username"), rs.getString("name"), rs.getString("profile_picture"), isFollowing));
            }
            rs.close();
            pstmt.close();

            
         // Fetch stories
            String sqlStories = "SELECT s.id, s.title, s.cover_image FROM stories s WHERE s.title LIKE ?";
            pstmt = conn.prepareStatement(sqlStories);
            pstmt.setString(1, "%" + searchInput + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String coverImage = rs.getString("cover_image");
                System.out.println("Story ID: " + rs.getInt("id") + ", Cover Image: " + coverImage); // Debug print
                stories.add(new Story(rs.getInt("id"), rs.getString("title"), coverImage));
            }

            request.setAttribute("users", users);
            request.setAttribute("stories", stories);
            RequestDispatcher dispatcher = request.getRequestDispatcher("search.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database connection error.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("search.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static class User {
        private String username;
        private String name;
        private String profilePicture;
        private boolean isFollowing;

        public User(String username, String name, String profilePicture, boolean isFollowing) {
            this.username = username;
            this.name = name;
            this.profilePicture = (profilePicture != null && !profilePicture.isEmpty()) ? profilePicture : "default-profile.png";
            this.isFollowing = isFollowing;
        }

        public String getUsername() { return username; }
        public String getName() { return name; }
        public String getProfilePicture() { return profilePicture; }
        public boolean isFollowing() { return isFollowing; }
    }

    public static class Story {
        private int id;
        private String title;
        private String coverImage;

        public Story(int id, String title, String coverImage) {
            this.id = id;
            this.title = title;
            this.coverImage = (coverImage != null && !coverImage.isEmpty()) ? coverImage : "default-story.png";
        }

        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getCoverImage() { return coverImage; }
    }
}
