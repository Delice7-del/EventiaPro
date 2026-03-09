package org.example.eventiapro.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.eventiapro.dao.UserDAO;
import org.example.eventiapro.model.User;

import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        // Warm up Hibernate and check connection on startup
        try {
            System.out.println("DEBUG: AuthServlet initializing. Verifying database connection...");
            org.example.eventiapro.util.HibernateUtil.getSessionFactory();
            System.out.println("DEBUG: Database connection verified.");
        } catch (Exception e) {
            System.err.println("CRITICAL: Database connection failed during AuthServlet init: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/logout")) {
            handleLogout(request, response);
        } else if (pathInfo.equals("/login")) {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else if (pathInfo.equals("/signup")) {
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null) {
            switch (pathInfo) {
                case "/login":
                    handleLogin(request, response);
                    break;
                case "/signup":
                    handleSignup(request, response);
                    break;
            }
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        System.out.println("DEBUG: Login attempt for username: " + username);

        try {
            User user = userDAO.login(username, password);
            if (user != null) {
                System.out.println("DEBUG: Login successful for user: " + username + " with role: " + user.getRole());
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                if ("ADMIN".equals(user.getRole())) {
                    System.out.println("DEBUG: Redirecting to Admin Dashboard");
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    System.out.println("DEBUG: Redirecting to User Dashboard");
                    response.sendRedirect(request.getContextPath() + "/user/dashboard");
                }
            } else {
                System.out.println("DEBUG: Login failed - user null or password mismatch for: " + username);
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("DEBUG: Exception in handleLogin: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/auth/login?error=System Error: "
                    + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role"); // Default to USER in DAO if null
        String twoFactor = request.getParameter("twoFactorEnabled");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setRole(role);
        user.setTwoFactorEnabled(twoFactor != null && (twoFactor.equals("on") || twoFactor.equals("true")));

        try {
            if (userDAO.registerUser(user)) {
                response.sendRedirect(request.getContextPath() + "/auth/login?success="
                        + java.net.URLEncoder.encode("Account created successfully", "UTF-8"));
            } else {
                request.setAttribute("error", "Registration failed: An unknown error occurred.");
                request.getRequestDispatcher("/signup.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("DEBUG: Signup Exception: " + e.getClass().getName() + " - " + e.getMessage());
            String errorMessage = "Registration failed: " + e.getMessage();

            // Analyze the exception chain for constraint violations
            Throwable rootCause = e;
            while (rootCause.getCause() != null && rootCause != rootCause.getCause()) {
                rootCause = rootCause.getCause();
            }

            if (rootCause.getMessage() != null && rootCause.getMessage().toLowerCase().contains("duplicate")) {
                if (rootCause.getMessage().toLowerCase().contains("username")) {
                    errorMessage = "Username '" + username + "' is already taken. Please choose another.";
                } else if (rootCause.getMessage().toLowerCase().contains("email")) {
                    errorMessage = "Email '" + email + "' is already registered. Please login instead.";
                } else {
                    errorMessage = "A user with these details already exists.";
                }
            } else if (e.getMessage() != null && e.getMessage().contains("ConstraintViolationException")) {
                errorMessage = "Validation error: Please ensure all fields are correct.";
            }

            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth/login?loggedOut=true");
    }
}
