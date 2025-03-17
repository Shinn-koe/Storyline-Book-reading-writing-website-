package com.dashboard.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.dashboard.utils.DBConnection;

@WebServlet("/PurchaseServlet")
public class PurchaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        String partIdParam = request.getParameter("id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (partIdParam == null || partIdParam.isEmpty()) {
            response.sendRedirect("readPart.jsp?error=Part ID is missing.");
            return;
        }

        int partId = Integer.parseInt(partIdParam);
        int partPrice = 3;
        int userCoins = 0;
        int storyId = 0;
        int writerId = 0;
        
        try (Connection conn = DBConnection.getConnection()) {
        	 // Get part's story ID and writer's user ID
        	 String partQuery = "SELECT story_id, s.user_id AS writer_id FROM parts p JOIN stories s ON p.story_id = s.id WHERE p.id = ?";
             try (PreparedStatement partStmt = conn.prepareStatement(partQuery)) {
                 partStmt.setInt(1, partId);
                 try (ResultSet rs = partStmt.executeQuery()) {
                     if (rs.next()) {
                         storyId = rs.getInt("story_id");
                         writerId = rs.getInt("writer_id"); // Get the writer's user ID
                     }
                 }
             }

            // Get user's coins
            String coinsQuery = "SELECT total_coins FROM users WHERE id = ?";
            try (PreparedStatement coinsStmt = conn.prepareStatement(coinsQuery)) {
                coinsStmt.setInt(1, userId);
                try (ResultSet rs = coinsStmt.executeQuery()) {
                    if (rs.next()) {
                        userCoins = rs.getInt("total_coins");
                    }
                }
            }

            // Check if user has enough coins
            if (userCoins >= partPrice) {
                // Deduct coins
                String updateCoins = "UPDATE users SET total_coins = total_coins - ? WHERE id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateCoins)) {
                    updateStmt.setInt(1, partPrice);
                    updateStmt.setInt(2, userId);
                    updateStmt.executeUpdate();
                }

                // Credit coins to the writer
                String creditWriterCoins = "UPDATE users SET total_coins = total_coins + ? WHERE id = ?";
                try (PreparedStatement creditStmt = conn.prepareStatement(creditWriterCoins)) {
                    creditStmt.setInt(1, partPrice); // Credit the same amount as the purchase
                    creditStmt.setInt(2, writerId); // Writer's user ID
                    creditStmt.executeUpdate();
                }
                
                // Add to purchases
                String insertPurchase = "INSERT INTO purchases (user_id, part_id) VALUES (?, ?)";
                try (PreparedStatement purchaseStmt = conn.prepareStatement(insertPurchase)) {
                    purchaseStmt.setInt(1, userId);
                    purchaseStmt.setInt(2, partId);
                    purchaseStmt.executeUpdate();
                }

                response.sendRedirect("readPart.jsp?id=" + partId + "&success=1");
            } else {
                response.sendRedirect("readPart.jsp?id=" + partId + "&error=2");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("readPart.jsp?id=" + partId + "&error=Database error occurred. Please try again later.");
        }
    }
}
