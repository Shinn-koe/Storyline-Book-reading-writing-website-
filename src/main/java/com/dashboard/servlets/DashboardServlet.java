package com.dashboard.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dashboard.utils.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("user_id");

        // 🔥 Fetch latest user library stories from DB
        List<Story> userLibraryStories = StoryDAO.getUserLibraryStories(userId);
        session.setAttribute("userLibraryStories", userLibraryStories); // Set session attribute

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}

