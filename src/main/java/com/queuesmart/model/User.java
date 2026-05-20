package com.queuesmart.model;

import java.sql.Timestamp;

/**
 * Model class representing a user in the system.
 * Matches the 'users' table in the database.
 */
public class User {

    private int id;
    private String fullName;
    private String email;
    private String password;   // stored as BCrypt hash
    private String phone;
    private String role;       // CUSTOMER, PROVIDER, ADMIN
    private String status;     // PENDING, APPROVED, SUSPENDED
    private Timestamp createdAt;

    // Default constructor required for instantiation from DAO
    public User() {}

    public User(String fullName, String email, String password,
                String phone, String role) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.status = "PENDING";
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}