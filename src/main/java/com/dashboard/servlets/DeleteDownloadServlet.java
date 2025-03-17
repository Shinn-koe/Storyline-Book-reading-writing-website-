package com.dashboard.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;

@WebServlet("/DeleteDownloadServlet")
public class DeleteDownloadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int storyId = Integer.parseInt(request.getParameter("storyId"));
        Integer userIdObj = (Integer) request.getSession().getAttribute("user_id");

        if (userIdObj == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User session not found.");
            return;
        }

        int userId = userIdObj;
        String query = "DELETE FROM downloads WHERE user_id = ? AND story_id = ?";

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/storyline", "root", "shinn");
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, storyId);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("library.jsp"); // Redirect to the library page after deleting the download
            } else {
                response.getWriter().write("Error: Could not delete the download.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
