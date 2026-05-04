package com.queuesmart.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class MailUtil {

    // IMPORTANT: Replace with your actual Gmail and App Password
    private static final String SENDER_EMAIL = "your-email@gmail.com";
    private static final String APP_PASSWORD = "your-16-letter-app-password";

    public static boolean sendPasswordResetEmail(String recipientEmail, String resetCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");



        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("QueueSmart - Password Reset Code");
            message.setText("Your password reset code is: " + resetCode + "\n\nIf you did not request this, please ignore this email.");

            Transport.send(message);
            FileLogger.info("Password reset email sent to " + recipientEmail);
            return true;
        } catch (MessagingException e) {
            FileLogger.error("Failed to send email to " + recipientEmail, e);
            return false;
        }
    }
}
