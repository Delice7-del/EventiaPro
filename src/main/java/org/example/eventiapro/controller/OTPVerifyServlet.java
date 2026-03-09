package org.example.eventiapro.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import org.example.eventiapro.model.User;

@WebServlet("/auth/verify-otp")
public class OTPVerifyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userOTP = request.getParameter("otp");

        HttpSession session = request.getSession();
        String savedOTP = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpTime");
        User pendingUser = (User) session.getAttribute("pendingUser");

        if (savedOTP == null || otpTime == null || pendingUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session Expired. Please login again.");
            return;
        }

        long currentTime = System.currentTimeMillis();
        if (currentTime - otpTime > 300000) { // 5 minutes
            session.removeAttribute("otp");
            session.removeAttribute("otpTime");
            session.removeAttribute("pendingUser");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=OTP Expired!");
            return;
        }

        if (userOTP != null && userOTP.equals(savedOTP)) {
            // Successful verification
            session.setAttribute("user", pendingUser);

            // Clean up
            session.removeAttribute("otp");
            session.removeAttribute("otpTime");
            session.removeAttribute("pendingUser");

            // Redirect based on role
            if ("ADMIN".equals(pendingUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/dashboard");
            }
        } else {
            request.setAttribute("error", "Invalid OTP!");
            request.getRequestDispatcher("/WEB-INF/views/verify.jsp").forward(request, response);
        }
    }
}