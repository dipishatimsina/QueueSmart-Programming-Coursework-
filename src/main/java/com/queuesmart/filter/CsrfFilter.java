package com.queuesmart.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

/**
 * Enterprise Security Filter to prevent Cross-Site Request Forgery (CSRF).
 * DISABLED FOR NOW AS REQUESTED BY USER.
 */
// @WebFilter("/*")
public class CsrfFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        // 1. Generate CSRF token if it doesn't exist
        String sessionToken = (String) session.getAttribute("csrfToken");
        if (sessionToken == null) {
            sessionToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", sessionToken);
        }

        // 2. Validate token on state-changing requests (POST, PUT, DELETE)
        if ("POST".equalsIgnoreCase(req.getMethod())) {
            // We only enforce CSRF on specific protected forms (e.g. login/register) for this coursework
            String uri = req.getRequestURI();
            if (uri.contains("/login") || uri.contains("/register") || uri.contains("/feedback")) {
                String requestToken = req.getParameter("csrfToken");
                if (requestToken == null || !requestToken.equals(sessionToken)) {
                    // Graceful handling instead of 403 error
                    if (uri.contains("/login") || uri.contains("/register")) {
                        res.sendRedirect(req.getContextPath() + "/login?error=session_expired");
                    } else {
                        res.sendError(HttpServletResponse.SC_FORBIDDEN, "Security Violation: Invalid CSRF Token.");
                    }
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }
}
