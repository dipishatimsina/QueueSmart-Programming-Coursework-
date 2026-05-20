
package com.queuesmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles public static pages like About and Contact.
 */
@WebServlet(urlPatterns = {"/about", "/contact"})
public class PublicPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/about".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/about.jsp").forward(req, res);
        } else if ("/contact".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, res);
        } else {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/contact".equals(path)) {
            // Process contact form inquiry
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String message = req.getParameter("message");

            com.queuesmart.util.FileLogger.info("Contact Inquiry from " + name + " (" + email + "): " + message);

            req.setAttribute("successMsg", "Thank you for contacting us! We will get back to you shortly.");
            req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, res);
        }
    }
}
