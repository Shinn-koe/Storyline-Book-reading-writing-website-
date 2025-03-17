package com.dashboard.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class StorySelectionServlet
 */
@WebServlet("/SetStoryIdServlet")
public class SetStoryIdServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String storyIdParam = request.getParameter("storyId");

        if (storyIdParam != null) {
            try {
                int storyId = Integer.parseInt(storyIdParam);
                session.setAttribute("storyId", storyId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("myPart.jsp");
    }
}