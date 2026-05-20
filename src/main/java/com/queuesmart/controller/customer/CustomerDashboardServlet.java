package com.queuesmart.controller.customer;

import com.queuesmart.dao.BookingDAO;
import com.queuesmart.dao.QueueDAO;
import com.queuesmart.dao.ServiceDAO;
import com.queuesmart.dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Customer dashboard — shows bookings, active queue, and available services.
 */
@WebServlet("/customer/dashboard")
public class CustomerDashboardServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final QueueDAO queueDAO = new QueueDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int customerId = (int) req.getSession().getAttribute("userId");

        try {
            java.util.List<com.queuesmart.model.QueueEntry> activeQueues = queueDAO.findActiveByCustomer(customerId);
            for (com.queuesmart.model.QueueEntry q : activeQueues) {
                if ("WAITING".equals(q.getStatus())) {
                    int ahead = queueDAO.countAhead(q.getServiceId(), q.getQueueNumber());
                    q.setPeopleAhead(ahead);
                    // Update estimated wait dynamically based on 10 mins per person
                    q.setEstimatedWaitMinutes(ahead * 10);
                }
            }
            
            req.setAttribute("activeQueues", activeQueues);
            req.setAttribute("pastQueues", queueDAO.findPastByCustomer(customerId));
            req.setAttribute("recentBookings", bookingDAO.findByCustomer(customerId));
            req.setAttribute("activeServices", serviceDAO.findAllActive());
            req.setAttribute("myFeedback", feedbackDAO.findByCustomer(customerId));
            req.getRequestDispatcher("/WEB-INF/views/customer/dashboard.jsp").forward(req, res);
        } catch (Exception e) {
            getServletContext().log("Customer dashboard error", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }
}