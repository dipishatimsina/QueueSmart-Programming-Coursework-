package com.queuesmart.service;

import com.queuesmart.dao.QueueDAO;
import com.queuesmart.model.QueueEntry;
import com.queuesmart.util.FileLogger;

import java.util.List;

public class QueueService {

    private final QueueDAO queueDAO;

    public QueueService() {
        this.queueDAO = new QueueDAO();
    }

    public List<QueueEntry> getQueueForService(int serviceId) {
        try {
            return queueDAO.findActiveByService(serviceId);
        } catch (Exception e) {
            FileLogger.error("Error fetching queue for service", e);
            return null;
        }
    }

    public boolean updateQueueStatus(int queueId, String status) {
        try {
            boolean result = queueDAO.updateStatus(queueId, status);
            if (result) FileLogger.info("Updated queue entry " + queueId + " status to " + status);
            return result;
        } catch (Exception e) {
            FileLogger.error("Error updating queue status", e);
            return false;
        }
    }
}
