package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ClearNotificationsServlet")
public class ClearNotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        // Redirect to login if user is not logged in
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // SQL query to delete notifications for the logged-in user
            String sql = "DELETE FROM notifications WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            // Execute the delete operation
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                session.setAttribute("message", "All notifications cleared successfully!");
            } else {
                session.setAttribute("error", "No notifications to clear.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error clearing notifications.");
        }

        // Redirect back to the notifications page
        response.sendRedirect("notifications.jsp");
    }
}