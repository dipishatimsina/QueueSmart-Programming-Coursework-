package com.queuesmart.dao;

import com.queuesmart.model.Feedback;
import com.queuesmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean create(Feedback feedback) throws Exception {
        String sql = "INSERT INTO feedback (customer_id, service_id, provider_id, rating, comments) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedback.getCustomerId());
            ps.setInt(2, feedback.getServiceId());
            ps.setInt(3, feedback.getProviderId());
            ps.setInt(4, feedback.getRating());
            ps.setString(5, feedback.getComments());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Feedback> findByProvider(int providerId) throws Exception {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name AS customer_name, s.service_name " +
                "FROM feedback f " +
                "JOIN users u ON f.customer_id = u.id " +
                "JOIN services s ON f.service_id = s.id " +
                "WHERE f.provider_id = ? " +
                "ORDER BY f.created_at DESC LIMIT 50";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<Feedback> findByCustomer(int customerId) throws Exception {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name AS customer_name, s.service_name " +
                "FROM feedback f " +
                "JOIN users u ON f.customer_id = u.id " +
                "JOIN services s ON f.service_id = s.id " +
                "WHERE f.customer_id = ? " +
                "ORDER BY f.created_at DESC LIMIT 50";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public boolean hasSubmittedFeedback(int customerId, int serviceId) throws Exception {
        String sql = "SELECT 1 FROM feedback WHERE customer_id = ? AND service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, serviceId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    private Feedback mapRow(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getInt("id"));
        f.setCustomerId(rs.getInt("customer_id"));
        f.setCustomerName(rs.getString("customer_name"));
        f.setServiceId(rs.getInt("service_id"));
        f.setServiceName(rs.getString("service_name"));
        f.setProviderId(rs.getInt("provider_id"));
        f.setRating(rs.getInt("rating"));
        f.setComments(rs.getString("comments"));
        f.setCreatedAt(rs.getTimestamp("created_at"));
        return f;
    }

}
