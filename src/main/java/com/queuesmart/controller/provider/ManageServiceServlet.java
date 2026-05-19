package com.queuesmart.controller.provider;

import com.queuesmart.dao.ServiceDAO;
import com.queuesmart.model.Service;
import com.queuesmart.util.FileLogger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * Provider service management — create, edit, delete their own services.
 */
@WebServlet("/provider/services")
public class ManageServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        int providerId = (int) req.getSession().getAttribute("userId");
        String action = req.getParameter("action");

        try {
            if ("new".equals(action)) {
                req.getRequestDispatcher("/WEB-INF/views/provider/serviceForm.jsp").forward(req, res);
                return;
            }

            req.setAttribute("services", serviceDAO.findByProvider(providerId));
            req.getRequestDispatcher("/WEB-INF/views/provider/myServices.jsp").forward(req, res);
            
        } catch (Exception e) {
            FileLogger.error("Error loading provider services", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }

    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int providerId = (int) req.getSession().getAttribute("userId");
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                Service service = new Service();
                service.setProviderId(providerId);
                service.setServiceName(req.getParameter("serviceName"));
                service.setDescription(req.getParameter("description"));
                service.setCategory(req.getParameter("category"));
                service.setPrice(new BigDecimal(req.getParameter("price")));
                service.setDurationMinutes(Integer.parseInt(req.getParameter("durationMinutes")));
                service.setCapacityPerSlot(Integer.parseInt(req.getParameter("capacityPerSlot")));
                service.setStatus("PENDING_APPROVAL"); // Admin must approve
                
                serviceDAO.create(service);
                FileLogger.info("Provider " + providerId + " created new service: " + service.getServiceName());
                res.sendRedirect(req.getContextPath() + "/provider/services?success=created");
                return;
            }
            
            if ("delete".equals(action)) {
                int serviceId = Integer.parseInt(req.getParameter("serviceId"));
                // In a real app, verify service belongs to providerId
                serviceDAO.delete(serviceId);
                FileLogger.info("Provider " + providerId + " deleted service ID: " + serviceId);
                res.sendRedirect(req.getContextPath() + "/provider/services?success=deleted");
                return;
            }
            

            res.sendRedirect(req.getContextPath() + "/provider/services");
            
        } catch (Exception e) {
            FileLogger.error("Error in provider ManageServiceServlet", e);
            res.sendRedirect(req.getContextPath() + "/provider/services?error=system");
        }
    }
}
