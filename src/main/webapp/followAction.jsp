<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.dashboard.utils.DBConnection" %>
<%@ page session="true" %>

<%
    String followUsername = request.getParameter("followUsername");
    String loggedInUsername = (String) session.getAttribute("username");
    
    if (followUsername != null && !followUsername.isEmpty() && !followUsername.equals(loggedInUsername)) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Check if the user is already following
            String checkFollowSql = "SELECT * FROM followers WHERE follower_id = (SELECT id FROM users WHERE username = ?) AND following_id = (SELECT id FROM users WHERE username = ?)";
            pstmt = conn.prepareStatement(checkFollowSql);
            pstmt.setString(1, loggedInUsername);
            pstmt.setString(2, followUsername);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // User is already following, so unfollow (delete from followers table)
                String unfollowSql = "DELETE FROM followers WHERE follower_id = (SELECT id FROM users WHERE username = ?) AND following_id = (SELECT id FROM users WHERE username = ?)";
                pstmt = conn.prepareStatement(unfollowSql);
                pstmt.setString(1, loggedInUsername);
                pstmt.setString(2, followUsername);
                pstmt.executeUpdate();
            } else {
                // User is not following, so follow (insert into followers table)
                String followSql = "INSERT INTO followers (follower_id, following_id) VALUES ((SELECT id FROM users WHERE username = ?), (SELECT id FROM users WHERE username = ?))";
                pstmt = conn.prepareStatement(followSql);
                pstmt.setString(1, loggedInUsername);
                pstmt.setString(2, followUsername);
                pstmt.executeUpdate();
            }
            
            // Redirect back to the same profile's followers page
            response.sendRedirect("following.jsp?username="+ loggedInUsername );
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
