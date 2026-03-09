package org.example.eventiapro.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EmailUtil {

    // Thread pool for background email sending to prevent UI lag
    private static final ExecutorService executor = Executors.newFixedThreadPool(3);

    public static void sendOTP(String toEmail, String otp) {
        // Run in background to prevent "ragging" (lag) on the login page
        executor.submit(() -> {
            try {
                System.out.println("DEBUG: Email delivery task started in background for: " + toEmail);
                // IMPORTANT: To avoid "535-5.7.8 Username and Password not accepted" error:
                // 1. Enable 2-Step Verification on your Google Account.
                // 2. Go to Security -> App Passwords.
                // 3. Generate a new password for "Other (Custom name)" called "EventiaPro".
                // 4. Use the 16-character code generated below.

                final String fromEmail = "iteta137@gmail.com";
                final String appPassword = "viveoddbxopqkthz";

                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
                props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
                props.put("mail.debug", "true"); // Enable detailed SMTP logs in terminal

                Session session = Session.getInstance(props);

                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(fromEmail, "EventiaPro Support"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("Your EventiaPro Verification Code: " + otp);

                String emailContent = "Hello,\n\n"
                        + "Your 6-digit verification code is: " + otp + "\n\n"
                        + "This code is required to complete your login to EventiaPro. "
                        + "It will expire in 5 minutes.\n\n"
                        + "If you did not request this code, please ignore this email.\n\n"
                        + "Regards,\n"
                        + "EventiaPro Security Team";

                message.setText(emailContent);

                System.out.println("DEBUG: Sending OTP [" + otp + "] to: " + toEmail);

                // Explicitly connect and send to avoid "user=HP" system property issues
                try (Transport transport = session.getTransport("smtp")) {
                    transport.connect("smtp.gmail.com", 587, fromEmail, appPassword);
                    transport.sendMessage(message, message.getAllRecipients());
                }

                System.out.println("DEBUG: OTP Email sent successfully to: " + toEmail);

            } catch (AuthenticationFailedException e) {
                System.err.println(
                        "CRITICAL ERROR: SMTP Authentication failed. Check fromEmail and appPassword in EmailUtil.java");
                e.printStackTrace();
            } catch (MessagingException e) {
                System.err.println(
                        "ERROR: Messaging exception during OTP delivery to " + toEmail + ": " + e.getMessage());
                e.printStackTrace();
            } catch (Exception e) {
                System.err.println("ERROR: Unexpected failure sending OTP to " + toEmail + ": " + e.getMessage());
                e.printStackTrace();
            }
        });
    }

    // Call this if the application is shutting down
    public static void shutdown() {
        executor.shutdown();
    }
}
