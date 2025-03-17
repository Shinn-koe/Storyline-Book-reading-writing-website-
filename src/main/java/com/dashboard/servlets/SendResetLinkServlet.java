package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;
import com.dashboard.utils.ResetTokenGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/sendResetLink")
public class SendResetLinkServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT email FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String token = ResetTokenGenerator.generateResetToken(email);
                String resetLink = "http://localhost:8080/dashboard6/reset_password.jsp?token=" + token;

                // Show the reset link on the page instead of sending an email
                request.setAttribute("resetLink", resetLink);
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
            } else {
                response.getWriter().println("Email not found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
