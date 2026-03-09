package org.example.eventiapro.model;

import jakarta.persistence.*;
import java.sql.Timestamp;

/**
 * Represents a User in the system.
 * Each user has an id,username,password,email,role,createdAt,twoFactorEnabled
 * This class is mapped to the "user" table in the database using JPA
 * annotations.
 *
 * @author DELICE KEZA
 * @version 1.0
 */
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false, columnDefinition = "VARCHAR(255)")
    private String password;

    @Column(unique = true, nullable = false)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private Role role;

    @Column(name = "created_at", insertable = false, updatable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private Timestamp createdAt;

    @Column(name = "two_factor_enabled")
    private Boolean twoFactorEnabled;

    public enum Role {
        ADMIN, USER, ORGANIZER
    }

    public User() {
    }

    /**
     * Constructs a new User with all properties.
     *
     * @param id        unique identifier
     * @param username  username of the user
     * @param password  password of the user
     * @param email     email of the user
     * @param role      role of the user
     * @param createdAt Time the user created it
     * 
     */
    public User(int id, String username, String password, String email, Role role, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Boolean isTwoFactorEnabled() {
        return twoFactorEnabled != null && twoFactorEnabled;
    }

    public void setTwoFactorEnabled(Boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role != null ? role.name() : null;
    }

    public void setRole(String role) {
        this.role = role != null ? Role.valueOf(role) : null;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
