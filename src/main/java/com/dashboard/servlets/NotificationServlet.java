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

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp"); // Redirect to login if user is not logged in
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> notifications = new ArrayList<>(); // Use Object instead of String for flexibility
        int unreadCount = 0;

        try {
            conn = DBConnection.getConnection();

            // Fetch notifications with user profile picture and story title
            String query = "SELECT n.id, n.message, n.story_id, n.liked_by, n.created_at, n.type, n.is_read, " +
                           "u.username, u.profile_picture, s.title AS story_title " + // Include story title
                           "FROM notifications n " +
                           "JOIN users u ON n.liked_by = u.id " + // Join with users to get the follower's details
                           "LEFT JOIN stories s ON n.story_id = s.id " + // Join with stories to get the story title
                           "WHERE n.user_id = ? " +
                           "ORDER BY n.created_at DESC";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> notification = new HashMap<>();
                notification.put("id", rs.getString("id"));
                notification.put("type", rs.getString("type"));

                if ("follow".equals(rs.getString("type"))) {
                    // Handle follow notifications
                    notification.put("message", rs.getString("username") + " started following you.");
                    notification.put("liked_by", rs.getString("username"));
                    notification.put("profile_picture", rs.getString("profile_picture"));
                } else if ("like".equals(rs.getString("type"))) {
                    // Handle like notifications
                    notification.put("message", rs.getString("username") + " liked your story: " + rs.getString("story_title"));
                    notification.put("liked_by", rs.getString("username"));
                    notification.put("profile_picture", rs.getString("profile_picture"));
                    notification.put("story_id", rs.getString("story_id")); // Include story_id for like notifications
                    notification.put("story_title", rs.getString("story_title")); // Include story title
                } else if ("comment".equals(rs.getString("type"))) {
                    // Handle comment notifications
                    notification.put("message", rs.getString("username") + " commented on your story: " + rs.getString("story_title"));
                    notification.put("liked_by", rs.getString("username"));
                    notification.put("profile_picture", rs.getString("profile_picture"));
                    notification.put("story_id", rs.getString("story_id")); // Include story_id for comment notifications
                    notification.put("story_title", rs.getString("story_title")); // Include story title
                } else if ("new_story".equals(rs.getString("type"))) {
                    // Handle new story notifications
                    notification.put("message", rs.getString("username") + " created a new story: " + rs.getString("story_title"));
                    notification.put("liked_by", rs.getString("username"));
                    notification.put("profile_picture", rs.getString("profile_picture"));
                    notification.put("story_id", rs.getString("story_id")); // Include story_id for new story notifications
                    notification.put("story_title", rs.getString("story_title")); // Include story title
                }

                notification.put("created_at", rs.getString("created_at"));
                notification.put("is_read", rs.getBoolean("is_read")); // Use getBoolean for is_read
                notifications.add(notification);

                // Count unread notifications
                if (!rs.getBoolean("is_read")) {
                    unreadCount++;
                }
            }

            // Mark all notifications as read
            String markAsReadQuery = "UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE";
            stmt = conn.prepareStatement(markAsReadQuery);
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            // Update the unreadCount in the session to 0
            session.setAttribute("unreadCount", 0);

            // Set notifications and unread count as request attributes
            request.setAttribute("notifications", notifications);
            request.setAttribute("unreadCount", unreadCount);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        // Forward to notifications.jsp
        request.getRequestDispatcher("notifications.jsp").forward(request, response);
    }
}