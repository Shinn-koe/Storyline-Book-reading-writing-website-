package com.dashboard.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/InsertPartServlet")
public class InsertPartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PartDAO partDAO;

    public void init() {
        partDAO = new PartDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer storyId = (Integer) session.getAttribute("storyId");

        if (storyId == null) {
            response.sendRedirect("mystory.jsp");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        String payment = request.getParameter("payment");

        storyPart newPart = new storyPart(storyId, title, content, status, payment);
        partDAO.insertPart(newPart);
        
        response.sendRedirect("myPart.jsp"); // Redirect to the next page
    }

   
}
