package com.queuesmart.controller.customer;

import com.queuesmart.dao.BookingDAO;
import com.queuesmart.dao.QueueDAO;
import com.queuesmart.dao.ServiceDAO;
import com.queuesmart.model.Booking;
import com.queuesmart.model.QueueEntry;
import com.queuesmart.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

/**
 * Handles service booking and walk-in queue joining.
 * GET  /customer/book?serviceId=X → shows the booking form
 * POST /customer/book             → creates booking and joins queue
 */
@WebServlet("/customer/book")
public class BookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final QueueDAO queueDAO = new QueueDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String serviceIdStr = req.getParameter("serviceId");
        if (serviceIdStr == null) {
            res.sendRedirect(req.getContextPath() + "/customer/services");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            Service service = serviceDAO.findById(serviceId);
            if (service == null || !"ACTIVE".equals(service.getStatus())) {
                req.setAttribute("errorMsg", "This service is not available.");
                req.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(req, res);
                return;
            }
            req.setAttribute("service", service);
            req.getRequestDispatcher("/WEB-INF/views/customer/bookService.jsp").forward(req, res);

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/customer/services");
        } catch (Exception e) {
            getServletContext().log("Booking GET error", e);
            res.sendRedirect(req.getContextPath() + "/error?code=500");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int customerId = (int) req.getSession().getAttribute("userId");

        try {
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            String bookingType = req.getParameter("bookingType"); // "appointment" or "walkin"
            String notes = req.getParameter("notes");

            Integer bookingId = null;

            if ("appointment".equals(bookingType)) {
                // Create a formal appointment booking
                String dateStr = req.getParameter("bookingDate");
                String timeStr = req.getParameter("timeSlot");

                if (dateStr == null || timeStr == null || dateStr.isEmpty() || timeStr.isEmpty()) {
                    req.setAttribute("errorMsg", "Please select a date and time for your appointment.");
                    doGet(req, res);
                    return;
                }

                Booking booking = new Booking();
                booking.setCustomerId(customerId);
                booking.setServiceId(serviceId);
                booking.setBookingDate(Date.valueOf(dateStr));
                booking.setTimeSlot(Time.valueOf(timeStr + ":00"));
                booking.setNotes(notes);
                bookingId = bookingDAO.create(booking);
            }

            // Join the queue (either for appointment or walk-in)
            QueueEntry entry = queueDAO.joinQueue(serviceId, customerId, bookingId);

            // Pass queue info to confirmation page
            req.setAttribute("queueEntry", entry);
            req.setAttribute("service", serviceDAO.findById(serviceId));
            req.getRequestDispatcher("/WEB-INF/views/customer/queueConfirmation.jsp").forward(req, res);

        } catch (Exception e) {
            getServletContext().log("Booking POST error", e);
            req.setAttribute("errorMsg", "Could not complete booking. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/customer/bookService.jsp").forward(req, res);
        }
    }
}