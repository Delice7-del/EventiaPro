package org.example.eventiapro.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test-db")
public class TestConnectionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h1>Database Connection Test</h1>");

        try {
            out.println("<p>Attempting to initialize Hibernate SessionFactory...</p>");
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();

            if (sessionFactory != null) {
                out.println("<h2 style='color:green'>SessionFactory Initialized Successfully!</h2>");

                try (Session session = sessionFactory.openSession()) {
                    out.println("<p>Opening session...</p>");
                    if (session.isOpen()) {
                        out.println("<h2 style='color:green'>Database Connection Established!</h2>");
                        out.println("<p>Database Name: eventia_pro (configured in HibernateUtil)</p>");
                    } else {
                        out.println("<h2 style='color:red'>Session Failed to Open</h2>");
                    }
                }
            } else {
                out.println("<h2 style='color:red'>SessionFactory is Null!</h2>");
            }

        } catch (Exception e) {
            out.println("<h2 style='color:red'>Exception Occurred:</h2>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }

        out.println("</body></html>");
    }
}
