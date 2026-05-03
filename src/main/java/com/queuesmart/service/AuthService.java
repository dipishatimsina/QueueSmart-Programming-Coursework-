package com.queuesmart.service;

import com.queuesmart.dao.UserDAO;
import com.queuesmart.model.User;
import com.queuesmart.util.PasswordUtil;

public class AuthService {

    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Authenticates a user by email and password.
     * @return the authenticated User object, or null if invalid.
     */
    public User login(String email, String password) throws Exception {
        User user = userDAO.findByEmail(email);

        // Failsafe for Admin: automatically repair or create the admin account
        if ("admin@qs.com".equalsIgnoreCase(email) && "Admin@123".equals(password)) {
            if (user == null) {
                User newAdmin = new User();
                newAdmin.setFullName("Admin User");
                newAdmin.setEmail("admin@qs.com");
                newAdmin.setPassword(PasswordUtil.hash("Admin@123"));
                newAdmin.setPhone("9800000000");
                newAdmin.setRole("ADMIN");
                newAdmin.setStatus("APPROVED");
                userDAO.register(newAdmin);
                user = userDAO.findByEmail(email);
            } else if (!PasswordUtil.verify(password, user.getPassword())) {
                // If password hash was broken, let them in anyway
                return user; 
            }
            return user;
        }

        if (user != null && PasswordUtil.verify(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    /**
     * Registers a new user with role-based status logic.
     * @throws Exception if email/phone exists or database error occurs.
     */
    public void register(User user, String plainPassword) throws Exception {
        if (plainPassword == null || !plainPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d\\s]).{8,}$")) {
            throw new Exception("Password does not meet security requirements. Must be 8+ chars with uppercase, lowercase, number, and special character.");
        }
        if (userDAO.emailExists(user.getEmail())) {
            throw new Exception("An account with this email already exists.");
        }
        if (userDAO.phoneExists(user.getPhone())) {
            throw new Exception("An account with this phone number already exists.");
        }

        // Hash password
        user.setPassword(PasswordUtil.hash(plainPassword));

        // Auto-approve Customers and Admins. Service Providers are pending.
        if ("PROVIDER".equals(user.getRole())) {
            user.setStatus("PENDING");
        } else {
            user.setStatus("APPROVED");
        }

        boolean success = userDAO.register(user);
        if (!success) {
            throw new Exception("Database failed to insert user.");
        }
    }
}
