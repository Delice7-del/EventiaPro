package org.example.eventiapro.service;

import org.example.eventiapro.dao.RegistrationDAO;
import org.example.eventiapro.dao.SavedEventDAO;
import org.example.eventiapro.model.Event;
import org.example.eventiapro.model.User;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class EventService {
    private final RegistrationDAO registrationDAO;
    private final SavedEventDAO savedEventDAO;

    public EventService() {
        this.registrationDAO = new RegistrationDAO();
        this.savedEventDAO = new SavedEventDAO();
    }

    /**
     * Creates an event, registers the creator, and bookmarks it in ONE atomic
     * transaction.
     */
    public Event createEventWithAutoEnroll(Event event, User creator) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // --- STRICT VALIDATION (adapted for service layer) ---
            if (event.getTitle() == null || event.getTitle().trim().isEmpty()) {
                throw new IllegalArgumentException("Event title is required.");
            }
            if (event.getVenue() == null || event.getVenue().getId() <= 0) {
                throw new IllegalArgumentException("A valid Venue must be selected.");
            }
            if (event.getCategory() == null || event.getCategory().getId() <= 0) {
                throw new IllegalArgumentException("A valid Category must be selected.");
            }
            if (event.getEventDate() == null) {
                throw new IllegalArgumentException("Event date is required.");
            }
            if (creator == null || creator.getId() <= 0) {
                throw new IllegalArgumentException("Creator user must be valid and have an ID.");
            }
            event.setCreatedBy(creator.getId()); // Set creator from the passed User object
            // -------------------------

            System.out.println("DEBUG: [Service] Admin attempting to save event (Atomic Flow): " + event.getTitle());
            System.out.println("DEBUG: [Service] Starting atomic flow for: " + event.getTitle());

            // 1. Re-attach/Fetch managed associations to avoid detached entity issues
            if (event.getVenue() != null) {
                int vId = event.getVenue().getId();
                System.out.println("DEBUG: [Service] Re-attaching Venue ID: " + vId);
                event.setVenue(session.get(org.example.eventiapro.model.Venue.class, vId));
                if (event.getVenue() == null)
                    throw new RuntimeException("Venue not found in DB: " + vId);
            }

            if (event.getCategory() != null) {
                int cId = event.getCategory().getId();
                System.out.println("DEBUG: [Service] Re-attaching Category ID: " + cId);
                event.setCategory(session.get(org.example.eventiapro.model.Category.class, cId));
                if (event.getCategory() == null)
                    throw new RuntimeException("Category not found in DB: " + cId);
            }

            // 2. Save Event
            System.out.println("DEBUG: [Service] Persisting Event...");
            session.persist(event);
            session.flush(); // Force ID generation immediately
            System.out.println("DEBUG: [Service] Event persisted with ID: " + event.getId());

            // 3. Register Creator
            System.out.println(
                    "DEBUG: [Service] Registering creator (User: " + creator.getId() + ") for Event: " + event.getId());
            boolean regSuccess = registrationDAO.registerUserForEvent(session, creator.getId(), event.getId());
            if (!regSuccess)
                throw new RuntimeException("Failed to register creator for event");
            System.out.println("DEBUG: [Service] Creator registration successful.");

            // 4. Bookmark/Save Event
            System.out.println("DEBUG: [Service] Bookmarking event for creator...");
            savedEventDAO.saveEvent(session, creator, event);
            System.out.println("DEBUG: [Service] Event bookmark successful.");

            tx.commit();
            System.out.println("DEBUG: [Service] Transaction COMMITTED for event: " + event.getId());
            System.out.println("DEBUG: [Service] All 3 actions committed successfully!");
            return event;

        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in EventService.createEventWithAutoEnroll: " + e.getMessage());
            if (tx != null && tx.isActive()) {
                try {
                    tx.rollback();
                    System.out.println("DEBUG: [Service] Transaction rolled back safely.");
                } catch (Exception rbEx) {
                    System.err.println("DEBUG: [Service] Rollback failed: " + rbEx.getMessage());
                }
            }
            e.printStackTrace();
            return null;
        }
    }
}
