package com.queuesmart.controller.admin;

import com.queuesmart.dao.BookingDAO;
import com.queuesmart.util.FileLogger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Admin booking management — view system-wide bookings.
 */
@WebServlet("/admin/bookings")
public class ManageBookingsServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("bookings", bookingDAO.findAll());
            req.getRequestDispatcher("/WEB-INF/views/admin/manageBookings.jsp").forward(req, res);
        } catch (Exception e) {
            FileLogger.error("Error loading bookings for admin", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }
}
