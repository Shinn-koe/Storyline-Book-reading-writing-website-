package com.dashboard.servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.dashboard.utils.DBConnection;

@WebServlet("/updateProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ProfileServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "uploads"; // Store files inside webapp/uploads

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String bio = request.getParameter("bio"); // Get bio from form
        Part profilePart = request.getPart("profilePicture");
        Part coverPart = request.getPart("coverPicture");

        // Retrieve current profile/cover picture from session
        String currentProfilePicture = (String) session.getAttribute("profilePicture");
        String currentCoverPicture = (String) session.getAttribute("coverPicture");

        // Save new files if uploaded, otherwise keep existing ones
        String profilePicture = saveFile(profilePart, username, "profile", request);
        if (profilePicture == null) profilePicture = currentProfilePicture;

        String coverPicture = saveFile(coverPart, username, "cover", request);
        if (coverPicture == null) coverPicture = currentCoverPicture;

        try {
            updateUserData(username, name, email, password, bio, profilePicture, coverPicture);

            // Update session immediately
            session.setAttribute("name", name);
            session.setAttribute("email", email);
            session.setAttribute("bio", bio);
            session.setAttribute("password", password);
            session.setAttribute("profilePicture", profilePicture);
            session.setAttribute("coverPicture", coverPicture);

            response.sendRedirect("setting.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("setting.jsp?error=true");
        }
    }

    // Save the uploaded file and return the file path
    private String saveFile(Part filePart, String username, String type, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() <= 0) {
            return null; // No file uploaded
        }

        String fileExtension = Paths.get(filePart.getSubmittedFileName()).toString();
        fileExtension = fileExtension.substring(fileExtension.lastIndexOf("."));
        String fileName = type + "_" + username + fileExtension;

        String uploadPath = request.getServletContext().getRealPath("/") + UPLOAD_DIRECTORY; // Store in webapp/uploads
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        return UPLOAD_DIRECTORY + "/" + fileName; // Return relative path
    }

    private void updateUserData(String username, String name, String email, String password, String bio, String profilePicture, String coverPicture) throws SQLException {
        String sql = "UPDATE users SET name = ?, email = ?, password = ?, bio = ?, profile_picture = ?, cover_picture = ? WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, password);
            pstmt.setString(4, bio);
            pstmt.setString(5, profilePicture);
            pstmt.setString(6, coverPicture);
            pstmt.setString(7, username);
            pstmt.executeUpdate();
        }
    }

    // Load user data into the session, ensuring default values for images
    private void loadUserData(HttpSession session, String username) throws SQLException {
        String sql = "SELECT name, email, password, bio, " +
                "COALESCE(profile_picture, 'image/2.jpg') AS profile_picture, " +
                "COALESCE(cover_picture, 'image/1.jpg') AS cover_picture FROM users WHERE username=?";
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("password", rs.getString("password"));
                session.setAttribute("bio", rs.getString("bio"));
                session.setAttribute("profilePicture", rs.getString("profile_picture"));
                session.setAttribute("coverPicture", rs.getString("cover_picture"));
            }
        }
    }
}
