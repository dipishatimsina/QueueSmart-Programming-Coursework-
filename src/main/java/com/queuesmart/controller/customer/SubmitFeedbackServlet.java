package com.queuesmart.controller.customer;

import com.queuesmart.dao.FeedbackDAO;
import com.queuesmart.dao.ServiceDAO;
import com.queuesmart.model.Feedback;
import com.queuesmart.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/customer/feedback")
public class SubmitFeedbackServlet extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String serviceIdParam = req.getParameter("serviceId");
        if (serviceIdParam == null) {
            res.sendRedirect(req.getContextPath() + "/customer/dashboard");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdParam);
            Service service = serviceDAO.findById(serviceId);
            if (service == null) {
                res.sendRedirect(req.getContextPath() + "/customer/dashboard");
                return;
            }

            int customerId = (int) req.getSession().getAttribute("userId");
            if (feedbackDAO.hasSubmittedFeedback(customerId, serviceId)) {
                req.setAttribute("errorMsg", "You have already submitted feedback for this service.");
            }

            req.setAttribute("service", service);
            req.getRequestDispatcher("/WEB-INF/views/customer/feedback.jsp").forward(req, res);

        } catch (Exception e) {
            getServletContext().log("Feedback view error", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int customerId = (int) req.getSession().getAttribute("userId");
        int serviceId = Integer.parseInt(req.getParameter("serviceId"));
        int providerId = Integer.parseInt(req.getParameter("providerId"));
        int rating = Integer.parseInt(req.getParameter("rating"));
        String comments = req.getParameter("comments");

        try {
            if (!feedbackDAO.hasSubmittedFeedback(customerId, serviceId)) {
                Feedback feedback = new Feedback();
                feedback.setCustomerId(customerId);
                feedback.setServiceId(serviceId);
                feedback.setProviderId(providerId);
                feedback.setRating(rating);
                feedback.setComments(comments);
                feedbackDAO.create(feedback);
            }
            res.sendRedirect(req.getContextPath() + "/customer/dashboard?success=feedback_submitted");
        } catch (Exception e) {
            getServletContext().log("Feedback submit error", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }

}
