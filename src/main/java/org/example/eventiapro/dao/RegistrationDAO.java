package org.example.eventiapro.dao;

import org.example.eventiapro.model.Registration;
import org.example.eventiapro.model.Event;
import org.example.eventiapro.model.Venue;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/**
 * @see org.example.eventiapro.model.Registration
 */
public class RegistrationDAO {

    // Original method (keeps existing logic working)
    public boolean registerUserForEvent(int userId, int eventId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            boolean success = registerUserForEvent(session, userId, eventId);
            tx.commit();
            return success;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // New method (participates in a shared transaction)
    public boolean registerUserForEvent(Session session, int userId, int eventId) {
        try {
            Registration reg = new Registration();
            reg.setUserId(userId);
            reg.setEventId(eventId);
            reg.setStatus("Upcoming");
            session.persist(reg);
            return true;
        } catch (Exception e) {
            System.err.println("ERROR in registerUserForEvent (shared session): " + e.getMessage());
            return false;
        }
    }

    // Cancel registration
    public boolean cancelRegistration(int regId) {
        return updateStatus(regId, "Cancelled");
    }

    // Delete registration
    public boolean deleteRegistration(int regId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Registration reg = session.get(Registration.class, regId);
            if (reg != null) {
                session.remove(reg);
            }

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Update registration status
    public boolean updateStatus(int regId, String status) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Registration reg = session.get(Registration.class, regId);
            if (reg != null) {
                reg.setStatus(status);
                session.merge(reg);
            }

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Check if user is registered for an event
    public boolean isUserRegistered(int userId, int eventId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            String hql = "select 1 from Registration where userId = :uid and eventId = :eid";
            boolean registered = session.createQuery(hql, Integer.class)
                    .setParameter("uid", userId)
                    .setParameter("eid", eventId)
                    .uniqueResult() != null;

            transaction.commit();
            return registered;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Get all registrations for an event
    public List<Registration> getRegistrationsForEvent(int eventId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            List<Registration> list = session.createQuery(
                    "from Registration r where r.eventId = :eid", Registration.class)
                    .setParameter("eid", eventId)
                    .list();

            // Fetch username for each registration
            for (Registration r : list) {
                String username = session.createQuery(
                        "select username from User where id = :uid", String.class)
                        .setParameter("uid", r.getUserId())
                        .uniqueResult();
                r.setUsername(username);
            }

            transaction.commit();
            return list;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Get registrations for a user
    public List<Registration> getRegistrationsByUser(int userId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            List<Registration> list = session.createQuery(
                    "from Registration r where r.userId = :uid", Registration.class)
                    .setParameter("uid", userId)
                    .list();

            for (Registration r : list) {
                Event event = session.get(Event.class, r.getEventId());
                if (event != null) {
                    Venue venue = event.getVenue() != null ? session.get(Venue.class, event.getVenue().getId()) : null;
                    event.setVenue(venue);
                    r.setEvent(event);
                    r.setEventTitle(event.getTitle());

                    if (r.getStatus() == null) {
                        r.setStatus(event.getEventDate().getTime() < System.currentTimeMillis() ? "Past" : "Upcoming");
                    }
                }
            }

            transaction.commit();
            return list;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Get registration by ID
    public Registration getRegistrationById(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            Registration reg = session.get(Registration.class, id);
            if (reg != null) {
                Event event = session.get(Event.class, reg.getEventId());
                if (event != null && event.getVenue() != null) {
                    Venue venue = session.get(Venue.class, event.getVenue().getId());
                    event.setVenue(venue);
                }
                reg.setEvent(event);
            }

            transaction.commit();
            return reg;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            e.printStackTrace();
            return null;
        }
    }
}