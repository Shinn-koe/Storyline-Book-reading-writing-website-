<%@ page session="true" %>
<%
    session.invalidate(); // Invalidates the session, effectively logging out the user
    response.sendRedirect("login.jsp"); // Redirects to the login page after logging out
%>
