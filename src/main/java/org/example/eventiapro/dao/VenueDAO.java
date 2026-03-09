package org.example.eventiapro.dao;

import org.example.eventiapro.model.Venue;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class VenueDAO {
    public Venue saveAndReturnVenue(Venue venue) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(venue);
            transaction.commit();
            return venue;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in saveAndReturnVenue: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return null;
        }
    }

    public List<Venue> getAllVenues() {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            List<Venue> list = session.createQuery("from Venue", Venue.class).list();
            transaction.commit();
            return list;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getAllVenues: " + e.getMessage());
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

    public Venue getVenueById(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Venue venue = session.get(Venue.class, id);
            transaction.commit();
            return venue;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getVenueById: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    /* ignore */
                }
            }
            e.printStackTrace();
            return null;
        }
    }
}
