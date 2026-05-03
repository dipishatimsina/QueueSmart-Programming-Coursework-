package com.queuesmart.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication filter that intercepts every request.
 * Blocks unauthenticated users and enforces role-based access control.
 * Protected paths require an active session with the correct role.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();

        // These paths are public — no login required
        boolean isPublic = path.equals("/login")
                || path.equals("/register")
                || path.equals("/")
                || path.equals("/index.jsp")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/assets/")
                || path.equals("/error")
                || path.equals("/about")
                || path.equals("/contact")
                || path.equals("/forgotPassword")
                || path.equals("/verifyReset")
                || path.equals("/resetPassword")
                || path.equals("/googleLogin")
                || path.equals("/pendingApproval");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);
        if (!loggedIn) {
            res.sendRedirect(req.getContextPath() + "/login?error=session_expired");
            return;
        }

        String role = (String) session.getAttribute("userRole");

        // Enforce role-based path restrictions
        if (path.startsWith("/admin") && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/error?code=403");
            return;
        }
        if (path.startsWith("/provider") && !"PROVIDER".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/error?code=403");
            return;
        }
        if (path.startsWith("/customer") && !"CUSTOMER".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/error?code=403");
            return;
        }

        // All checks passed — continue to the requested resource
        chain.doFilter(request, response);
    }
}