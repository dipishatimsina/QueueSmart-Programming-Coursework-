package com.queuesmart.util;

/**
 * Common input validation methods used across the application.
 */
public class ValidationUtil {

    /** Returns true if the string is null or empty after trimming. */
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /** Validates email format using a basic regex pattern. */
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    /** Ensures full name contains only letters and spaces (no numbers). */
    public static boolean isValidName(String name) {
        if (isEmpty(name)) return false;
        return name.matches("^[a-zA-Z ]{2,100}$");
    }

    /** Phone number: 10 digits only. */
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) return false;
        return phone.matches("^\\d{10}$");
    }

    /**
     * Password must be at least 8 chars, contain one uppercase,
     * one lowercase, one digit, and one special character.
     */
    public static boolean isStrongPassword(String password) {
        if (isEmpty(password)) return false;
        return password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d\\s]).{8,}$");
    }
}