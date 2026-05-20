package com.queuesmart.controller.customer;

import com.queuesmart.dao.ServiceDAO;
import com.queuesmart.model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Manages the customer's wishlist stored in the session.
 */
@WebServlet("/customer/wishlist")
public class WishlistServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        List<Integer> wishlistIds = (List<Integer>) session.getAttribute("wishlist");
        List<Service> wishlistServices = new ArrayList<>();

        if (wishlistIds != null && !wishlistIds.isEmpty()) {
            for (Integer id : wishlistIds) {
                try {
                    Service srv = serviceDAO.findById(id);
                    if (srv != null && "ACTIVE".equals(srv.getStatus())) {
                        wishlistServices.add(srv);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        req.setAttribute("wishlistServices", wishlistServices);
        req.getRequestDispatcher("/WEB-INF/views/customer/wishlist.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        List<Integer> wishlistIds = (List<Integer>) session.getAttribute("wishlist");

        if (wishlistIds == null) {
            wishlistIds = new ArrayList<>();
        }

        String action = req.getParameter("action");
        try {
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));

            if ("add".equals(action)) {
                if (!wishlistIds.contains(serviceId)) {
                    wishlistIds.add(serviceId);
                }
            } else if ("remove".equals(action)) {
                wishlistIds.remove(Integer.valueOf(serviceId));
            }

            session.setAttribute("wishlist", wishlistIds);

            // Redirect back to where they came from, or to wishlist
            String referer = req.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                res.sendRedirect(referer);
            } else {
                res.sendRedirect(req.getContextPath() + "/customer/wishlist");
            }

        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/error?code=400");
        }
    }
}


