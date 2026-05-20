package com.queuesmart.dao;


import com.queuesmart.model.Service;
import com.queuesmart.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Service-related database operations.
 */
public class ServiceDAO {
    

    /**
     * Creates a new service. Status is PENDING_APPROVAL until admin approves.
     */
    public boolean create(Service service) throws Exception {
        String sql = "INSERT INTO services (provider_id, service_name, description, category, price, duration_minutes, capacity_per_slot, status) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, service.getProviderId());
            ps.setString(2, service.getServiceName());
            ps.setString(3, service.getDescription());
            ps.setString(4, service.getCategory());
            ps.setBigDecimal(5, service.getPrice());
            ps.setInt(6, service.getDurationMinutes());
            ps.setInt(7, service.getCapacityPerSlot());
            ps.setString(8, "PENDING_APPROVAL");
            return ps.executeUpdate() > 0;
        }
    }

    /** Returns all ACTIVE services — for customers to browse. */
    public List<Service> findAllActive() throws Exception {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name as provider_name FROM services s " +
                "JOIN users u ON s.provider_id = u.id WHERE s.status = 'ACTIVE' ORDER BY s.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }
    

    
    /** Returns all services for a specific provider. */
    public List<Service> findByProvider(int providerId) throws Exception {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name as provider_name FROM services s " +
                "JOIN users u ON s.provider_id = u.id WHERE s.provider_id = ? ORDER BY s.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Returns all services for admin management. */
    public List<Service> findAll() throws Exception {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name as provider_name FROM services s " +
                "JOIN users u ON s.provider_id = u.id ORDER BY s.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }
    

    /** Finds a service by its ID. */
    public Service findById(int id) throws Exception {
        String sql = "SELECT s.*, u.full_name as provider_name FROM services s " +
                "JOIN users u ON s.provider_id = u.id WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }
    

    /** Updates service details. */
    public boolean update(Service service) throws Exception {
        String sql = "UPDATE services SET service_name=?, description=?, category=?, price=?, duration_minutes=?, capacity_per_slot=? WHERE id=? AND provider_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setString(3, service.getCategory());
            ps.setBigDecimal(4, service.getPrice());
            ps.setInt(5, service.getDurationMinutes());
            ps.setInt(6, service.getCapacityPerSlot());
            ps.setInt(7, service.getId());
            ps.setInt(8, service.getProviderId());
            return ps.executeUpdate() > 0;
        }
    }
    

    /** Admin approves or deactivates a service. */
    public boolean updateStatus(int serviceId, String status) throws Exception {
        String sql = "UPDATE services SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Deletes a service. */
    public boolean delete(int id) throws Exception {
        String sql = "DELETE FROM services WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Count of total active services for admin stats. */
    public int countActive() throws Exception {
        String sql = "SELECT COUNT(*) FROM services WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private Service mapRow(ResultSet rs) throws SQLException {
        Service s = new Service();
        s.setId(rs.getInt("id"));
        s.setProviderId(rs.getInt("provider_id"));
        s.setProviderName(rs.getString("provider_name"));
        s.setServiceName(rs.getString("service_name"));
        s.setDescription(rs.getString("description"));
        s.setCategory(rs.getString("category"));
        s.setPrice(rs.getBigDecimal("price"));
        s.setDurationMinutes(rs.getInt("duration_minutes"));
        s.setCapacityPerSlot(rs.getInt("capacity_per_slot"));
        s.setStatus(rs.getString("status"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}
