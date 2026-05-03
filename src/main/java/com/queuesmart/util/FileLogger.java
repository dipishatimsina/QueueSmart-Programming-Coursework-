package com.queuesmart.util;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Utility class for logging application events to a file.
 * Fulfills the "file handling" requirement of the coursework.
 */
public class FileLogger {

    // You can adjust the path based on server configuration, 
    // using a relative path logs it to the server's working directory or bin folder.
    private static final String LOG_FILE = "queuesmart_app.log";
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * Logs an info message to the file.
     */
    public static void info(String message) {
        log("INFO", message);
    }

    /**
     * Logs an error message to the file.
     */
    public static void error(String message, Throwable t) {
        log("ERROR", message + (t != null ? " - Exception: " + t.getMessage() : ""));
        if (t != null) {
            // Also print stack trace to server console for debugging
            t.printStackTrace();
        }
    }

    private static synchronized void log(String level, String message) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {
            
            String timestamp = dateFormat.format(new Date());
            pw.printf("[%s] [%s] %s%n", timestamp, level, message);
            
        } catch (IOException e) {
            System.err.println("Failed to write to log file: " + e.getMessage());
        }
    }
}
