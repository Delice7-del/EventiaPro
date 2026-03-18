package org.example.eventiapro.controller;

import org.example.eventiapro.dao.CategoryDAO;
import org.example.eventiapro.dao.EventDAO;
import org.example.eventiapro.dao.RegistrationDAO;
import org.example.eventiapro.dao.SavedEventDAO;
import org.example.eventiapro.dao.UserDAO;
import org.example.eventiapro.model.Event;
import org.example.eventiapro.model.User;
import org.example.eventiapro.model.Registration;
import org.example.eventiapro.dao.AnnouncementDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import org.example.eventiapro.dao.VenueDAO;
import org.example.eventiapro.model.Category;
import org.example.eventiapro.model.Venue;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;
    private EventDAO eventDAO;
    private RegistrationDAO regDAO;
    private CategoryDAO categoryDAO;
    private SavedEventDAO savedEventDAO;
    private VenueDAO venueDAO;
    private AnnouncementDAO announcementDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        eventDAO = new EventDAO();
        regDAO = new RegistrationDAO();
        categoryDAO = new CategoryDAO();
        savedEventDAO = new SavedEventDAO();
        venueDAO = new VenueDAO();
        announcementDAO = new AnnouncementDAO();
        System.out.println("DEBUG: UserServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        System.out.println("DEBUG: UserServlet.doGet called with pathInfo: " + pathInfo + " and action: " + action);

        // Sub-path based routing
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard") || pathInfo.equals("/discover")) {
            showDiscoverPage(req, resp);
            return;
        }

        if (pathInfo.startsWith("/event/details/")) {
            showEventDetails(req, resp);
            return;
        }

        if (pathInfo.equals("/registrations")) {
            showRegistrations(req, resp);
            return;
        }

        if (pathInfo.equals("/saved")) {
            showSavedEvents(req, resp);
            return;
        }

        if (pathInfo.equals("/settings")) {
            showSettings(req, resp);
            return;
        }

        if (pathInfo.startsWith("/event/ticket/")) {
            showTicket(req, resp);
            return;
        }

        if (pathInfo.startsWith("/event/download-ticket/")) {
            handleDownloadTicket(req, resp);
            return;
        }

        if (pathInfo.startsWith("/event/calendar/")) {
            handleExportCalendar(req, resp);
            return;
        }

        // Action parameter based routing (legacy/specific actions)
        switch (action != null ? action : "") {
            case "listEvents":
                showDiscoverPage(req, resp);
                break;
            case "registerEvent":
                registerForEvent(req, resp, session);
                break;
            case "logout":
                session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/user/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if ("/save-event".equals(pathInfo)) {
            handleSaveEvent(req, resp);
            return;
        }
        if ("/unsave-event".equals(pathInfo)) {
            handleUnsaveEvent(req, resp);
            return;
        }
        if (pathInfo != null && pathInfo.startsWith("/event/register/")) {
            handleEventRegistration(req, resp);
            return;
        }
        if ("/settings/update-profile".equals(pathInfo)) {
            handleUpdateProfile(req, resp);
            return;
        }

        if (pathInfo != null && pathInfo.startsWith("/registrations/cancel/")) {
            handleCancelRegistration(req, resp);
            return;
        }

        if (pathInfo != null && pathInfo.startsWith("/registrations/delete/")) {
            handleDeleteRegistration(req, resp);
            return;
        }

        if (pathInfo != null && pathInfo.startsWith("/registrations/check-in/")) {
            handleCheckInRegistration(req, resp);
            return;
        }

        String action = req.getParameter("action");
        switch (action != null ? action : "") {
            case "login":
                handleLogin(req, resp);
                break;
            case "register":
                handleRegistration(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/user/dashboard");
                break;
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User user = userDAO.login(username, password);
            if (user != null) {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/user/dashboard");
                System.out.println("DEBUG: User logged in: " + username);
            } else {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Login failed");
        }
    }

    private void handleRegistration(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);

        try {
            if (userDAO.registerUser(user)) {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/user/dashboard");
                System.out.println("DEBUG: User registered: " + username);
            } else {
                resp.sendRedirect(req.getContextPath() + "/signup.jsp?error=Registration failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/signup.jsp?error=Registration exception");
        }
    }

    private void showDiscoverPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        
        String searchParam = req.getParameter("search");
        String catParam = req.getParameter("categoryId");
        Integer categoryId = null;
        
        if (catParam != null && !catParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(catParam);
            } catch (NumberFormatException ignored) {}
        }

        List<Event> events = eventDAO.searchEvents(categoryId, searchParam);
        
        if (events.isEmpty() && searchParam == null && categoryId == null) {
            System.out.println("DEBUG: No events found, creating mock events...");
            createMockEvents();
            events = eventDAO.getAllEvents();
        }

        if (user != null) {
            List<Event> savedEvents = savedEventDAO.getSavedEventsByUser(user.getId());
            List<Integer> savedEventIds = savedEvents.stream().map(Event::getId).toList();
            req.setAttribute("savedEventIds", savedEventIds);
        }

        req.setAttribute("events", events);
        req.setAttribute("categories", categoryDAO.getAllCategories());
        req.setAttribute("announcements", announcementDAO.getAllAnnouncements());
        req.getRequestDispatcher("/WEB-INF/views/user/discover.jsp").forward(req, resp);
    }

    private void showRegistrations(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        List<Registration> registrations = regDAO.getRegistrationsByUser(user.getId());
        req.setAttribute("registrations", registrations);
        req.getRequestDispatcher("/WEB-INF/views/user/registrations.jsp").forward(req, resp);
    }

    private void showSavedEvents(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        List<Event> savedEvents = savedEventDAO.getSavedEventsByUser(user.getId());
        req.setAttribute("savedEvents", savedEvents);
        req.getRequestDispatcher("/WEB-INF/views/user/saved.jsp").forward(req, resp);
    }

    private void showSettings(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/user/settings.jsp").forward(req, resp);
    }

    private void showEventDetails(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String pathInfo = req.getPathInfo();
            int id = Integer.parseInt(pathInfo.substring("/event/details/".length()));
            Event event = eventDAO.getEventById(id);
            if (event != null) {
                req.setAttribute("event", event);
                req.getRequestDispatcher("/WEB-INF/views/user/event_details.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/dashboard?error=Event+not+found");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/dashboard?error=Invalid+event+ID");
        }
    }

    private void createMockEvents() {
        // Ensure we have categories and venues
        Category cat = new Category("Technology", "Events related to tech and coding");
        categoryDAO.addCategory(cat);

        Venue venue = new Venue("Main Hall", "123 Event St, Kigali", 500);
        venueDAO.saveAndReturnVenue(venue);

        long now = System.currentTimeMillis();
        Event event1 = new Event("Spring Festival", "Celebrate spring!", new Date(now + 86400000L * 7), new Time(now),
                venue, 100, cat, 0.0);
        eventDAO.addEvent(event1);

        Event event2 = new Event("Tech Meetup", "Latest in AI", new Date(now + 86400000L * 14), new Time(now), venue,
                50, cat, 15.0);
        eventDAO.addEvent(event2);

        System.out.println("DEBUG: Mock categories, venues, and events created.");
    }

    private void handleEventRegistration(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            String pathInfo = req.getPathInfo();
            int eventId = Integer.parseInt(pathInfo.substring("/event/register/".length()));
            if (!regDAO.isUserRegistered(user.getId(), eventId)) {
                regDAO.registerUserForEvent(user.getId(), eventId);
                resp.sendRedirect(req.getContextPath() + "/user/registrations?success=Registered+successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/dashboard?error=Already+registered");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/dashboard?error=Invalid+event+ID");
        }
    }

    private void handleSaveEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            int eventId = Integer.parseInt(req.getParameter("eventId"));
            Event event = eventDAO.getEventById(eventId);
            if (event != null) {
                savedEventDAO.saveEvent(user, event);
                resp.sendRedirect(req.getContextPath() + "/user/discover?success=Event+saved");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/discover?error=Event+not+found");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/discover?error=Error+saving+event");
        }
    }

    private void handleUnsaveEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            int eventId = Integer.parseInt(req.getParameter("eventId"));
            savedEventDAO.unsaveEvent(user.getId(), eventId);
            resp.sendRedirect(req.getContextPath() + "/user/discover?success=Event+removed");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/discover?error=Error+removing+event");
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            String name = req.getParameter("name");
            user.setUsername(name);
            if (userDAO.updateUser(user)) {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/user/settings?success=Profile+updated");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/settings?error=Update+failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/settings?error=An+error+occurred");
        }
    }

    private void registerForEvent(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Login required");
            return;
        }

        try {
            int eventId = Integer.parseInt(req.getParameter("eventId"));
            if (!regDAO.isUserRegistered(user.getId(), eventId)) {
                boolean success = regDAO.registerUserForEvent(user.getId(), eventId);
                if (success) {
                    System.out.println("DEBUG: User " + user.getUsername() + " registered for event ID " + eventId);
                }
            }
            resp.sendRedirect(req.getContextPath() + "/user/dashboard?success=Registered+successfully");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/user/dashboard?error=Invalid+event+ID");
        }
    }

    private void showTicket(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int regId = Integer.parseInt(req.getPathInfo().substring("/event/ticket/".length()));
            Registration reg = regDAO.getRegistrationById(regId);
            if (reg != null) {
                req.setAttribute("registration", reg);
                req.getRequestDispatcher("/WEB-INF/views/user/ticket.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Ticket+not+found");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Invalid+ticket+ID");
        }
    }

    private void handleDownloadTicket(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int regId = Integer.parseInt(req.getPathInfo().substring("/event/download-ticket/".length()));
            Registration reg = regDAO.getRegistrationById(regId);
            if (reg != null) {
                Event event = reg.getEvent();
                resp.setContentType("text/plain");
                resp.setHeader("Content-Disposition", "attachment;filename=ticket_" + regId + ".txt");
                
                StringBuilder sb = new StringBuilder();
                sb.append("--- EVENTIA PRO TICKET ---\n");
                sb.append("Ticket ID: ").append(regId).append("\n");
                sb.append("Event: ").append(event.getTitle()).append("\n");
                sb.append("Date: ").append(event.getEventDate()).append("\n");
                sb.append("Time: ").append(event.getEventTime()).append("\n");
                sb.append("Venue: ").append(event.getVenue() != null ? event.getVenue().getName() : "Online").append("\n");
                sb.append("--------------------------\n");
                
                resp.getWriter().write(sb.toString());
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleExportCalendar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int regId = Integer.parseInt(req.getPathInfo().substring("/event/calendar/".length()));
            Registration reg = regDAO.getRegistrationById(regId);
            if (reg != null) {
                Event event = reg.getEvent();
                resp.setContentType("text/calendar");
                resp.setHeader("Content-Disposition", "attachment;filename=event_" + event.getId() + ".ics");

                String start = event.getEventDate().toString().replace("-", "") + "T090000Z";
                String end = event.getEventDate().toString().replace("-", "") + "T120000Z";

                StringBuilder sb = new StringBuilder();
                sb.append("BEGIN:VCALENDAR\nVERSION:2.0\nBEGIN:VEVENT\n");
                sb.append("SUMMARY:").append(event.getTitle()).append("\n");
                sb.append("DESCRIPTION:").append(event.getDescription().replace("\n", " ")).append("\n");
                sb.append("DTSTART:").append(start).append("\n");
                sb.append("DTEND:").append(end).append("\n");
                sb.append("LOCATION:").append(event.getVenue() != null ? event.getVenue().getName() : "Online").append("\n");
                sb.append("END:VEVENT\nEND:VCALENDAR");

                resp.getWriter().write(sb.toString());
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleCancelRegistration(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int regId = Integer.parseInt(req.getPathInfo().substring("/registrations/cancel/".length()));
            if (regDAO.cancelRegistration(regId)) {
                resp.sendRedirect(req.getContextPath() + "/user/registrations?success=Registration+cancelled");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Cancellation+failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Invalid+ID");
        }
    }

    private void handleDeleteRegistration(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int regId = Integer.parseInt(req.getPathInfo().substring("/registrations/delete/".length()));
            if (regDAO.deleteRegistration(regId)) {
                resp.sendRedirect(req.getContextPath() + "/user/registrations?success=Registration+deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Delete+failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Invalid+ID");
        }
    }

    private void handleCheckInRegistration(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int regId = Integer.parseInt(req.getPathInfo().substring("/registrations/check-in/".length()));
            if (regDAO.updateStatus(regId, "Attended")) {
                resp.sendRedirect(req.getContextPath() + "/user/registrations?success=Check-in+successful");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Check-in+failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/user/registrations?error=Invalid+ID");
        }
    }
}