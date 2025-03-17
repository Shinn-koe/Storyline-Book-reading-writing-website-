package com.dashboard.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dashboard.utils.DBConnection;

@WebServlet("/UpdateCoinsServlet")
public class UpdateCoinsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));

        try (Connection conn = DBConnection.getConnection()) {
            // Check current click count
            PreparedStatement checkStmt = conn.prepareStatement("SELECT click_count FROM user_clicks WHERE user_id = ? LIMIT 1");
            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();

            int clickCount = 0;
            boolean recordExists = rs.next(); // Check if a record exists
            
            if (recordExists) {
                clickCount = rs.getInt("click_count");
            }

            if (clickCount < 10) {
                // Update coins
                PreparedStatement updateCoinsStmt = conn.prepareStatement("UPDATE users SET total_coins = total_coins + 1 WHERE id = ?");
                updateCoinsStmt.setInt(1, userId);
                updateCoinsStmt.executeUpdate();

             // Update or Insert click count properly
                if (recordExists) {
                    PreparedStatement updateClickStmt = conn.prepareStatement(
                        "UPDATE user_clicks SET click_count = click_count + 1 WHERE user_id = ?");
                    updateClickStmt.setInt(1, userId);
                    updateClickStmt.executeUpdate();
                } else {
                    PreparedStatement insertClickStmt = conn.prepareStatement(
                        "INSERT INTO user_clicks (user_id, click_count) VALUES (?, ?)");
                    insertClickStmt.setInt(1, userId);
                    insertClickStmt.setInt(2, 1);
                    insertClickStmt.executeUpdate();
                }

                response.getWriter().write("Coin added successfully.");
            } else {
                response.getWriter().write("Maximum click limit reached.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error updating coins.");
        }
    }
}
