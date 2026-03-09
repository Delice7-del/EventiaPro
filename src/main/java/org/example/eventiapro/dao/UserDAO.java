package org.example.eventiapro.dao;

import org.example.eventiapro.model.User;
import org.example.eventiapro.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    public boolean registerUser(User user) {
        System.out.println("DEBUG: Registering user: " + user.getUsername());
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            // Hash the password before saving
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            user.setPassword(hashedPassword);
            session.persist(user);
            transaction.commit();
            System.out.println("DEBUG: User registered successfully: " + user.getUsername());
            return true;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in registerUser: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    // Suppress if logical connection is closed (noisy side-effect)
                    if (re.getMessage() == null || !re.getMessage().contains("is closed")) {
                        System.err.println("DEBUG: Rollback failed: " + re.getMessage());
                    }
                }
            }
            // Propagate the actual exception so AuthServlet can analyze it
            throw e;
        }
    }

    public User login(String username, String password) {
        System.out.println("DEBUG: UserDAO.login attempt for: " + username);
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Query<User> query = session.createQuery("from User where username = :un", User.class);
            query.setParameter("un", username);
            User user = query.uniqueResult();

            if (user != null) {
                System.out.println("DEBUG: User found: " + username + ". Stored hash starts with: "
                        + (user.getPassword() != null && user.getPassword().length() > 10
                                ? user.getPassword().substring(0, 7)
                                : "INVALID"));

                if (BCrypt.checkpw(password, user.getPassword())) {
                    System.out.println("DEBUG: Password verified for: " + username);
                    transaction.commit();
                    return user;
                } else {
                    System.out.println("DEBUG: Password MISMATCH for: " + username);
                }
            } else {
                System.out.println("DEBUG: User NOT FOUND: " + username);
            }
            transaction.commit();
            return null;
        } catch (Exception e) {
            System.err.println("DEBUG: UserDAO.login exception: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    if (re.getMessage() == null || !re.getMessage().contains("is closed")) {
                        System.err.println("DEBUG: Rollback failed: " + re.getMessage());
                    }
                }
            }
            throw e;
        }
    }

    public User getUserById(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            User user = session.get(User.class, id);
            transaction.commit();
            return user;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getUserById: " + e.getMessage());
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

    public User getUserByUsername(String username) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Query<User> query = session.createQuery("from User where username = :username", User.class);
            query.setParameter("username", username);
            User user = query.uniqueResult();
            transaction.commit();
            return user;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getUserByUsername: " + e.getMessage());
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

    public java.util.List<User> getAllUsers() {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            java.util.List<User> users = session.createQuery("from User", User.class).list();
            transaction.commit();
            return users;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in getAllUsers: " + e.getMessage());
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

    public boolean updateUser(User user) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(user);
            transaction.commit();
            return true;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in updateUser: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    System.err.println("DEBUG: Rollback failed: " + re.getMessage());
                }
            }
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int userId, String newPassword) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null) {
                user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
                session.merge(user);
                transaction.commit();
                return true;
            }
            transaction.commit();
            return false;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in updatePassword: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    System.err.println("DEBUG: Rollback failed: " + re.getMessage());
                }
            }
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null) {
                session.remove(user);
                transaction.commit();
                return true;
            }
            transaction.commit();
            return false;
        } catch (Exception e) {
            System.err.println("DEBUG: Error in deleteUser: " + e.getMessage());
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception re) {
                    System.err.println("DEBUG: Rollback failed: " + re.getMessage());
                }
            }
            e.printStackTrace();
            return false;
        }
    }
}
