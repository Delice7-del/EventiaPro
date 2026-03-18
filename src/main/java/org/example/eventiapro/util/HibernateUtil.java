package org.example.eventiapro.util;

import java.util.Properties;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.AvailableSettings;
import org.hibernate.service.ServiceRegistry;
import org.example.eventiapro.model.User;
import org.example.eventiapro.model.Event;
import org.example.eventiapro.model.Registration;
import org.example.eventiapro.model.Category;
import org.example.eventiapro.model.Venue;
import org.example.eventiapro.model.Announcement;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Hibernate Util class for MySQL Database
 */
public class HibernateUtil {

    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            synchronized (HibernateUtil.class) {
                if (sessionFactory == null) {
                    System.out.println("Initializing Hibernate SessionFactory...");
                    try {
                        Configuration configuration = new Configuration();
                        Properties settings = getProperties();

                        configuration.setProperties(settings);

                        // Entity classes
                        configuration.addAnnotatedClass(User.class);
                        configuration.addAnnotatedClass(Event.class);
                        configuration.addAnnotatedClass(Registration.class);
                        configuration.addAnnotatedClass(Category.class);
                        configuration.addAnnotatedClass(Venue.class);
                        configuration.addAnnotatedClass(org.example.eventiapro.model.SavedEvent.class);
                        configuration.addAnnotatedClass(Announcement.class);

                        ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                                .applySettings(configuration.getProperties())
                                .build();

                        sessionFactory = configuration.buildSessionFactory(serviceRegistry);
                        System.out.println("Hibernate SessionFactory initialized successfully.");
                        repairSchemaForce(); // Forceful cleanup of ghost columns
                        seedData();
                    } catch (Exception e) {
                        System.err.println("Error initializing Hibernate SessionFactory!");
                        e.printStackTrace();
                    }
                }
            }
        }
        return sessionFactory;
    }

    public static void repairSchemaForce() {
        if (sessionFactory == null)
            return;
        System.out.println("DEBUG: Running Nuclear Schema Repair...");
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            try {
                // Force drop the problematic 'venue' column if it exists
                // We use a safe try-catch for the SQL execution in case column doesn't exist
                try {
                    session.createNativeMutationQuery("ALTER TABLE events DROP COLUMN venue").executeUpdate();
                    System.out.println("DEBUG: Purged 'venue' ghost column from events table.");
                } catch (Exception e) {
                    System.out.println("DEBUG: 'venue' column already gone or error: " + e.getMessage());
                }

                // Force fix the role column length
                try {
                    session.createNativeMutationQuery("ALTER TABLE users MODIFY COLUMN role VARCHAR(20)")
                            .executeUpdate();
                    System.out.println("DEBUG: Adjusted users.role column length to 20.");
                } catch (Exception e) {
                    System.out.println("DEBUG: Could not modify role column: " + e.getMessage());
                }

                tx.commit();
            } catch (Exception e) {
                if (tx != null)
                    tx.rollback();
                System.err.println("DEBUG: RepairSchema transaction failed: " + e.getMessage());
            }
        }
    }

    private static void seedData() {
        if (sessionFactory == null)
            return;

        System.out.println("DEBUG: Starting database seeding check...");
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = null;
            try {
                // 1. Ensure Categories exist individually
                String[] catNames = { "Workshop", "Conference", "Webinar", "Meetup", "Festival" };
                for (String name : catNames) {
                    Category existing = session.createQuery("from Category where name = :name", Category.class)
                            .setParameter("name", name).uniqueResult();
                    if (existing == null) {
                        System.out.println("DEBUG: Seeding category: " + name);
                        tx = session.beginTransaction();
                        session.persist(new Category(name, name + " events"));
                        tx.commit();
                        tx = null;
                    }
                }

                // 2. Ensure Venues exist individually
                String[] venueNames = { "Main Hall", "Tech Hub", "Virtual Room", "Grand Ballroom", "Innovation Hub" };
                for (String name : venueNames) {
                    Venue existing = session.createQuery("from Venue where name = :name", Venue.class)
                            .setParameter("name", name).uniqueResult();
                    if (existing == null) {
                        System.out.println("DEBUG: Seeding venue: " + name);
                        tx = session.beginTransaction();
                        session.persist(new Venue(name, "Location for " + name, 100));
                        tx.commit();
                        tx = null;
                    }
                }

                // 3. Ensure Admin user exists
                User admin = session.createQuery("from User where username = 'admin'", User.class).uniqueResult();
                if (admin == null) {
                    System.out.println("DEBUG: Seeding admin user...");
                    tx = session.beginTransaction();
                    admin = new User();
                    admin.setUsername("admin");
                    admin.setEmail("admin@eventiapro.com");
                    admin.setPassword(BCrypt.hashpw("admin123", BCrypt.gensalt()));
                    admin.setRole("ADMIN");
                    session.persist(admin);
                    tx.commit();
                    tx = null;
                }

                // 4. Ensure Events exist
                long eventCount = session.createQuery("select count(e) from Event e", Long.class).uniqueResult();
                System.out.println("DEBUG: Current Event count: " + eventCount);
                if (eventCount == 0) {
                    System.out.println("DEBUG: Seeding sample events...");
                    tx = session.beginTransaction();
                    var categories = session.createQuery("from Category", Category.class).list();
                    var venues = session.createQuery("from Venue", Venue.class).list();

                    if (!categories.isEmpty() && !venues.isEmpty()) {
                        // Using explicit data to ensure consistency
                        Event e1 = new Event();
                        e1.setTitle("Java Advanced Workshop");
                        e1.setDescription("Deep dive into JVM internals and concurrent programming.");
                        e1.setEventDate(java.sql.Date.valueOf("2026-05-10"));
                        e1.setEventTime(java.sql.Time.valueOf("09:00:00"));
                        e1.setCapacity(30);
                        e1.setTicketPrice(49.99);
                        e1.setCategory(categories.get(0));
                        e1.setVenue(venues.get(1));
                        session.persist(e1);

                        Event e2 = new Event();
                        e2.setTitle("AI & Future Summit");
                        e2.setDescription("Exploring the next wave of neural networks and generative AI.");
                        e2.setEventDate(java.sql.Date.valueOf("2026-06-15"));
                        e2.setEventTime(java.sql.Time.valueOf("10:00:00"));
                        e2.setCapacity(200);
                        e2.setTicketPrice(150.00);
                        e2.setCategory(categories.get(1));
                        e2.setVenue(venues.get(3));
                        session.persist(e2);

                        Event e3 = new Event();
                        e3.setTitle("Cloud Native Webinar");
                        e3.setDescription("Learn how to scale microservices using Kubernetes and Docker.");
                        e3.setEventDate(java.sql.Date.valueOf("2026-05-20"));
                        e3.setEventTime(java.sql.Time.valueOf("15:00:00"));
                        e3.setCapacity(500);
                        e3.setTicketPrice(0.00);
                        e3.setCategory(categories.get(2));
                        e3.setVenue(venues.get(2));
                        session.persist(e3);

                        Event e4 = new Event();
                        e4.setTitle("Design Thinking Meetup");
                        e4.setDescription("Casual meetup to discuss user-centric design principles.");
                        e4.setEventDate(java.sql.Date.valueOf("2026-04-12"));
                        e4.setEventTime(java.sql.Time.valueOf("18:30:00"));
                        e4.setCapacity(40);
                        e4.setTicketPrice(15.00);
                        e4.setCategory(categories.get(3));
                        e4.setVenue(venues.get(1));
                        session.persist(e4);

                        tx.commit();
                        System.out.println("DEBUG: Seeding sample events completed successfully.");
                    }
                }
            } catch (Exception e) {
                System.err.println("DEBUG: Error occurred during seeding: " + e.getMessage());
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }
                throw e;
            }
        } catch (Exception e) {
            System.err.println("DEBUG: Critical error in seedData: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static Properties getProperties() {
        Properties settings = new Properties();

        // Support both Jakarta and Hibernate keys for stability
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/eventia_pro?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "root";
        String pass = "";

        settings.put(AvailableSettings.JAKARTA_JDBC_DRIVER, driver);
        settings.put("hibernate.connection.driver_class", driver);

        settings.put(AvailableSettings.JAKARTA_JDBC_URL, url);
        settings.put("hibernate.connection.url", url);

        settings.put(AvailableSettings.JAKARTA_JDBC_USER, user);
        settings.put("hibernate.connection.username", user);

        settings.put(AvailableSettings.JAKARTA_JDBC_PASSWORD, pass);
        settings.put("hibernate.connection.password", pass);

        // Hibernate Dialect
        settings.put(AvailableSettings.DIALECT, "org.hibernate.dialect.MySQLDialect");

        // Connection Pool Settings (Point 7)
        settings.put("hibernate.connection.pool_size", "10");
        settings.put("hibernate.connection.autocommit", "false");
        settings.put("hibernate.connection.release_mode", "after_transaction"); // Point 10

        // SQL display
        settings.put(AvailableSettings.SHOW_SQL, "true");
        settings.put(AvailableSettings.FORMAT_SQL, "true");

        // Schema update (Temporary "create" to fix ghost columns)
        settings.put(AvailableSettings.HBM2DDL_AUTO, "create");

        return settings;
    }
}
