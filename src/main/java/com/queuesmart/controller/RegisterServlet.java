package com.queuesmart.controller;

import com.queuesmart.dao.UserDAO;
import com.queuesmart.model.User;
import com.queuesmart.util.PasswordUtil;
import com.queuesmart.util.ValidationUtil;

import com.queuesmart.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles user registration for all roles.
 * GET  /register → shows the registration form
 * POST /register → validates and saves the new user
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

                
        // Read form fields
        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String phone    = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String role     = req.getParameter("role");

        // === Validation ===
        if (!ValidationUtil.isValidName(fullName)) {
            forwardWithError(req, res, "Full name must contain only letters and spaces (2–100 characters).");
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            forwardWithError(req, res, "Please enter a valid email address.");
            return;
        }
        if (!ValidationUtil.isValidPhone(phone)){
            forwardWithError(req, res, "Please enter a valid 10-digit phone number.");
            return;
        }
        if (!ValidationUtil.isStrongPassword(password)){
            forwardWithError(req, res, "Password must be 8+ characters with uppercase, lowercase, number and special character.");
            return;
        }
        if (!password.equals(confirmPassword)){
            forwardWithError(req, res, "Passwords do not match.");
            return;
        }
        if (role == null || (!role.equals("CUSTOMER") && !role.equals("PROVIDER"))) {
            forwardWithError(req, res, "Please select a valid role.");
            return;
        }

        try {
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);

            authService.register(user, password);
            
            com.queuesmart.util.FileLogger.info("New user registered: " + email + " (Role: " + role + ")");
            res.sendRedirect(req.getContextPath() + "/login?success=registered");

        } catch (Exception e) {
            com.queuesmart.util.FileLogger.error("Registration error for email: " + email, e);
            forwardWithError(req, res, e.getMessage() != null ? e.getMessage() : "System error during registration.");
        }
    }

    /** Helper to forward back to the form with an error message. */
    private void forwardWithError(HttpServletRequest req, HttpServletResponse res, String message)
            throws ServletException, IOException {
        req.setAttribute("errorMsg", message);
        req.setAttribute("fullName", req.getParameter("fullName"));
        req.setAttribute("email", req.getParameter("email"));
        req.setAttribute("phone", req.getParameter("phone"));
        req.setAttribute("role", req.getParameter("role"));
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
    }
}
