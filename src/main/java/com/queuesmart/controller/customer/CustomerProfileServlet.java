package com.queuesmart.controller.customer;

import com.queuesmart.dao.UserDAO;
import com.queuesmart.model.User;
import com.queuesmart.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles viewing and updating customer profile.
 */
@WebServlet("/customer/profile")
public class CustomerProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || !"CUSTOMER".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            User user = userDAO.findById(userId);
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, res);
        } catch (Exception e) {
            getServletContext().log("Profile Error", e);
            res.sendRedirect(req.getContextPath() + "/customer/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || !"CUSTOMER".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");

        try {
            if ("updateDetails".equals(action)) {
                String fullName = req.getParameter("fullName");
                String phone = req.getParameter("phone");

                User user = new User();
                user.setId(userId);
                user.setFullName(fullName);
                user.setPhone(phone);

                if (userDAO.updateProfile(user)) {
                    session.setAttribute("userName", fullName); // Update session name
                    req.setAttribute("successMsg", "Profile updated successfully!");
                } else {
                    req.setAttribute("errorMsg", "Failed to update profile.");
                }

            } else if ("updatePassword".equals(action)) {
                String newPassword = req.getParameter("newPassword");
                
                if (newPassword == null || !newPassword.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!]).{8,}$")) {
                    req.setAttribute("errorMsg", "Password does not meet security requirements.");
                } else {
                    String hashed = PasswordUtil.hash(newPassword);
                    if (userDAO.updatePassword(userId, hashed)) {
                        req.setAttribute("successMsg", "Password updated successfully!");
                    } else {
                        req.setAttribute("errorMsg", "Failed to update password.");
                    }
                }
            }

            // Reload user data
            User user = userDAO.findById(userId);
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, res);

        } catch (Exception e) {
            getServletContext().log("Profile Update Error", e);
            req.setAttribute("errorMsg", "System error: " + e.getMessage());
            try {
                User user = userDAO.findById(userId);
                req.setAttribute("user", user);
            } catch (Exception ignored) {}
            req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, res);
        }
    }
}
