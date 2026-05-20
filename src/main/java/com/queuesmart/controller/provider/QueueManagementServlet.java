package com.queuesmart.controller.provider;

import com.queuesmart.dao.QueueDAO;
import com.queuesmart.util.FileLogger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Provider queue management — view queue for a service and update status.
 */
@WebServlet("/provider/queue")
public class QueueManagementServlet extends HttpServlet {

    private final QueueDAO queueDAO = new QueueDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        String serviceIdStr = req.getParameter("serviceId");
        
        if (serviceIdStr == null || serviceIdStr.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/provider/services?error=no_service_selected");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            req.setAttribute("serviceId", serviceId);
            req.setAttribute("queueEntries", queueDAO.findActiveByService(serviceId));
            req.getRequestDispatcher("/WEB-INF/views/provider/queueManagement.jsp").forward(req, res);
            
        } catch (Exception e) {
            FileLogger.error("Error loading queue for service", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String queueIdStr = req.getParameter("queueId");
        String status = req.getParameter("status");
        String serviceIdStr = req.getParameter("serviceId");

        try {
            int queueId = Integer.parseInt(queueIdStr);
            queueDAO.updateStatus(queueId, status);
            FileLogger.info("Queue Entry " + queueId + " status updated to " + status);
            res.sendRedirect(req.getContextPath() + "/provider/queue?serviceId=" + serviceIdStr + "&success=updated");
            
        } catch (Exception e) {
            FileLogger.error("Error updating queue status", e);
            res.sendRedirect(req.getContextPath() + "/provider/queue?serviceId=" + serviceIdStr + "&error=system");
        }
    }
}
