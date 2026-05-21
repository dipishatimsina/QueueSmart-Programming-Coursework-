package com.queuesmart.model;

import java.sql.Timestamp;

/**
 * Model class for a queue entry — tracks position and wait time.
 */
public class QueueEntry {

    private int id;
    private Integer bookingId;    // nullable — walk-ins have no booking
    private int serviceId;
    private String serviceName;
    private int customerId;
    private String customerName;
    private int queueNumber;
    private int estimatedWaitMinutes;
    private String status;        // WAITING, SERVING, COMPLETED, SKIPPED
    private Timestamp joinedAt;
    private Timestamp servedAt;
    
    // UI Helper property
    private int peopleAhead;

    public QueueEntry() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public int getQueueNumber() { return queueNumber; }
    public void setQueueNumber(int queueNumber) { this.queueNumber = queueNumber; }

    public int getEstimatedWaitMinutes() { return estimatedWaitMinutes; }
    public void setEstimatedWaitMinutes(int estimatedWaitMinutes) { this.estimatedWaitMinutes = estimatedWaitMinutes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getJoinedAt() { return joinedAt; }
    public void setJoinedAt(Timestamp joinedAt) { this.joinedAt = joinedAt; }

    public Timestamp getServedAt() { return servedAt; }
    public void setServedAt(Timestamp servedAt) { this.servedAt = servedAt; }

    public int getPeopleAhead() { return peopleAhead; }
    public void setPeopleAhead(int peopleAhead) { this.peopleAhead = peopleAhead; }
}