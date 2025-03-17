package com.dashboard.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dashboard.utils.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/DownloadServlet")
public class DownloadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String storyIdStr = request.getParameter("storyId");
        int userId = (int) session.getAttribute("user_id");

        if (storyIdStr != null && !storyIdStr.isEmpty()) {
            try {
                int storyId = Integer.parseInt(storyIdStr);
                boolean isStoryInLibrary = isStoryInLibrary(userId, storyId);
                String result = "";

                if (isStoryInLibrary) {
                    result = removeDownload(userId, storyId) ? "Removed" : "Error";
                } else {
                    result = addDownload(userId, storyId) ? "Added" : "Error";
                }

                // **Update session with new library stories**
                List<Story> updatedLibrary = StoryDAO.getUserLibraryStories(userId);
                session.setAttribute("userLibraryStories", updatedLibrary);
                
                response.getWriter().write(result);
            } catch (NumberFormatException e) {
                response.getWriter().write("Error");
            }
        } else {
            response.getWriter().write("Error");
        }
    }


    

    private boolean isStoryInLibrary(int userId, int storyId) {
        String query = "SELECT 1 FROM downloads WHERE user_id = ? AND story_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, storyId);
            return stmt.executeQuery().next();
        } catch (SQLException e) {
            return false;
        }
    }

    private boolean addDownload(int userId, int storyId) {
        String query = "INSERT INTO downloads (user_id, story_id) VALUES (?, ?)";
        return executeUpdate(query, userId, storyId);
    }

    private boolean removeDownload(int userId, int storyId) {
        String query = "DELETE FROM downloads WHERE user_id = ? AND story_id = ?";
        return executeUpdate(query, userId, storyId);
    }

    private boolean executeUpdate(String query, int userId, int storyId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, storyId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }
}
