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

@WebServlet("/UnreadNotificationServlet")
public class UnreadNotificationServlet extends HttpServlet {
 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     HttpSession session = request.getSession();
     Integer userId = (Integer) session.getAttribute("user_id");

     if (userId == null) {
         return; // No user logged in, no need to fetch notifications
     }

     Connection conn = null;
     PreparedStatement stmt = null;
     ResultSet rs = null;
     int unreadCount = 0;

     try {
         conn = DBConnection.getConnection();
         String query = "SELECT COUNT(*) AS unread_count FROM notifications WHERE user_id = ? AND is_read = FALSE";
         stmt = conn.prepareStatement(query);
         stmt.setInt(1, userId);
         rs = stmt.executeQuery();

         if (rs.next()) {
             unreadCount = rs.getInt("unread_count");
         }

         // Set unread count in session
         session.setAttribute("unreadCount", unreadCount);
     } catch (Exception e) {
         e.printStackTrace();
     } finally {
         try { if (rs != null) rs.close(); } catch (Exception e) {}
         try { if (stmt != null) stmt.close(); } catch (Exception e) {}
         try { if (conn != null) conn.close(); } catch (Exception e) {}
     }
 }
}