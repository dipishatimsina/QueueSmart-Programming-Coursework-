package com.queuesmart.service;

import com.queuesmart.dao.UserDAO;
import com.queuesmart.model.User;
import com.queuesmart.util.FileLogger;

import java.util.List;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public List<User> getAllUsers() {
        try {
            return userDAO.findAll();
        } catch (Exception e) {
            FileLogger.error("Error fetching all users", e);
            return null;
        }
    }

    public boolean updateUserStatus(int userId, String status) {
        try {
            boolean result = userDAO.updateStatus(userId, status);
            if (result) FileLogger.info("Updated user " + userId + " status to " + status);
            return result;
        } catch (Exception e) {
            FileLogger.error("Error updating user status", e);
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        try {
            boolean result = userDAO.delete(userId);
            if (result) FileLogger.info("Deleted user " + userId);
            return result;
        } catch (Exception e) {
            FileLogger.error("Error deleting user", e);
            return false;
        }
    }
}
