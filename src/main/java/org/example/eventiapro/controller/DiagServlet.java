package org.example.eventiapro.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.eventiapro.dao.UserDAO;
import org.example.eventiapro.model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/diag/users")
public class DiagServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if ("/email-test".equals(pathInfo)) {
            handleEmailTest(request, response);
            return;
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>User Diagnostic</h1>");

        try {
            List<User> users = userDAO.getAllUsers();
            if (users == null || users.isEmpty()) {
                out.println("<p>No users found in database.</p>");
            } else {
                out.println(
                        "<table border='1'><tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>2FA Enabled</th></tr>");
                for (User u : users) {
                    out.println("<tr>");
                    out.println("<td>" + u.getId() + "</td>");
                    out.println("<td>" + u.getUsername() + "</td>");
                    out.println("<td>" + u.getEmail() + "</td>");
                    out.println("<td>" + u.getRole() + "</td>");
                    out.println("<td>" + u.isTwoFactorEnabled() + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
        } catch (Exception e) {
            out.println("<p>Error fetching users: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }

        out.println("</body></html>");
    }

    private void handleEmailTest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String testEmail = request.getParameter("email");

        out.println("<html><body><h1>Email Delivery Test</h1>");
        if (testEmail == null || testEmail.isEmpty()) {
            out.println("<form><p>Target Email: <input type='email' name='email' required></p>");
            out.println("<input type='submit' value='Send Test OTP'></form>");
        } else {
            out.println("<p>Attempting to send test OTP to: <b>" + testEmail + "</b></p>");
            try {
                org.example.eventiapro.util.EmailUtil.sendOTP(testEmail, "123456");
                out.println("<p style='color:green;'>Request submitted to background thread pool.</p>");
                out.println("<p>Check the server console/logs for SMTP details (debug is enabled in EmailUtil).</p>");
            } catch (Exception e) {
                out.println("<p style='color:red;'>FAILED to submit: " + e.getMessage() + "</p>");
                e.printStackTrace(out);
            }
        }
        out.println("<br><a href='users'>Back to User List</a>");
        out.println("</body></html>");
    }
}
