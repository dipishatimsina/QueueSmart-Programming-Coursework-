package com.queuesmart.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * Model class representing a service booking made by a customer.
 */
public class Booking {

    private int id;
    private int customerId;
    private String customerName;
    private int serviceId;
    private String serviceName;
    private Date bookingDate;
    private Time timeSlot;
    private String status;   // PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
    private String notes;
    private Timestamp createdAt;

    public Booking() {}

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public Time getTimeSlot() { return timeSlot; }
    public void setTimeSlot(Time timeSlot) { this.timeSlot = timeSlot; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}