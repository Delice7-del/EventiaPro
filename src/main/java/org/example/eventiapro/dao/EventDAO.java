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
        return searchEvents(null, null);
    }

    public List<Event> searchEvents(Integer categoryId, String searchQuery) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "from Event e where 1=1";
            
            if (categoryId != null && categoryId > 0) {
                hql += " and e.category.id = :catId";
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                hql += " and (lower(e.title) like :search or lower(e.description) like :search)";
            }
            hql += " order by eventDate asc";

            var query = session.createQuery(hql, Event.class);
            
            if (categoryId != null && categoryId > 0) {
                query.setParameter("catId", categoryId);
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                query.setParameter("search", "%" + searchQuery.toLowerCase().trim() + "%");
            }
            
            return query.list();
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