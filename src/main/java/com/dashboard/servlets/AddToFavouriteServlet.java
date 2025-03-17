package com.dashboard.servlets;   
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AddToFavouriteServlet")
public class AddToFavouriteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int storyId = Integer.parseInt(request.getParameter("storyId"));

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/storyline", "root", "shinn");
            
            // Check if already in favorites
            String checkQuery = "SELECT * FROM favorites WHERE user_id = ? AND story_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, storyId);
            if (checkStmt.executeQuery().next()) {
                response.sendRedirect("library.jsp?message=Already in favourites");
                return;
            }

            // Add to favorites
            String query = "INSERT INTO favorites (user_id, story_id) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setInt(2, storyId);
            stmt.executeUpdate();
            
            response.sendRedirect("favourite.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("library.jsp?message=Error adding to favourites");
        }
    }
}
