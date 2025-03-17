package com.dashboard.servlets;

import com.dashboard.utils.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/UpdateStoryServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UpdateStoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String UPLOAD_DIR = "uploads"; // Folder where images will be saved

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("UpdateStoryServlet: Request received");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String storyId = request.getParameter("storyId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        Part coverPart = request.getPart("cover");

        String coverImage = null;
        if (coverPart != null && coverPart.getSize() > 0) {
            coverImage = extractFileName(coverPart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            coverPart.write(uploadPath + File.separator + coverImage);
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            if (coverImage != null) {
                sql = "UPDATE stories SET title = ?, content = ?, description = ?, category = ?, cover_image = ? WHERE id = ? AND user_id = ?";
            } else {
                sql = "UPDATE stories SET title = ?, content = ?, description = ?, category = ? WHERE id = ? AND user_id = ?";
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setString(3, description);
            stmt.setString(4, category);
            if (coverImage != null) {
                stmt.setString(5, coverImage);
                stmt.setInt(6, Integer.parseInt(storyId));
                stmt.setInt(7, userId);
            } else {
                stmt.setInt(5, Integer.parseInt(storyId));
                stmt.setInt(6, userId);
            }

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                session.setAttribute("message", "Story updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update story.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error updating story.");
        }

        response.sendRedirect("mystory.jsp");
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String content : contentDisp.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}
