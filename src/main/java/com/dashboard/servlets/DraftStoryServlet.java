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

@WebServlet("/DraftStoryServlet")
public class DraftStoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Allow GET requests to be handled the same as POST
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String storyId = request.getParameter("storyId");

        if (storyId == null || storyId.isEmpty()) {
            session.setAttribute("error", "Invalid story ID.");
            response.sendRedirect("mystory.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE stories SET status = 'draft' WHERE id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(storyId));
            stmt.setInt(2, userId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                session.setAttribute("message", "Story saved as draft successfully!");
            } else {
                session.setAttribute("error", "Failed to save story as draft.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error saving story as draft.");
        }

        response.sendRedirect("mystory.jsp");
    }
}
