package com.dashboard.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dashboard.utils.DBConnection;

@WebServlet("/GetFollowCountsServlet")
public class GetFollowCountsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");

        if (username == null) {
            response.getWriter().write("error");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            int followersCount = getFollowersCount(username, conn);
            int followingCount = getFollowersCount(username, conn);
            conn.close();

            // Return counts as plain text (comma-separated)
            response.getWriter().write(followersCount + "," + followingCount);
            System.out.println("Updated counts: " + followersCount + " followers, " + followingCount + " following"); // Debugging

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }

	private int getFollowersCount(String username, Connection conn) {
		// TODO Auto-generated method stub
		return 0;
	}
}
