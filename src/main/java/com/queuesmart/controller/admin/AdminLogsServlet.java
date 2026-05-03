package com.queuesmart.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller to display the system audit logs.
 */
@WebServlet("/admin/logs")
public class AdminLogsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<String> logLines = new ArrayList<>();
        File logFile = new File("queuesmart_app.log");
        
        if (logFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(logFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    logLines.add(line);
                }
            } catch (Exception e) {
                logLines.add("[ERROR] Could not read log file: " + e.getMessage());
            }
        } else {
            logLines.add("[INFO] No log file found at " + logFile.getAbsolutePath());
        }

        // Reverse the list so newest logs are at the top
        java.util.Collections.reverse(logLines);
        
        req.setAttribute("logs", logLines);
        req.getRequestDispatcher("/WEB-INF/views/admin/logs.jsp").forward(req, res);
    }
}
