package com.queuesmart.controller;

import com.queuesmart.dao.UserDAO;
import com.queuesmart.model.User;
import com.queuesmart.util.FileLogger;
import com.queuesmart.util.MailUtil;
import com.queuesmart.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Random;

@WebServlet(urlPatterns = {"/forgotPassword", "/verifyReset", "/resetPassword"})
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/forgotPassword.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/forgotPassword".equals(path)) {
                handleSendCode(req, res);
            } else if ("/verifyReset".equals(path)) {
                handleVerifyCode(req, res);
            } else if ("/resetPassword".equals(path)) {
                handleResetPassword(req, res);
            }
        } catch (Exception e) {
            FileLogger.error("Error in ForgotPassword flow", e);
            res.sendRedirect(req.getContextPath() + "/forgotPassword?error=System error occurred");
        }
    }

    private void handleSendCode(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String email = req.getParameter("email");
        if (email != null) email = email.trim();
        User user = userDAO.findByEmail(email);

        if (user == null) {
            // Tell the user explicitly that the email was not found
            res.sendRedirect(req.getContextPath() + "/forgotPassword?error=Email not found in our system");
            return;
        }

        // Generate 6-digit code
        String code = String.format("%06d", new Random().nextInt(999999));
        
        // Store in session (expires when browser closes)
        HttpSession session = req.getSession();
        session.setAttribute("resetCode", code);
        session.setAttribute("resetEmail", email);

        // Send email
        boolean sent = MailUtil.sendPasswordResetEmail(email, code);
        if (sent) {
            res.sendRedirect(req.getContextPath() + "/forgotPassword?step=verify&email=" + email);
        } else {
            res.sendRedirect(req.getContextPath() + "/forgotPassword?error=Failed to send email");
        }
    }

    private void handleVerifyCode(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession();
        String sessionCode = (String) session.getAttribute("resetCode");
        String inputCode = req.getParameter("code");

        if (sessionCode != null && sessionCode.equals(inputCode)) {
            res.sendRedirect(req.getContextPath() + "/forgotPassword?step=reset");
        } else {
            res.sendRedirect(req.getContextPath() + "/forgotPassword?step=verify&error=Invalid code");
        }
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse res) throws Exception {
        HttpSession session = req.getSession();
        String email = (String) session.getAttribute("resetEmail");
        String newPassword = req.getParameter("newPassword");

        if (email != null && newPassword != null && newPassword.length() >= 6) {
            String hashedPassword = PasswordUtil.hash(newPassword);
            userDAO.updatePasswordByEmail(email, hashedPassword);
            
            // Clear session
            session.removeAttribute("resetCode");
            session.removeAttribute("resetEmail");
            
            FileLogger.info("Password reset successful for user: " + email);
            res.sendRedirect(req.getContextPath() + "/index.jsp?success=Password reset successful");
        } else {
            res.sendRedirect(req.getContextPath() + "/forgotPassword?step=reset&error=Invalid password");
        }
    }
}
