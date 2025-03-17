package com.dashboard.servlets;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebFilter("/*")
public class NotificationFilter implements Filter {
 public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
         throws IOException, ServletException {
     HttpServletRequest httpRequest = (HttpServletRequest) request;
     HttpServletResponse httpResponse = (HttpServletResponse) response;

     // Call the UnreadNotificationServlet to fetch unread notifications
     httpRequest.getRequestDispatcher("/UnreadNotificationServlet").include(httpRequest, httpResponse);

     // Continue the filter chain
     chain.doFilter(request, response);
 }

 @Override
 public void init(FilterConfig filterConfig) throws ServletException {}

 @Override
 public void destroy() {}
}