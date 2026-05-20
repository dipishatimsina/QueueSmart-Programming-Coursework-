package com.queuesmart.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * Utility class that provides a singleton database connection.
 * Reads credentials from db.properties on the classpath.
 */
public class DBConnection {

    private static String url;
    private static String username;
    private static String password;

    // Static initializer loads properties once when class is first used
    static {
        try {
            Properties props = new Properties();
            InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties");
            props.load(input);

            Class.forName(props.getProperty("db.driver"));
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");
        } catch (Exception e) {
            throw new RuntimeException("Failed to load DB configuration: " + e.getMessage(), e);
        }
    }

    /**
     * Returns a fresh JDBC connection to the database.
     */
    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(url, username, password);
    }
}