package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/ResetClickVideoCountServlet")
public class ResetClickVideoCountServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));

        try (Connection conn = DBConnection.getConnection()) {
            // Get last reset date
            PreparedStatement checkStmt = conn.prepareStatement("SELECT last_reset FROM user_clicks WHERE user_id = ?");
            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();

            boolean shouldReset = false;
            if (rs.next()) {
                Date lastReset = rs.getDate("last_reset");
                LocalDate today = LocalDate.now();

                if (lastReset == null || lastReset.toLocalDate().isBefore(today)) {
                    shouldReset = true;
                }
            } else {
                shouldReset = true;
            }

            if (shouldReset) {
                String sql = "UPDATE user_clicks SET click_count = 0, last_reset = ? WHERE user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setDate(1, Date.valueOf(LocalDate.now()));
                stmt.setInt(2, userId);
                int updatedRows = stmt.executeUpdate();
                
                if (updatedRows > 0) {
                    response.getWriter().println("Click count reset successfully.");
                } else {
                    response.getWriter().println("Failed to reset click count.");
                }
            } else {
                response.getWriter().println("Click count was already reset today.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}