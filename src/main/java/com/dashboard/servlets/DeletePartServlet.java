package com.dashboard.servlets;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeletePartServlet")
public class DeletePartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PartDAO partDAO;

    public void init() {
        partDAO = new PartDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            partDAO.deletePart(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("myPart.jsp"); // Redirect back to the parts list
    }
}
