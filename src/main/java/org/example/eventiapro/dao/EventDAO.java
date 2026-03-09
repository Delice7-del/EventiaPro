package org.example.eventiapro.dao;

import org.example.eventiapro.model.Event;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class EventDAO {

    public Event addEventAndReturn(Event event) {
        System.out.println("DEBUG: EventDAO.addEventAndReturn called for: " + event.getTitle());
        Transaction tx = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            Event persisted;

            // SAFE ID CHECK (int is never null)
            if (event.getId() > 0) {
                System.out.println("DEBUG: Merging existing event with ID: " + event.getId());
                persisted = session.merge(event);
            } else {
                System.out.println("DEBUG: Persisting NEW event");
                session.persist(event);
                persisted = event;
            }

            tx.commit();
            System.out.println("DEBUG: Event saved successfully with ID: " + persisted.getId());
            return persisted;

        } catch (Exception e) {
            System.err.println("ERROR saving event: " + e.getMessage());
            e.printStackTrace();
            safeRollback(tx);
            return null;
        }
    }

    public boolean addEvent(Event event) {
        return addEventAndReturn(event) != null;
    }

    private void safeRollback(Transaction tx) {
        if (tx != null && tx.isActive()) {
            try {
                tx.rollback();
            } catch (Exception ex) {
                System.err.println("Rollback failed (connection probably already closed): " + ex.getMessage());
            }
        }
    }

    public List<Event> getAllEvents() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Event order by eventDate asc", Event.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public Event getEventById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Event.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateEvent(Event event) {
        Transaction tx = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(event);
            tx.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            safeRollback(tx);
            return false;
        }
    }

    public boolean deleteEvent(int id) {
        Transaction tx = null;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            Event event = session.get(Event.class, id);
            if (event != null) {
                session.remove(event);
                tx.commit();
                return true;
            }

            return false;

        } catch (Exception e) {
            e.printStackTrace();
            safeRollback(tx);
            return false;
        }
    }
}