package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get email and password from request
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Connect to database and verify user
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");

                // Verify password (for simplicity assuming plain-text password, for production use hashing)
                if (storedPassword.equals(password)) {

                    // Clear any existing session if it exists
                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.invalidate();  // Invalidate the current session
                    }

                    // Create a new session and store user info
                    session = request.getSession(true); 
                    session.setAttribute("user_id", rs.getInt("id")); // Create a new session
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("name", rs.getString("name")); // You can add more data as needed
                    session.setAttribute("password", rs.getString("password"));
                    session.setAttribute("bio", rs.getString("bio"));
                    session.setAttribute("profilePicture", rs.getString("profile_picture"));
                    session.setAttribute("coverPicture", rs.getString("cover_picture"));                    // Redirect to dashboard.jsp
                    response.sendRedirect("dashboard.jsp");
                } else {
                    // Invalid password
                    request.setAttribute("errorMessage", "Invalid email or password!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // Invalid login (email not found)
                request.setAttribute("errorMessage", "Invalid email or password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error connecting to the database!");
        }
    }
}
