package com.queuesmart.controller.admin;

import com.queuesmart.dao.ServiceDAO;
import com.queuesmart.util.FileLogger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Admin service management — list, approve, reject/delete services.
 */
@WebServlet("/admin/services")
public class ManageServicesServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("services", serviceDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/admin/manageServices.jsp").forward(req, res);
        } catch (Exception e) {
            FileLogger.error("Error loading services for admin", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String serviceIdStr = req.getParameter("serviceId");

        if (serviceIdStr == null || action == null) {
            res.sendRedirect(req.getContextPath() + "/admin/services?error=invalid");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            switch (action) {
                case "approve":  
                    serviceDAO.updateStatus(serviceId, "ACTIVE");  
                    FileLogger.info("Admin approved service ID: " + serviceId);
                    break;
                case "suspend":  
                    serviceDAO.updateStatus(serviceId, "INACTIVE"); 
                    FileLogger.info("Admin suspended service ID: " + serviceId);
                    break;
                case "delete":   
                    serviceDAO.delete(serviceId); 
                    FileLogger.info("Admin deleted service ID: " + serviceId);
                    break;
                default:
                    res.sendRedirect(req.getContextPath() + "/admin/services?error=unknown_action");
                    return;
            }
            res.sendRedirect(req.getContextPath() + "/admin/services?success=" + action);

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/admin/services?error=invalid_id");
        } catch (Exception e) {
            FileLogger.error("Service management error", e);
            res.sendRedirect(req.getContextPath() + "/admin/services?error=system");
        }
    }
}
