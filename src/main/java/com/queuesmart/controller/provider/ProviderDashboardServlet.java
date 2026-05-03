package com.queuesmart.controller.provider;

import com.queuesmart.dao.BookingDAO;
import com.queuesmart.dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Provider dashboard — shows their services and pending bookings.
 */
@WebServlet("/provider/dashboard")
public class ProviderDashboardServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final com.queuesmart.dao.FeedbackDAO feedbackDAO = new com.queuesmart.dao.FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int providerId = (int) req.getSession().getAttribute("userId");

        try {
            req.setAttribute("myServices", serviceDAO.findByProvider(providerId));
            req.setAttribute("pendingBookings", bookingDAO.findByProvider(providerId)
                    .stream().filter(b -> "PENDING".equals(b.getStatus())).toList());
            req.setAttribute("recentFeedback", feedbackDAO.findByProvider(providerId));
            req.getRequestDispatcher("/WEB-INF/views/provider/dashboard.jsp").forward(req, res);
        } catch (Exception e) {
            getServletContext().log("Provider dashboard error", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }
}