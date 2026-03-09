package org.example.eventiapro.dao;

import org.example.eventiapro.model.Category;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * @see.org.example.eventiapro.model.Category
 */
public class CategoryDAO {
    public Category saveAndReturnCategory(Category category) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(category);
            transaction.commit();
            return category;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in saveAndReturnCategory: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return null;
        }
    }

    public boolean saveCategory(Category category) {
        return saveAndReturnCategory(category) != null;
    }

    public List<Category> getAllCategories() {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            List<Category> list = session.createQuery("from Category", Category.class).list();
            transaction.commit();
            return list;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getAllCategories: " + e.getMessage());
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

    public Category getCategoryById(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Category category = session.get(Category.class, id);
            transaction.commit();
            return category;
        } catch (Exception e) {
            if (transaction != null)
                transaction.rollback();
            e.printStackTrace();
            return null;
        }
    }

    public void addCategory(Category category) {
        saveCategory(category);
    }

    public Category getCategoryByName(String name) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Category category = session.createQuery("from Category where name = :name", Category.class)
                    .setParameter("name", name)
                    .uniqueResult();
            transaction.commit();
            return category;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getCategoryByName: " + e.getMessage());
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
