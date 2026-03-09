package org.example.eventiapro.dao;

import org.example.eventiapro.model.Event;
import org.example.eventiapro.model.SavedEvent;
import org.example.eventiapro.model.User;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class SavedEventDAO {

    public void saveEvent(User user, Event event) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            saveEvent(session, user, event);
            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void saveEvent(Session session, User user, Event event) {
        try {
            SavedEvent savedEvent = new SavedEvent(user, event);
            session.persist(savedEvent);
        } catch (Exception e) {
            System.err.println("ERROR in saveEvent (shared session): " + e.getMessage());
            throw e; // Rethrow to trigger rollback in service
        }
    }

    public void unsaveEvent(int userId, int eventId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            String hql = "delete from SavedEvent where user.id = :userId and event.id = :eventId";
            var query = session.createMutationQuery(hql);
            query.setParameter("userId", userId);
            query.setParameter("eventId", eventId);
            query.executeUpdate();
            transaction.commit();
        } catch (Exception e) {
            System.err.println("DEBUG: Error in unsaveEvent: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    System.err.println("DEBUG: Rollback failed: " + re.getMessage());
                }
            }
            e.printStackTrace();
        }
    }

    public List<Event> getSavedEventsByUser(int userId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            String hql = "select se.event from SavedEvent se where se.user.id = :userId order by se.savedAt desc";
            Query<Event> query = session.createQuery(hql, Event.class);
            query.setParameter("userId", userId);
            List<Event> list = query.list();
            transaction.commit();
            return list;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getSavedEventsByUser: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    /* ignore */
                }
            }
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public boolean isEventSaved(int userId, int eventId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            String hql = "select count(se) from SavedEvent se where se.user.id = :userId and se.event.id = :eventId";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("userId", userId);
            query.setParameter("eventId", eventId);
            boolean result = query.uniqueResult() > 0;
            transaction.commit();
            return result;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in isEventSaved: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    /* ignore */
                }
            }
            e.printStackTrace();
            return false;
        }
    }
}
