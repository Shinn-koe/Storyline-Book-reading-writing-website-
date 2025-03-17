package com.dashboard.servlets;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import org.jsoup.Jsoup;

@WebServlet("/StoryServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class StoryServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("save".equals(action) || "publish".equals(action)) {
            saveOrUpdateStory(request, response, action);
        } else {
            saveStoryDetails(request, response);
        }
    }

    private void saveStoryDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement stmt = null;

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String category = request.getParameter("category");

            // Handle file upload
            Part filePart = request.getPart("cover");
            String fileName = saveFile(filePart, request);

            // Database connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/storyline", "root", "shinn");
            String sql = "INSERT INTO stories (user_id, title, description, category, cover_image, status) VALUES (?, ?, ?, ?, ?, 'draft')";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, userId);
            stmt.setString(2, title);
            stmt.setString(3, description);
            stmt.setString(4, category);
            stmt.setString(5, fileName);

            int rows = stmt.executeUpdate();
            int storyId = 0;

            if (rows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    storyId = generatedKeys.getInt(1);
                }
            }
            
            // ✅ Notify followers about the new story
            notifyFollowers(userId, storyId, conn);

            response.sendRedirect("writeStory.jsp?storyId=" + storyId);

        } catch (SQLException e) {
            throw new ServletException("Database error!", e);
        } finally {
            closeResources(stmt, conn);
        }
    }
    
    private void notifyFollowers(int userId, int storyId, Connection conn) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Fetch followers
            String fetchFollowersQuery = "SELECT follower_id FROM followers WHERE following_id = ?";
            stmt = conn.prepareStatement(fetchFollowersQuery);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            List<Integer> followerIds = new ArrayList<>();
            while (rs.next()) {
                followerIds.add(rs.getInt("follower_id"));
            }
            rs.close();
            stmt.close();

            // Insert notifications
            if (!followerIds.isEmpty()) {
                String insertNotificationQuery = "INSERT INTO notifications (user_id, message, story_id, liked_by, type) VALUES (?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(insertNotificationQuery);
                for (int followerId : followerIds) {
                    stmt.setInt(1, followerId);
                    stmt.setString(2, " Created new story");
                    stmt.setInt(3, storyId);
                    stmt.setInt(4, followerId); // The user who followed
                    stmt.setString(5, "new_story"); // Notification type
                    stmt.executeUpdate();
                }
            }
        } finally {
            closeResources(stmt, null);
        }
    }


    private void saveOrUpdateStory(HttpServletRequest request, HttpServletResponse response, String action) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement stmt = null;

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int storyId = Integer.parseInt(request.getParameter("storyId"));
            String storyContent = request.getParameter("storyContent");

            // Remove HTML tags and keep only plain text
            String cleanContent = Jsoup.parse(storyContent).text();

            String status = "save".equals(action) ? "draft" : "published";

            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/storyline", "root", "shinn");
            String sql = "UPDATE stories SET content = ?, status = ? WHERE id = ? AND user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, cleanContent);
            stmt.setString(2, status);
            stmt.setInt(3, storyId);
            stmt.setInt(4, userId);

            stmt.executeUpdate();
            response.sendRedirect("dashboard.jsp");

        } catch (SQLException e) {
            throw new ServletException("Database error!", e);
        } finally {
            closeResources(stmt, conn);
        }
    }

    private String saveFile(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() <= 0) {
            return null; // No file uploaded
        }

        String fileName = filePart.getSubmittedFileName();
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        return fileName;
    }

    private void closeResources(Statement stmt, Connection conn) {
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
}
