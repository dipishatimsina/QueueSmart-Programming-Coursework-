package com.queuesmart.controller.admin;

import com.queuesmart.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Admin dashboard — shows summary statistics and quick-access actions.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final QueueDAO queueDAO = new QueueDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            // Fetch stats for dashboard cards
            req.setAttribute("totalCustomers", userDAO.countByRole("CUSTOMER"));
            req.setAttribute("totalProviders", userDAO.countByRole("PROVIDER"));
            req.setAttribute("totalServices", serviceDAO.countActive());
            req.setAttribute("totalBookings", bookingDAO.countAll());
            req.setAttribute("activeQueues", queueDAO.countActiveQueues());

            // Pending items needing attention
            req.setAttribute("pendingUsers", userDAO.findByRole("PROVIDER")
                    .stream().filter(u -> "PENDING".equals(u.getStatus())).count());

            req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, res);

        } catch (Exception e) {
            getServletContext().log("Admin dashboard error", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }
}