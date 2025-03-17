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

@WebServlet("/DeleteStoryServlet")
public class DeleteStoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String storyId = request.getParameter("storyId");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM stories WHERE id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(storyId));
            stmt.setInt(2, userId);

            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                session.setAttribute("message", "Story deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete story.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error deleting story.");
        }

        response.sendRedirect("mystory.jsp");
    }
}
