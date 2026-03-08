package com.grading.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // Les paramètres par défaut de PostgreSQL (à ajuster selon votre installation)
    private static final String URL = "jdbc:postgresql://localhost:5432/manomenote";
    private static final String USER = "postgres";
    private static final String PASSWORD = "123";

    public static Connection getConnection() throws SQLException {
        try {
            // Chargement du pilote PostgreSQL (Maven se charge de la dépendance)
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Pilote PostgreSQL non trouvé. Vérifiez votre pom.xml.", e);
        }
    }
}
