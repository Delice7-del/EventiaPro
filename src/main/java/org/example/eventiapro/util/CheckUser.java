package org.example.eventiapro.util;

import org.example.eventiapro.dao.UserDAO;
import org.example.eventiapro.model.User;
import java.util.List;

public class CheckUser {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        if (users == null) {
            System.out.println("No users found or error accessing DB.");
            return;
        }
        System.out.println("USER LIST:");
        for (User u : users) {
            System.out.println("Username: " + u.getUsername() +
                    " | Email: " + u.getEmail() +
                    " | 2FA Enabled: " + u.isTwoFactorEnabled() +
                    " | Role: " + u.getRole());
        }
    }
}
