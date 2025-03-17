package com.dashboard.servlets;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdatePartServlet")
public class UpdatePartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PartDAO partDAO;

    public void init() {
        partDAO = new PartDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int storyId = Integer.parseInt(request.getParameter("story_id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        String payment = request.getParameter("payment");

        storyPart part = new storyPart(id, storyId, title, content, status, payment);
        boolean updated = false;
		try {
			updated = partDAO.updatePart(part);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        if (updated) {
            response.sendRedirect("myPart.jsp");
        } else {
            response.getWriter().write("Error updating part.");
        }
    }
}
