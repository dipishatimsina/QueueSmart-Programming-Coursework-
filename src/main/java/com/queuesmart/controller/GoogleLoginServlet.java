package com.queuesmart.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.queuesmart.dao.UserDAO;
import com.queuesmart.model.User;
import com.queuesmart.util.FileLogger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Collections;

@WebServlet("/googleLogin")
public class GoogleLoginServlet extends HttpServlet {

    // IMPORTANT: Replace with your actual Google Client ID from Developer Console
    private static final String CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String idTokenString = req.getParameter("credential");

        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                    .setAudience(Collections.singletonList(CLIENT_ID))
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                String email = payload.getEmail();
                String name = (String) payload.get("name");

                UserDAO userDAO = new UserDAO();
                User user = userDAO.findByEmail(email);

                if (user == null) {
                    // Auto-register new Google user as CUSTOMER
                    user = new User();
                    user.setFullName(name);
                    user.setEmail(email);
                    user.setPassword("GOOGLE_OAUTH_DUMMY"); // They won't use this
                    user.setPhone("GOOGLE_" + System.currentTimeMillis()); // Dummy phone
                    user.setRole("CUSTOMER");
                    user.setStatus("APPROVED"); // Google verified
                    userDAO.register(user);
                    
                    // Fetch the newly created user to get the auto-increment ID
                    user = userDAO.findByEmail(email);
                    FileLogger.info("Registered new user via Google Sign-In: " + email);
                }

                // Check status
                if ("SUSPENDED".equals(user.getStatus())) {
                    res.sendRedirect(req.getContextPath() + "/index.jsp?error=Account suspended");
                    return;
                }

                // Create session
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                FileLogger.info("User logged in via Google: " + user.getEmail());

                // Redirect to dashboard based on role
                if ("ADMIN".equals(user.getRole())) {
                    res.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else if ("PROVIDER".equals(user.getRole())) {
                    res.sendRedirect(req.getContextPath() + "/provider/dashboard");
                } else {
                    res.sendRedirect(req.getContextPath() + "/customer/dashboard");
                }

            } else {
                FileLogger.error("Invalid Google ID token", null);
                res.sendRedirect(req.getContextPath() + "/index.jsp?error=Invalid Google login");
            }
        } catch (Exception e) {
            FileLogger.error("Google Sign-in failed", e);
            res.sendRedirect(req.getContextPath() + "/index.jsp?error=System error during Google login");
        }
    }
}
