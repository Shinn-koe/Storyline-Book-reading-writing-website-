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

@WebServlet("/generateToken")
public class GenerateTokenServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT email FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Generate token and pass it to the next page
                String token = ResetTokenGenerator.generateResetToken(email);
                request.setAttribute("resetToken", token);
                request.getRequestDispatcher("tokenPage.jsp").forward(request, response);
            } else {
                response.getWriter().println("Email not found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
