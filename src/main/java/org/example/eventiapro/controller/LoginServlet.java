package org.example.eventiapro.controller;

import org.example.eventiapro.dao.UserDAO;
import org.example.eventiapro.model.User;
import org.example.eventiapro.util.OTPUtil;
import org.example.eventiapro.util.EmailUtil;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/auth/login-submit")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    // Reuse HttpClient for better performance (avoids creating new connections
    // every time)
    private static final HttpClient client = HttpClient.newBuilder()
            .connectTimeout(java.time.Duration.ofSeconds(10))
            .build();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 1. Validate reCAPTCHA
        String recaptchaResponse = request.getParameter("g-recaptcha-response");
        if (recaptchaResponse == null || recaptchaResponse.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error="
                    + URLEncoder.encode("Please complete the CAPTCHA!", "UTF-8"));
            return;
        }

        if (!verifyRecaptcha(recaptchaResponse)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error="
                    + URLEncoder.encode("CAPTCHA verification failed. Please try again.", "UTF-8"));
            return;
        }

        // 2. Authenticate User
        User user = userDAO.login(username, password);
        if (user != null) {
            HttpSession session = request.getSession();

            if (user.isTwoFactorEnabled()) {
                // 3. Generate and Send OTP (Background)
                String otp = OTPUtil.generateOTP();
                session.setAttribute("pendingUser", user);
                session.setAttribute("otp", otp);
                session.setAttribute("otpTime", System.currentTimeMillis());

                // Asynchronous email sending
                EmailUtil.sendOTP(user.getEmail(), otp);
                System.out.println("DEBUG: 2FA required for " + user.getEmail() + ". OTP sent.");

                // Redirect to verification page
                request.getRequestDispatcher("/WEB-INF/views/verify.jsp").forward(request, response);
            } else {
                // 2FA not enabled, login directly
                session.setAttribute("user", user);
                System.out.println("DEBUG: 2FA not enabled for " + user.getUsername() + ". Direct login.");

                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/dashboard");
                }
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error="
                    + URLEncoder.encode("Invalid Username or Password!", "UTF-8"));
        }
    }

    private boolean verifyRecaptcha(String recaptchaResponse) {
        try {
            // Google reCAPTCHA Secret Key
            String secretKey = "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe";
            String url = "https://www.google.com/recaptcha/api/siteverify";

            HttpRequest verifyRequest = HttpRequest.newBuilder()
                    .uri(java.net.URI.create(url))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(
                            "secret=" + secretKey + "&response=" + recaptchaResponse))
                    .build();

            HttpResponse<String> verifyResponse = client.send(verifyRequest,
                    HttpResponse.BodyHandlers.ofString());

            JsonObject jsonObject = JsonParser.parseString(verifyResponse.body()).getAsJsonObject();
            return jsonObject.get("success").getAsBoolean();

        } catch (Exception e) {
            System.err.println("ERROR: reCAPTCHA verification failed: " + e.getMessage());
            return false;
        }
    }
}
