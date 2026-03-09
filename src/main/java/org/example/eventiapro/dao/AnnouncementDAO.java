package org.example.eventiapro.dao;

import org.example.eventiapro.model.Announcement;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {

    public boolean saveAnnouncement(Announcement announcement) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(announcement);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public List<Announcement> getAllAnnouncements() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Announcement order by createdAt desc", Announcement.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public boolean deleteAnnouncement(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Announcement announcement = session.get(Announcement.class, id);
            if (announcement != null) {
                session.remove(announcement);
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
}
