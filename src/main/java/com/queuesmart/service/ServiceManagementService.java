package com.queuesmart.service;

import com.queuesmart.dao.ServiceDAO;
import com.queuesmart.model.Service;
import com.queuesmart.util.FileLogger;

import java.util.List;

public class ServiceManagementService {

    private final ServiceDAO serviceDAO;

    public ServiceManagementService() {
        this.serviceDAO = new ServiceDAO();
    }

    public List<Service> getAllServices() {
        try {
            return serviceDAO.findAll();
        } catch (Exception e) {
            FileLogger.error("Error fetching all services", e);
            return null;
        }
    }

    public List<Service> getServicesByProvider(int providerId) {
        try {
            return serviceDAO.findByProvider(providerId);
        } catch (Exception e) {
            FileLogger.error("Error fetching provider services", e);
            return null;
        }
    }

    public boolean createService(Service service) {
        try {
            return serviceDAO.create(service);
        } catch (Exception e) {
            FileLogger.error("Error creating service", e);
            return false;
        }
    }

    public boolean updateServiceStatus(int serviceId, String status) {
        try {
            boolean result = serviceDAO.updateStatus(serviceId, status);
            if (result) FileLogger.info("Updated service " + serviceId + " status to " + status);
            return result;
        } catch (Exception e) {
            FileLogger.error("Error updating service status", e);
            return false;
        }
    }

    public boolean deleteService(int serviceId) {
        try {
            boolean result = serviceDAO.delete(serviceId);
            if (result) FileLogger.info("Deleted service " + serviceId);
            return result;
        } catch (Exception e) {
            FileLogger.error("Error deleting service", e);
            return false;
        }
    }
}
