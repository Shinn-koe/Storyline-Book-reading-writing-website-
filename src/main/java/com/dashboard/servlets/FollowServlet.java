package com.dashboard.servlets;

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
import com.dashboard.utils.DBConnection;

@WebServlet("/FollowServlet")
public class FollowServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String loggedInUser = (String) session.getAttribute("username");
        String followingUsername = request.getParameter("followingUsername");

        if (loggedInUser == null || followingUsername == null) {
            System.out.println("Error: Missing logged-in user or following username.");
            out.print("error");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Get user IDs
            int followerId = getUserId(loggedInUser, conn);
            int followingId = getUserId(followingUsername, conn);

            System.out.println("Follower ID: " + followerId + ", Following ID: " + followingId);

            if (followerId == 0 || followingId == 0) {
                System.out.println("Error: Could not retrieve user IDs.");
                out.print("error");
                return;
            }

            // Check if already following
            if (isAlreadyFollowing(followerId, followingId, conn)) {
                // Unfollow
                String deleteQuery = "DELETE FROM followers WHERE follower_id = ? AND following_id = ?";
                stmt = conn.prepareStatement(deleteQuery);
                stmt.setInt(1, followerId);
                stmt.setInt(2, followingId);
                int rowsDeleted = stmt.executeUpdate();
                stmt.close();
                System.out.println("Unfollowed: " + (rowsDeleted > 0));
                out.print("unfollowed");

                // Delete the follow notification if it exists
                deleteFollowNotification(followingId, followerId, conn);
            } else {
                // Follow
                String insertQuery = "INSERT INTO followers (follower_id, following_id) VALUES (?, ?)";
                stmt = conn.prepareStatement(insertQuery);
                stmt.setInt(1, followerId);
                stmt.setInt(2, followingId);
                int rowsInserted = stmt.executeUpdate();
                stmt.close();
                System.out.println("Followed: " + (rowsInserted > 0));
                out.print("followed");

                // Insert follow notification
                String notificationQuery = "INSERT INTO notifications (user_id, message, story_id, liked_by, type) VALUES (?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(notificationQuery);
                stmt.setInt(1, followingId); // The user who is being followed
                stmt.setString(2, loggedInUser + " started following you."); // Message
                stmt.setInt(3, 0); // story_id can be 0 or NULL for follow notifications
                stmt.setInt(4, followerId); // The user who followed
                stmt.setString(5, "follow"); // Notification type
                stmt.executeUpdate();
                stmt.close();
            }

            // Update follower and following counts
            int followersCount = getFollowersCount(followingId, conn);
            int followingCount = getFollowingCount(followerId, conn);

            // Update session variables
            session.setAttribute("followersCount", followersCount);
            session.setAttribute("followingCount", followingCount);

            // Send response with updated counts
            out.print("|" + followersCount + "|" + followingCount);

        } catch (Exception e) {
            e.printStackTrace();
            out.print("error");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    // Retrieve user ID from the database
    private int getUserId(String username, Connection conn) throws Exception {
        String query = "SELECT id FROM users WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return 0; // Return 0 if user is not found
    }

    // Check if user is already following another user
    private boolean isAlreadyFollowing(int followerId, int followingId, Connection conn) throws Exception {
        String query = "SELECT * FROM followers WHERE follower_id = ? AND following_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, followerId);
            stmt.setInt(2, followingId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // Returns true if record exists
            }
        }
    }

    // Get follower count for a user
    private int getFollowersCount(int userId, Connection conn) throws Exception {
        String query = "SELECT COUNT(*) AS count FROM followers WHERE following_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt("count") : 0;
            }
        }
    }

    // Get following count for a user
    private int getFollowingCount(int userId, Connection conn) throws Exception {
        String query = "SELECT COUNT(*) AS count FROM followers WHERE follower_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt("count") : 0;
            }
        }
    }

    // Delete follow notification when unfollowing
    private void deleteFollowNotification(int followingId, int followerId, Connection conn) throws Exception {
        String query = "DELETE FROM notifications WHERE user_id = ? AND liked_by = ? AND type = 'follow'";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, followingId); // The user who was being followed
            stmt.setInt(2, followerId); // The user who unfollowed
            int rowsDeleted = stmt.executeUpdate();
            System.out.println("Deleted follow notification: " + (rowsDeleted > 0));
        }
    }
}