package com.queuesmart.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for BCrypt password hashing and verification.
 * Never store plain-text passwords — always hash before saving.
 */
public class PasswordUtil {

    /**
     * Hashes a plain-text password using BCrypt with cost factor 12.
     * @param plainPassword the raw password from the form
     * @return the BCrypt hashed string to store in the database
     */
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Checks if a plain-text password matches a stored BCrypt hash.
     * @param plainPassword the password entered by the user
     * @param hashedPassword the hash stored in the database
     * @return true if they match, false otherwise
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}




