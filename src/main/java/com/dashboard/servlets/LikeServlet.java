package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LikeServlet")
public class LikeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("user_id");
        String storyId = request.getParameter("storyId");

        if (userId == null || storyId == null) {
            out.print("{\"error\": \"Unauthorized\"}");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean isLiked = false;
        int likeCount = 0;

        try {
            conn = DBConnection.getConnection();

            // Check if user already liked the story
            String checkQuery = "SELECT * FROM likes WHERE user_id = ? AND story_id = ?";
            stmt = conn.prepareStatement(checkQuery);
            stmt.setInt(1, userId);
            stmt.setInt(2, Integer.parseInt(storyId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Unlike (remove like)
                String deleteQuery = "DELETE FROM likes WHERE user_id = ? AND story_id = ?";
                stmt = conn.prepareStatement(deleteQuery);
                stmt.setInt(1, userId);
                stmt.setInt(2, Integer.parseInt(storyId));
                stmt.executeUpdate();
                isLiked = false;
            } else {
                // Add like
                String insertQuery = "INSERT INTO likes (user_id, story_id) VALUES (?, ?)";
                stmt = conn.prepareStatement(insertQuery);
                stmt.setInt(1, userId);
                stmt.setInt(2, Integer.parseInt(storyId));
                stmt.executeUpdate();
                isLiked = true;

                // Add notification for the story owner
                String notificationQuery = "INSERT INTO notifications (user_id, message, story_id, liked_by) " +
                        "SELECT s.user_id, CONCAT(u.username, ' liked your story'), ?, ? " +
                        "FROM stories s " +
                        "JOIN users u ON u.id = ? " +
                        "WHERE s.id = ?";
                stmt = conn.prepareStatement(notificationQuery);
                stmt.setInt(1, Integer.parseInt(storyId));
                stmt.setInt(2, userId);
                stmt.setInt(3, userId);
                stmt.setInt(4, Integer.parseInt(storyId));
                stmt.executeUpdate();
            }

            // Get updated like count
            String countQuery = "SELECT COUNT(*) FROM likes WHERE story_id = ?";
            stmt = conn.prepareStatement(countQuery);
            stmt.setInt(1, Integer.parseInt(storyId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                likeCount = rs.getInt(1);
            }

            // Return JSON response
            String jsonResponse = "{ \"likeCount\": " + likeCount + ", \"isLiked\": " + isLiked + " }";
            out.print(jsonResponse);
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Database error\"}");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}