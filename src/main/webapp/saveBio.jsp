<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    // Get logged-in user's ID
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String bioMessage = request.getParameter("bioMessage");

    if (bioMessage != null) {
        // Database connection details
        String url = "jdbc:mysql://localhost:3306/storyline";
        String user = "root";
        String password = "shinn";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);

            // Update user's bio
            String updateQuery = "UPDATE users SET bio=? WHERE id=?";
            ps = conn.prepareStatement(updateQuery);
            ps.setString(1, bioMessage);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    response.sendRedirect("profile.jsp"); // Redirect back to the form
%>
