package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            // Validate token
            String validateTokenSql = "SELECT reset_token FROM users WHERE email = ? AND reset_token = ?";
            PreparedStatement validateTokenStmt = conn.prepareStatement(validateTokenSql);
            validateTokenStmt.setString(1, email);
            validateTokenStmt.setString(2, token);
            var rs = validateTokenStmt.executeQuery();

            if (rs.next()) {
                // Update the password and clear the reset token
                String updatePasswordSql = "UPDATE users SET password = ?, reset_token = NULL WHERE email = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updatePasswordSql);
                updateStmt.setString(1, newPassword); // TODO: Hash the password before saving
                updateStmt.setString(2, email);
                int updatedRows = updateStmt.executeUpdate();

                if (updatedRows > 0) {
                    // Redirect to login page after successful update
                    response.sendRedirect("login.jsp");
                } else {
                    response.getWriter().println("Password reset failed.");
                }
            } else {
                response.getWriter().println("Invalid token.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
 