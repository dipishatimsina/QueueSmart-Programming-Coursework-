package com.queuesmart.controller;

import com.queuesmart.service.AuthService;
import com.queuesmart.model.User;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.servlet.http.Cookie;

import java.io.IOException;

/**
 * Handles login for all roles.
 * GET  /login → shows the login page
 * POST /login → authenticates the user and creates session
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Check for existing session or Remember Me cookie
        HttpSession existing = req.getSession(false);
        if (existing != null && existing.getAttribute("userId") != null) {
            redirectToDashboard(req, res, (String) existing.getAttribute("userRole"));
            return;
        }

        // Check for Remember Me cookie
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberMe_email".equals(cookie.getName())) {
                    req.setAttribute("rememberedEmail", cookie.getValue());
                }
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
    }

    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMsg", "Email and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
            return;
        }

        try {
            User user = authService.login(email.trim(), password);

            if (user == null) {
                com.queuesmart.util.FileLogger.info("Failed login attempt for email: " + email);
                req.setAttribute("errorMsg", "Invalid email or password.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
                return;
            }

            // Check account approval status
            if ("PENDING".equals(user.getStatus())) {
                res.sendRedirect(req.getContextPath() + "/pendingApproval");
                return;
            }
            if ("SUSPENDED".equals(user.getStatus())) {
                req.setAttribute("errorMsg", "Your account has been suspended. Contact support.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
                return;
            }

            // Create session — invalidate old session first to prevent session fixation
            req.getSession(false);
            if (req.getSession(false) != null) req.getSession(false).invalidate();
            HttpSession session = req.getSession(true);
            session.setMaxInactiveInterval(30 * 60); // 30 minute timeout

            // Store user info in session
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userRole", user.getRole());

            // Remember Me Cookie
            String rememberMe = req.getParameter("rememberMe");
            if ("true".equals(rememberMe)) {
                Cookie emailCookie = new Cookie("rememberMe_email", user.getEmail());
                emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                res.addCookie(emailCookie);
            } else {
                // Clear cookie if not checked
                Cookie emailCookie = new Cookie("rememberMe_email", "");
                emailCookie.setMaxAge(0);
                res.addCookie(emailCookie);
            }

            com.queuesmart.util.FileLogger.info("Successful login for user ID: " + user.getId() + " Role: " + user.getRole());

            // Redirect to appropriate dashboard
            redirectToDashboard(req, res, user.getRole());

        } catch (Exception e) {
            com.queuesmart.util.FileLogger.error("Login error", e);
            req.setAttribute("errorMsg", "System error: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
        }
    }

    
    /** Redirects the user to the dashboard matching their role. */
    private void redirectToDashboard(HttpServletRequest req, HttpServletResponse res, String role)
            throws IOException {
        String ctx = req.getContextPath();
        switch (role) {
            case "ADMIN":    res.sendRedirect(ctx + "/admin/dashboard"); break;
            case "PROVIDER": res.sendRedirect(ctx + "/provider/dashboard"); break;
            default:         res.sendRedirect(ctx + "/customer/dashboard"); break;
        }
    }
}
