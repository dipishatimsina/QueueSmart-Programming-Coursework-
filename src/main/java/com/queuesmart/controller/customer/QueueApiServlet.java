package com.queuesmart.controller.customer;

import com.queuesmart.dao.QueueDAO;
import com.queuesmart.model.QueueEntry;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Serves real-time queue data as JSON for AJAX polling.
 */
@WebServlet("/api/customer/queue")
public class QueueApiServlet extends HttpServlet {

    private final QueueDAO queueDAO = new QueueDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        PrintWriter out = res.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            out.print("[]");
            return;
        }

        int customerId = (int) session.getAttribute("userId");

        try {
            List<QueueEntry> activeQueues = queueDAO.findActiveByCustomer(customerId);
            
            // Build a simple JSON array manually to avoid external dependencies like Gson/Jackson
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < activeQueues.size(); i++) {
                QueueEntry q = activeQueues.get(i);
                int ahead = 0;
                if ("WAITING".equals(q.getStatus())) {
                    ahead = queueDAO.countAhead(q.getServiceId(), q.getQueueNumber());
                }
                int estimatedWait = ahead * 10;

                json.append("{")
                    .append("\"id\":").append(q.getId()).append(",")
                    .append("\"serviceName\":\"").append(escapeJson(q.getServiceName())).append("\",")
                    .append("\"queueNumber\":").append(q.getQueueNumber()).append(",")
                    .append("\"status\":\"").append(q.getStatus()).append("\",")
                    .append("\"peopleAhead\":").append(ahead).append(",")
                    .append("\"estimatedWait\":").append(estimatedWait)
                    .append("}");
                
                if (i < activeQueues.size() - 1) json.append(",");
            }
            json.append("]");
            
            out.print(json.toString());
        } catch (Exception e) {
            getServletContext().log("API error", e);
            out.print("[]");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"").replace("\\", "\\\\");
    }
}
