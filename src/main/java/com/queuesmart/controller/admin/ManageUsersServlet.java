package com.queuesmart.controller.admin;

import com.queuesmart.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Admin user management — list, approve, suspend, delete users.
 */
@WebServlet("/admin/users")
public class ManageUsersServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("users", userDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/admin/manageUsers.jsp").forward(req, res);
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String userIdStr = req.getParameter("userId");

        if (userIdStr == null || action == null) {
            res.sendRedirect(req.getContextPath() + "/admin/users?error=invalid");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            switch (action) {
                case "approve":  userDAO.updateStatus(userId, "APPROVED");  break;
                case "suspend":  userDAO.updateStatus(userId, "SUSPENDED"); break;
                case "delete":   userDAO.delete(userId); break;
                default:
                    res.sendRedirect(req.getContextPath() + "/admin/users?error=unknown_action");
                    return;
            }
            res.sendRedirect(req.getContextPath() + "/admin/users?success=" + action);

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/admin/users?error=invalid_id");
        } catch (Exception e) {
            getServletContext().log("User management error", e);
            res.sendRedirect(req.getContextPath() + "/admin/users?error=system");
        }
    }
}