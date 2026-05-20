package com.queuesmart.dao;

import com.queuesmart.model.QueueEntry;
import com.queuesmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Queue operations.
 * Implements FIFO queue logic with auto-incrementing queue numbers per service.
 */
public class QueueDAO {

    /**
     * Adds a customer to the queue for a service.
     * Calculates next queue number and estimated wait automatically.
     * @return the new QueueEntry with assigned queue number
     */
    public QueueEntry joinQueue(int serviceId, int customerId, Integer bookingId) throws Exception {
        Connection conn = DBConnection.getConnection();
        try {
            conn.setAutoCommit(false); // transaction — ensures no duplicate queue numbers

            // Get the next queue number for this service (max + 1)
            int nextNumber = 1;
            String maxSql = "SELECT MAX(queue_number) FROM queue_entries WHERE service_id = ? AND DATE(joined_at) = CURDATE()";
            PreparedStatement maxPs = conn.prepareStatement(maxSql);
            maxPs.setInt(1, serviceId);
            ResultSet maxRs = maxPs.executeQuery();
            if (maxRs.next() && maxRs.getObject(1) != null) {
                nextNumber = maxRs.getInt(1) + 1;
            }

            // Count people ahead and calculate estimated wait
            String countSql = "SELECT COUNT(*), s.duration_minutes FROM queue_entries qe " +
                    "JOIN services s ON qe.service_id = s.id " +
                    "WHERE qe.service_id = ? AND qe.status = 'WAITING' GROUP BY s.duration_minutes";
            PreparedStatement countPs = conn.prepareStatement(countSql);
            countPs.setInt(1, serviceId);
            ResultSet countRs = countPs.executeQuery();

            int waitMinutes = 0;
            if (countRs.next()) {
                int ahead = countRs.getInt(1);
                int duration = countRs.getInt(2);
                waitMinutes = ahead * duration;
            }

            // Insert the queue entry
            String insertSql = "INSERT INTO queue_entries (booking_id, service_id, customer_id, queue_number, estimated_wait_minutes, status) VALUES (?,?,?,?,?,?)";
            PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            insertPs.setObject(1, bookingId, Types.INTEGER);
            insertPs.setInt(2, serviceId);
            insertPs.setInt(3, customerId);
            insertPs.setInt(4, nextNumber);
            insertPs.setInt(5, waitMinutes);
            insertPs.setString(6, "WAITING");
            insertPs.executeUpdate();

            conn.commit();

            // Build and return the entry object
            QueueEntry entry = new QueueEntry();
            entry.setServiceId(serviceId);
            entry.setCustomerId(customerId);
            entry.setBookingId(bookingId);
            entry.setQueueNumber(nextNumber);
            entry.setEstimatedWaitMinutes(waitMinutes);
            entry.setStatus("WAITING");

            ResultSet keys = insertPs.getGeneratedKeys();
            if (keys.next()) entry.setId(keys.getInt(1));

            return entry;

        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    /** Gets the current queue entry for a customer in a service. */
    public QueueEntry findByCustomerAndService(int customerId, int serviceId) throws Exception {
        String sql = "SELECT qe.*, s.service_name, u.full_name as customer_name FROM queue_entries qe " +
                "JOIN services s ON qe.service_id = s.id " +
                "JOIN users u ON qe.customer_id = u.id " +
                "WHERE qe.customer_id = ? AND qe.service_id = ? AND qe.status IN ('WAITING','SERVING') " +
                "ORDER BY qe.joined_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, serviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /** Gets all waiting entries for a service (for provider view). */
    public List<QueueEntry> findWaitingByService(int serviceId) throws Exception {
        List<QueueEntry> list = new ArrayList<>();
        String sql = "SELECT qe.*, s.service_name, u.full_name as customer_name FROM queue_entries qe " +
                "JOIN services s ON qe.service_id = s.id " +
                "JOIN users u ON qe.customer_id = u.id " +
                "WHERE qe.service_id = ? AND qe.status = 'WAITING' ORDER BY qe.queue_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Gets all active (WAITING or SERVING) entries for a service. */
    public List<QueueEntry> findActiveByService(int serviceId) throws Exception {
        List<QueueEntry> list = new ArrayList<>();
        String sql = "SELECT qe.*, s.service_name, u.full_name as customer_name FROM queue_entries qe " +
                "JOIN services s ON qe.service_id = s.id " +
                "JOIN users u ON qe.customer_id = u.id " +
                "WHERE qe.service_id = ? AND qe.status IN ('WAITING', 'SERVING') ORDER BY qe.queue_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Gets all completed or skipped entries for a customer (past history). */
    public List<QueueEntry> findPastByCustomer(int customerId) throws Exception {
        List<QueueEntry> list = new ArrayList<>();
        String sql = "SELECT qe.*, s.service_name, u.full_name as customer_name FROM queue_entries qe " +
                "JOIN services s ON qe.service_id = s.id " +
                "JOIN users u ON qe.customer_id = u.id " +
                "WHERE qe.customer_id = ? AND qe.status IN ('COMPLETED', 'SKIPPED') " +
                "ORDER BY qe.joined_at DESC LIMIT 20";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Updates queue entry status (SERVING / COMPLETED / SKIPPED). */
    public boolean updateStatus(int entryId, String status) throws Exception {
        String sql = "UPDATE queue_entries SET status = ?, served_at = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, status.equals("SERVING") || status.equals("COMPLETED")
                    ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(3, entryId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Count of people ahead of a given queue number for a service. */
    public int countAhead(int serviceId, int queueNumber) throws Exception {
        String sql = "SELECT COUNT(*) FROM queue_entries WHERE service_id = ? AND queue_number < ? AND status = 'WAITING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ps.setInt(2, queueNumber);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Total queue count for admin stats. */
    public int countActiveQueues() throws Exception {
        String sql = "SELECT COUNT(*) FROM queue_entries WHERE status = 'WAITING'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    /** Gets all active (WAITING or SERVING) entries for a customer. */
    public List<QueueEntry> findActiveByCustomer(int customerId) throws Exception {
        List<QueueEntry> list = new ArrayList<>();
        String sql = "SELECT qe.*, s.service_name, u.full_name as customer_name FROM queue_entries qe " +
                "JOIN services s ON qe.service_id = s.id " +
                "JOIN users u ON qe.customer_id = u.id " +
                "WHERE qe.customer_id = ? AND qe.status IN ('WAITING', 'SERVING') ORDER BY qe.joined_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private QueueEntry mapRow(ResultSet rs) throws SQLException {
        QueueEntry q = new QueueEntry();
        q.setId(rs.getInt("id"));
        q.setServiceId(rs.getInt("service_id"));
        q.setServiceName(rs.getString("service_name"));
        q.setCustomerId(rs.getInt("customer_id"));
        q.setCustomerName(rs.getString("customer_name"));
        q.setQueueNumber(rs.getInt("queue_number"));
        q.setEstimatedWaitMinutes(rs.getInt("estimated_wait_minutes"));
        q.setStatus(rs.getString("status"));
        q.setJoinedAt(rs.getTimestamp("joined_at"));
        q.setServedAt(rs.getTimestamp("served_at"));
        try { q.setBookingId(rs.getInt("booking_id")); } catch (SQLException ignored) {}
        return q;
    }
}