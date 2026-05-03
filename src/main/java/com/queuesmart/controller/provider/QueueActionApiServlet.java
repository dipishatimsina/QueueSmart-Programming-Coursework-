package com.queuesmart.controller.provider;

import com.queuesmart.dao.QueueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles queue status updates via AJAX (Provider Dashboard).
 */
@WebServlet("/api/provider/queue/update")
public class QueueActionApiServlet extends HttpServlet {

    private final QueueDAO queueDAO = new QueueDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || !"PROVIDER".equals(session.getAttribute("userRole"))) {
            res.setStatus(403);
            res.getWriter().print("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        try {
            int queueId = Integer.parseInt(req.getParameter("queueId"));
            String status = req.getParameter("status");

            boolean updated = queueDAO.updateStatus(queueId, status);
            
            if (updated) {
                res.getWriter().print("{\"success\":true}");
            } else {
                res.getWriter().print("{\"success\":false,\"message\":\"Update failed in DB\"}");
            }
        } catch (Exception e) {
            getServletContext().log("AJAX Queue Update Error", e);
            res.setStatus(500);
            res.getWriter().print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
