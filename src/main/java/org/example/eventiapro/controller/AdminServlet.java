package org.example.eventiapro.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.eventiapro.dao.EventDAO;
import org.example.eventiapro.dao.RegistrationDAO;
import org.example.eventiapro.dao.CategoryDAO;
import org.example.eventiapro.dao.VenueDAO;
import org.example.eventiapro.model.Event;
import org.example.eventiapro.model.User;
import org.example.eventiapro.service.EventService;
import org.example.eventiapro.service.NotificationService;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private EventDAO eventDAO;
    private RegistrationDAO registrationDAO;
    private CategoryDAO categoryDAO;
    private VenueDAO venueDAO;
    private org.example.eventiapro.dao.AnnouncementDAO announcementDAO;

    private org.example.eventiapro.dao.UserDAO userDAO;
    private EventService eventService;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        System.out.println("DEBUG: AdminServlet.init() started");
        try {
            eventDAO = new EventDAO();
            registrationDAO = new RegistrationDAO();
            categoryDAO = new CategoryDAO();
            venueDAO = new VenueDAO();
            userDAO = new org.example.eventiapro.dao.UserDAO();
            eventService = new EventService();
            announcementDAO = new org.example.eventiapro.dao.AnnouncementDAO();
            notificationService = new NotificationService();
            System.out.println("DEBUG: AdminServlet DAOs and Service initialized successfully");
        } catch (Exception e) {
            System.err.println("DEBUG: Error initializing AdminServlet components: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        System.out.println("DEBUG: AdminServlet.doGet called with pathInfo: " + pathInfo);
        try {
            // DIAGNOSTIC TEST ENDPOINT
            if (pathInfo != null && pathInfo.equals("/test")) {
                response.setContentType("text/html");
                response.getWriter().println("<h1 style='color:green;'>SUCCESS! AdminServlet IS WORKING!</h1>");
                response.getWriter().println("<p>Path: " + pathInfo + "</p>");
                response.getWriter().println("<p>Session User: " + request.getSession().getAttribute("user") + "</p>");
                return;
            }

            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
                showDashboard(request, response);
            } else if (pathInfo.equals("/seed")) {
                seedData(request, response);
            } else if (pathInfo.equals("/analytics")) {
                showAnalytics(request, response);
            } else if (pathInfo.equals("/users")) {
                showUsers(request, response);
            } else if (pathInfo.equals("/messages")) {
                showMessages(request, response);
            } else if (pathInfo.equals("/settings")) {
                showSettings(request, response);
            } else if (pathInfo.equals("/event/new")) {
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("venues", venueDAO.getAllVenues());
                request.getRequestDispatcher("/WEB-INF/views/admin/create_event.jsp").forward(request, response);
            } else if (pathInfo.startsWith("/event/edit/")) {
                showEditForm(request, response);
            } else if (pathInfo.startsWith("/event/delete/")) {
                deleteEvent(request, response);
            } else if (pathInfo.startsWith("/event/participants/")) {
                showParticipants(request, response);
            } else if (pathInfo.equals("/user/update-role")) {
                handleUpdateRole(request, response);
            } else if (pathInfo.equals("/user/delete")) {
                handleDeleteUser(request, response);
            } else if (pathInfo.equals("/repair-db")) {
                org.example.eventiapro.util.HibernateUtil.repairSchemaForce();
                request.getSession().setAttribute("success",
                        "Database repair attempted. Ghost columns should be purged.");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=Repair+triggered");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log error to server console
            throw new ServletException("Error in AdminServlet: " + e.getMessage(), e);
        }
    }

    private void seedData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User admin = (User) request.getSession().getAttribute("user");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            // Ensure categories exist
            String[] categories = { "Music", "Technology", "Business", "Arts" };
            for (String catName : categories) {
                if (categoryDAO.getCategoryByName(catName) == null) {
                    org.example.eventiapro.model.Category cat = new org.example.eventiapro.model.Category();
                    cat.setName(catName);
                    categoryDAO.addCategory(cat);
                }
            }

            // Sample Events Data (2 per category)
            Object[][] samples = {
                    { "Summer Vibes Concert", "Music", "An outdoor music festival featuring top indie bands.",
                            "2024-07-15", "18:00:00", 50.0 },
                    { "Jazz Night", "Music", "Smooth jazz and dining under the stars.", "2024-08-20", "19:30:00",
                            75.0 },
                    { "Tech Innovators Summit", "Technology", "A gathering of the brightest minds in tech.",
                            "2024-09-10", "09:00:00", 150.0 },
                    { "AI Workshop", "Technology", "Hands-on workshop building your first AI model.", "2024-09-12",
                            "14:00:00", 30.0 },
                    { "Global Business Forum", "Business", "Connect with industry leaders and investors.", "2024-10-05",
                            "08:30:00", 200.0 },
                    { "Startup Pitch Night", "Business", "Watch startups pitch their ideas to VCs.", "2024-10-25",
                            "18:00:00", 0.0 },
                    { "Modern Art Gallery", "Arts", "A showcase of contemporary abstract art.", "2024-11-01",
                            "10:00:00", 20.0 },
                    { "Theater: The Void", "Arts", "An immersive theater experience.", "2024-11-15", "19:00:00", 45.0 }
            };

            // Create Events
            for (Object[] data : samples) {
                String title = (String) data[0];
                org.example.eventiapro.model.Category cat = categoryDAO.getCategoryByName((String) data[1]);
                String desc = (String) data[2];
                Date date = Date.valueOf((String) data[3]);
                Time time = Time.valueOf((String) data[4]);
                Double price = (Double) data[5];

                Event event = new Event();
                event.setTitle(title);
                event.setDescription(desc);
                event.setEventDate(date);
                event.setEventTime(time);
                event.setCategory(cat);
                event.setTicketPrice(price);
                event.setCapacity(100);

                // Assuming venue 1 exists or is null if not strict.
                // We'll skip venue for simplicity or fetch first available if needed.
                List<org.example.eventiapro.model.Venue> venues = venueDAO.getAllVenues();
                if (!venues.isEmpty()) {
                    event.setVenue(venues.get(0));
                }

                eventDAO.addEvent(event);
            }

            response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=Seeding+completed!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Seeding+failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        try {
            if (pathInfo.equals("/event/save")) {
                saveEvent(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/event/update/")) {
                updateEvent(request, response);
            } else if (pathInfo != null && pathInfo.equals("/broadcast")) {
                handleBroadcast(request, response);
            } else if (pathInfo != null && pathInfo.equals("/settings/update-profile")) {
                updateAdminProfile(request, response);
            } else if (pathInfo != null && pathInfo.equals("/settings/update-password")) {
                updateAdminPassword(request, response);
            } else if (pathInfo != null && pathInfo.equals("/settings/update-preferences")) {
                updateAdminPreferences(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pull Flash messages from session to request attributes
        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        try {
            List<Event> events = eventDAO.getAllEvents();
            List<User> users = userDAO.getAllUsers();

            // Calculate real statistics
            long totalRegistrations = 0;
            double totalRevenue = 0.0;
            long activeEvents = 0;
            java.util.Date now = new java.util.Date();

            for (Event e : events) {
                List<org.example.eventiapro.model.Registration> regs = registrationDAO
                        .getRegistrationsForEvent(e.getId());
                int count = regs.size();
                totalRegistrations += count;
                totalRevenue += (count * e.getTicketPrice());
                if (e.getEventDate().after(now)) {
                    activeEvents++;
                }
            }

            // Get Recent Activity (limited lists)
            List<User> recentUsers = users.stream()
                    .filter(u -> u.getCreatedAt() != null)
                    .sorted((u1, u2) -> u2.getCreatedAt().compareTo(u1.getCreatedAt()))
                    .limit(5).collect(java.util.stream.Collectors.toList());

            request.setAttribute("events", events);
            request.setAttribute("activeEventsCount", activeEvents);
            request.setAttribute("userCount", users.size()); 
            request.setAttribute("totalRegistrations", totalRegistrations);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentUsers", recentUsers);

            // Category Distribution: Number of Events per Category
            java.util.Map<String, Long> categoryStats = new java.util.HashMap<>();
            for (Event e : events) {
                String catName = (e.getCategory() != null) ? e.getCategory().getName() : "General";
                categoryStats.put(catName, categoryStats.getOrDefault(catName, 0L) + 1);
            }
            if (categoryStats.isEmpty()) {
                categoryStats.put("No events yet", 0L);
            }
            request.setAttribute("categoryStats", categoryStats);

            // Real Trends/Growth (Monthly)
            java.util.Map<String, Long> growthMap = new java.util.LinkedHashMap<>();
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM");
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.MONTH, -5);
            for (int i = 0; i < 6; i++) {
                growthMap.put(sdf.format(cal.getTime()), 0L);
                cal.add(java.util.Calendar.MONTH, 1);
            }
            for (User u : userDAO.getAllUsers()) {
                if (u.getCreatedAt() != null) {
                    String month = sdf.format(u.getCreatedAt());
                    if (growthMap.containsKey(month)) {
                        growthMap.put(month, growthMap.get(month) + 1);
                    }
                }
            }
            request.setAttribute("growthLabels", growthMap.keySet().toArray());
            request.setAttribute("growthData", growthMap.values().toArray());

            request.setAttribute("activePage", "dashboard");
            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void showAnalytics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Event> events = eventDAO.getAllEvents();
            List<User> users = userDAO.getAllUsers();

            // Top Performing Events (by revenue)
            java.util.List<java.util.Map<String, Object>> eventMetrics = new java.util.ArrayList<>();
            for (Event e : events) {
                int regCount = registrationDAO.getRegistrationsForEvent(e.getId()).size();
                double revenue = regCount * e.getTicketPrice();

                java.util.Map<String, Object> metric = new java.util.HashMap<>();
                metric.put("title", e.getTitle());
                metric.put("date", e.getEventDate());
                metric.put("revenue", revenue);
                metric.put("registrations", regCount);
                eventMetrics.add(metric);
            }

            eventMetrics.sort((m1, m2) -> Double.compare((Double) m2.get("revenue"), (Double) m1.get("revenue")));

            // Real Growth Calculation (Monthly)
            java.util.Map<String, Long> growthMap = new java.util.LinkedHashMap<>();
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM");

            // Initialize last 6 months
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.MONTH, -5);
            for (int i = 0; i < 6; i++) {
                growthMap.put(sdf.format(cal.getTime()), 0L);
                cal.add(java.util.Calendar.MONTH, 1);
            }

            for (User u : users) {
                if (u.getCreatedAt() != null) {
                    String month = sdf.format(u.getCreatedAt());
                    if (growthMap.containsKey(month)) {
                        growthMap.put(month, growthMap.get(month) + 1);
                    }
                }
            }

            request.setAttribute("eventMetrics", eventMetrics);
            request.setAttribute("growthLabels", growthMap.keySet().toArray());
            request.setAttribute("growthData", growthMap.values().toArray());

            java.util.Map<String, Long> categoryStats = new java.util.HashMap<>();
            for (Event e : events) {
                String catName = e.getCategory() != null ? e.getCategory().getName() : "Unknown";
                categoryStats.put(catName, categoryStats.getOrDefault(catName, 0L) + 1);
            }
            request.setAttribute("categoryStats", categoryStats);

            request.setAttribute("activePage", "analytics");
            request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String search = request.getParameter("search");
            String roleFilter = request.getParameter("role");

            List<User> users = userDAO.getAllUsers();

            if (search != null && !search.trim().isEmpty()) {
                String q = search.toLowerCase();
                users = users.stream()
                        .filter(u -> u.getUsername().toLowerCase().contains(q)
                                || u.getEmail().toLowerCase().contains(q))
                        .collect(java.util.stream.Collectors.toList());
            }
            if (roleFilter != null && !roleFilter.isEmpty() && !"All".equals(roleFilter)) {
                users = users.stream().filter(u -> u.getRole().equalsIgnoreCase(roleFilter))
                        .collect(java.util.stream.Collectors.toList());
            }

            HttpSession session = request.getSession();
            if (session.getAttribute("success") != null) {
                request.setAttribute("success", session.getAttribute("success"));
                session.removeAttribute("success");
            }
            if (session.getAttribute("error") != null) {
                request.setAttribute("error", session.getAttribute("error"));
                session.removeAttribute("error");
            }

            request.setAttribute("users", users);
            request.setAttribute("activePage", "users");
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void showMessages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("announcements", announcementDAO.getAllAnnouncements());
        request.setAttribute("activePage", "messages");
        request.getRequestDispatcher("/WEB-INF/views/admin/messages.jsp").forward(request, response);
    }

    private void showSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(request, response);
    }

    private void saveEvent(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            User admin = (User) request.getSession().getAttribute("user");
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }
            Event event = extractEventFromRequest(request);

            System.out.println("DEBUG: Admin attempting to save event (Atomic Flow): " + event.getTitle());

            // Use the Service for atomic 3-in-1 action
            Event createdEvent = eventService.createEventWithAutoEnroll(event, admin);

            if (createdEvent != null) {
                notificationService.notifyNewEvent(createdEvent.getTitle());
                request.getSession().setAttribute("success", "Event created successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=Event+created");
            } else {
                request.getSession().setAttribute("error", "Creation failed in Service tier.");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Creation+failed");
            }
        } catch (Exception e) {
            System.err.println("CRITICAL: Exception in AdminServlet.saveEvent: " + e.getMessage());
            e.printStackTrace();
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Unknown error";
            request.getSession().setAttribute("error", "Failed: " + errorMsg);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error="
                    + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getPathInfo().substring("/event/edit/".length()));
        Event event = eventDAO.getEventById(id);
        request.setAttribute("event", event);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("venues", venueDAO.getAllVenues());
        request.getRequestDispatcher("/WEB-INF/views/admin/create_event.jsp").forward(request, response);
    }

    private void updateEvent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getPathInfo().substring("/event/update/".length()));
        Event event = extractEventFromRequest(request);
        event.setId(id);
        if (eventDAO.updateEvent(event)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?success="
                    + java.net.URLEncoder.encode("Event updated successfully", "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error="
                    + java.net.URLEncoder.encode("Update failed", "UTF-8"));
        }
    }

    private void deleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getPathInfo().substring("/event/delete/".length()));
        Event event = eventDAO.getEventById(id);
        String title = (event != null) ? event.getTitle() : "Event #" + id;

        if (eventDAO.deleteEvent(id)) {
            notificationService.notifyEventDeleted(title);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?success="
                    + java.net.URLEncoder.encode("Event deleted successfully", "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error="
                    + java.net.URLEncoder.encode("Delete failed", "UTF-8"));
        }
    }

    private void showParticipants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getPathInfo().substring("/event/participants/".length()));
        Event event = eventDAO.getEventById(id);
        request.setAttribute("event", event);
        request.setAttribute("participants", registrationDAO.getRegistrationsForEvent(id));
        request.getRequestDispatcher("/WEB-INF/views/admin/participants.jsp").forward(request, response);
    }

    private void updateAdminProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        user.setUsername(request.getParameter("name"));
        userDAO.updateUser(user);
        response.sendRedirect(request.getContextPath() + "/admin/settings?success=Profile+updated");
    }

    private void updateAdminPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");

        if (user != null && org.mindrot.jbcrypt.BCrypt.checkpw(currentPass, user.getPassword())) {
            String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(newPass, org.mindrot.jbcrypt.BCrypt.gensalt());
            if (userDAO.updatePassword(user.getId(), hashed)) {
                user.setPassword(hashed); // Update session object
                response.sendRedirect(
                        request.getContextPath() + "/admin/settings?success=Password+updated+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/settings?error=Database+update+failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/settings?error=Invalid+current+password");
        }
    }

    private void updateAdminPreferences(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("adminLanguage", request.getParameter("language"));
        session.setAttribute("adminTheme", request.getParameter("theme"));
        response.sendRedirect(request.getContextPath() + "/admin/settings?success=Preferences+saved+to+session");
    }

    private void handleBroadcast(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String message = request.getParameter("message");
        String priority = request.getParameter("priority");

        org.example.eventiapro.model.Announcement announcement = new org.example.eventiapro.model.Announcement(title,
                message, priority);
        boolean success = announcementDAO.saveAnnouncement(announcement);

        if (success) {
            notificationService.notifyNewAnnouncement(announcement.getTitle());
            response.sendRedirect(request.getContextPath()
                    + "/admin/messages?success=Announcement+broadcasted+and+saved+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/messages?error=Failed+to+save+announcement");
        }
    }

    private Event extractEventFromRequest(HttpServletRequest request) {
        Event event = new Event();
        event.setTitle(request.getParameter("title"));
        event.setDescription(request.getParameter("description"));
        String dateStr = request.getParameter("date");
        if (dateStr != null && !dateStr.isEmpty()) {
            event.setEventDate(Date.valueOf(dateStr));
        }
        String timeStr = request.getParameter("time");
        if (timeStr != null && !timeStr.isEmpty()) {
            if (timeStr.length() == 5) { // HH:mm
                timeStr += ":00";
            }
            event.setEventTime(Time.valueOf(timeStr));
        }

        String venueIdStr = request.getParameter("venueId");
        String categoryIdStr = request.getParameter("categoryId");

        if (venueIdStr != null && !venueIdStr.isEmpty()) {
            if ("other".equals(venueIdStr)) {
                String name = request.getParameter("newVenueName");
                String location = request.getParameter("newVenueLocation");
                int cap = 0;
                String capStr = request.getParameter("capacity");
                if (capStr != null && !capStr.isEmpty()) {
                    cap = Integer.parseInt(capStr);
                }
                
                org.example.eventiapro.model.Venue newVenue = new org.example.eventiapro.model.Venue(name, location, cap);
                newVenue = venueDAO.saveAndReturnVenue(newVenue);
                event.setVenue(newVenue);
                System.out.println("DEBUG: Created new custom venue: " + name);
            } else {
                event.setVenue(venueDAO.getVenueById(Integer.parseInt(venueIdStr)));
            }
        }
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            event.setCategory(categoryDAO.getCategoryById(Integer.parseInt(categoryIdStr)));
        }

        String capacityStr = request.getParameter("capacity");
        if (capacityStr != null && !capacityStr.isEmpty()) {
            event.setCapacity(Integer.parseInt(capacityStr));
        }

        String priceStr = request.getParameter("ticketPrice");
        if (priceStr != null && !priceStr.isEmpty()) {
            event.setTicketPrice(Double.parseDouble(priceStr));
        }
        return event;
    }

    private void handleUpdateRole(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String role = request.getParameter("role");
            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setRole(role.toUpperCase());
                userDAO.updateUser(user);
                request.getSession().setAttribute("success", "Role updated to " + role);
                response.sendRedirect(request.getContextPath() + "/admin/users?success=Role+updated");
            } else {
                request.getSession().setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=User+not+found");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Update failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Update+failed");
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if (userDAO.deleteUser(userId)) {
                request.getSession().setAttribute("success", "User deleted successfully");
                response.sendRedirect(request.getContextPath() + "/admin/users?success=User+deleted");
            } else {
                request.getSession().setAttribute("error", "Deletion failed");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=Delete+failed");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Exception+occurred");
        }
    }
}
