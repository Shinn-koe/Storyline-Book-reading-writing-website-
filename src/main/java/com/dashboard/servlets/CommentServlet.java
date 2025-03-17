package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }


        // Fetch comments for a story
        String storyId = request.getParameter("id");
        if (storyId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Story ID is required");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, String>> comments = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();

            // Fetch comments for the story
            String query = "SELECT c.id, c.comment_text, c.created_at, u.username " +
                           "FROM comments c " +
                           "JOIN users u ON c.user_id = u.id " +
                           "WHERE c.story_id = ? " +
                           "ORDER BY c.created_at DESC";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(storyId));
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> comment = new HashMap<>();
                comment.put("id", rs.getString("id"));
                comment.put("comment_text", rs.getString("comment_text"));
                comment.put("username", rs.getString("username"));
                comment.put("created_at", rs.getString("created_at"));
                comments.add(comment);
            }

            // Set comments as a request attribute
            request.setAttribute("comments", comments);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        // Forward to the JSP page
        request.getRequestDispatcher("readStory.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Add a new comment
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        String storyId = request.getParameter("storyId");
        String commentText = request.getParameter("comment");

        if (userId == null || storyId == null || commentText == null || commentText.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();

            // Insert the new comment
            String query = "INSERT INTO comments (story_id, user_id, comment_text) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(storyId));
            stmt.setInt(2, userId);
            stmt.setString(3, commentText.trim());
            stmt.executeUpdate();

            // Fetch story owner's ID
            String ownerQuery = "SELECT user_id FROM stories WHERE id = ?";
            try (PreparedStatement ownerStmt = conn.prepareStatement(ownerQuery)) {
                ownerStmt.setInt(1, Integer.parseInt(storyId));
                ResultSet ownerRs = ownerStmt.executeQuery();

                if (ownerRs.next()) {
                    int recipientId = ownerRs.getInt("user_id");

                    // Ensure the user is not commenting on their own story
                    if (recipientId != userId) {
                        // Add notification for the story owner
                        String notificationQuery = "INSERT INTO notifications (user_id, message, story_id, liked_by, type) " +
                                                  "VALUES (?, ?, ?, ?, ?)";
                        stmt = conn.prepareStatement(notificationQuery);
                        stmt.setInt(1, recipientId); // The story owner's ID
                        stmt.setString(2, "commented on your story"); // The action
                        stmt.setInt(3, Integer.parseInt(storyId)); // The story ID
                        stmt.setInt(4, userId); // The user who commented
                        stmt.setString(5, "comment"); // The notification type
                        stmt.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        // Redirect back to the story page
        response.sendRedirect("CommentServlet?id=" + storyId);
    }
}