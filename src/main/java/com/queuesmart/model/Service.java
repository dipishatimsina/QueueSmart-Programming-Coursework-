package com.queuesmart.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model class representing a service offered by a provider.
 * Matches the 'services' table in the database.
 */
public class Service {

    private int id;
    private int providerId;
    private String providerName;    // Joined from users table for display
    private String serviceName;
    private String description;
    private String category;
    private BigDecimal price;
    private int durationMinutes;
    private int capacityPerSlot;
    private String status;          // ACTIVE, INACTIVE, PENDING_APPROVAL
    private Timestamp createdAt;

    public Service() {}

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public String getProviderName() { return providerName; }
    public void setProviderName(String providerName) { this.providerName = providerName; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }

    public int getCapacityPerSlot() { return capacityPerSlot; }
    public void setCapacityPerSlot(int capacityPerSlot) { this.capacityPerSlot = capacityPerSlot; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}