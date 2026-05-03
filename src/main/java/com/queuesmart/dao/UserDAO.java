package com.queuesmart.dao;

import com.queuesmart.model.User;
import com.queuesmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User-related database operations.
 * All SQL queries are centralized here to keep servlets clean.
 */
public class UserDAO {

    /**
     * Inserts a new user into the database.
     * @return true if insertion succeeded
     */
    public boolean register(User user) throws Exception {
        String sql = "INSERT INTO users (full_name, email, password, phone, role, status) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());   // already hashed
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Finds a user by email — used during login.
     * @return User object or null if not found
     */
    public User findByEmail(String email) throws Exception {
        String sql = "SELECT * FROM users WHERE users.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    /**
     * Finds a user by their primary key ID.
     */
    public User findById(int id) throws Exception {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    /**
     * Checks if an email is already registered.
     */
    public boolean emailExists(String email) throws Exception {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            return ps.executeQuery().next();
        }
    }

    public boolean phoneExists(String phone) throws Exception {
        String sql = "SELECT id FROM users WHERE phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);
            return ps.executeQuery().next();
        }
    }

    /**
     * Returns all users with a specific role for admin management.
     */
    public List<User> findByRole(String role) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapRow(rs));
            }
        }
        return users;
    }

    /**
     * Returns all users (for admin dashboard).
     */
    public List<User> findAll() throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {

            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                users.add(mapRow(rs));
            }
        }
        return users;
    }

    /**
     * Updates the status of a user account (APPROVED / SUSPENDED).
     */
    public boolean updateStatus(int userId, String status) throws Exception {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Updates user profile information.
     */
    public boolean updateProfile(User user) throws Exception {
        String sql = "UPDATE users SET full_name=?, phone=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setInt(3, user.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Updates the password (already hashed before calling this).
     */
    public boolean updatePassword(int userId, String newHashedPassword) throws Exception {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Updates the password by email (used in forgot password flow).
     */
    public void updatePasswordByEmail(String email, String newHashedPassword) throws Exception {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        }
    }

    /**
     * Deletes a user (admin only operation).
     */
    public boolean delete(int userId) throws Exception {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Total count of users by role — for admin stats cards.
     */
    public int countByRole(String role) throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Maps a ResultSet row to a User object. */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}