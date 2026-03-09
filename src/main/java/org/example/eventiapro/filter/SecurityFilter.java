package org.example.eventiapro.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.eventiapro.model.User;
import org.example.eventiapro.util.XSSRequestWrapper;

import java.io.IOException;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Add security headers
        httpResponse.setHeader("X-Frame-Options", "DENY");
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");

        String fullUri = httpRequest.getRequestURI();
        System.out.println("DEBUG: SecurityFilter intercepted URI: " + fullUri);

        HttpSession session = httpRequest.getSession(false);
        String path = "";
        try {
            path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        } catch (Exception e) {
            path = httpRequest.getRequestURI(); // Fallback
        }
        System.out.println("DEBUG: Calculated path: " + path);

        // Allow access to public pages and static resources
        boolean isPublicPage = path.startsWith("/auth") || path.equals("/index.jsp") || path.equals("/")
                || path.contains("css") || path.contains("js");
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        System.out.println("DEBUG: isPublicPage=" + isPublicPage + ", isLoggedIn=" + isLoggedIn);

        if (isPublicPage || isLoggedIn) {
            // Check for Admin access
            if (path.startsWith("/admin")) {
                User user = (User) session.getAttribute("user");
                System.out.println(
                        "DEBUG: Checking Admin Access. User Role: " + (user != null ? user.getRole() : "NULL"));
                if (user == null || !"ADMIN".equals(user.getRole())) {
                    System.out.println("DEBUG: Access Denied. Redirecting to login?unauthorized.");
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login?unauthorized=true");
                    return;
                }
            }
            System.out.println("DEBUG: Chaining request with XSS sanitization...");
            chain.doFilter(new XSSRequestWrapper(httpRequest), response);
            System.out.println("DEBUG: Request returned from chain.");
        } else {
            System.out.println("DEBUG: Not Public & Not Logged In. Redirecting to /auth/login");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("SecurityFilter initialized successfully!");
    }

    @Override
    public void destroy() {
    }
}
