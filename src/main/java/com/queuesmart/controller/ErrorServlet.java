package com.queuesmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles error rendering.
 */
@WebServlet("/error")
public class ErrorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String code = req.getParameter("code");
        if ("403".equals(code)) {
            req.setAttribute("errorTitle", "Access Denied");
            req.setAttribute("errorMessage", "You do not have permission to view this page.");
        } else {
            req.setAttribute("errorTitle", "System Error");
            req.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
        }
        req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, res);
    }
}
