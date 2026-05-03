package com.queuesmart.dao;

import com.queuesmart.model.Booking;
import com.queuesmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Booking operations.
 */
public class BookingDAO {

    /** Creates a new booking and returns the generated booking ID. */
    public int create(Booking booking) throws Exception {
        String sql = "INSERT INTO bookings (customer_id, service_id, booking_date, time_slot, notes, status) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, booking.getCustomerId());
            ps.setInt(2, booking.getServiceId());
            ps.setDate(3, booking.getBookingDate());
            ps.setTime(4, booking.getTimeSlot());
            ps.setString(5, booking.getNotes());
            ps.setString(6, "PENDING");
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        }
        return -1;
    }

    /** Gets all bookings for a specific customer. */
    public List<Booking> findByCustomer(int customerId) throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, s.service_name, u.full_name as customer_name FROM bookings b " +
                "JOIN services s ON b.service_id = s.id " +
                "JOIN users u ON b.customer_id = u.id " +
                "WHERE b.customer_id = ? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Gets all bookings for services offered by a provider. */
    public List<Booking> findByProvider(int providerId) throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, s.service_name, u.full_name as customer_name FROM bookings b " +
                "JOIN services s ON b.service_id = s.id " +
                "JOIN users u ON b.customer_id = u.id " +
                "WHERE s.provider_id = ? ORDER BY b.booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** All bookings for admin. */
    public List<Booking> findAll() throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, s.service_name, u.full_name as customer_name FROM bookings b " +
                "JOIN services s ON b.service_id = s.id " +
                "JOIN users u ON b.customer_id = u.id ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Updates booking status. */
    public boolean updateStatus(int bookingId, String status) throws Exception {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Total booking count for admin stats. */
    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setCustomerName(rs.getString("customer_name"));
        b.setServiceId(rs.getInt("service_id"));
        b.setServiceName(rs.getString("service_name"));
        b.setBookingDate(rs.getDate("booking_date"));
        b.setTimeSlot(rs.getTime("time_slot"));
        b.setStatus(rs.getString("status"));
        b.setNotes(rs.getString("notes"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }
}