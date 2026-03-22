package com.grading.dao;

import com.grading.model.Professeur;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProfesseurDAO {
    public List<Professeur> getAll() throws SQLException {
        List<Professeur> list = new ArrayList<>();
        String sql = "SELECT * FROM professeur ORDER BY id";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Professeur(rs.getInt("id"), rs.getString("nom")));
            }
        }
        return list;
    }

    public void add(String nom) throws SQLException {
        String sql = "INSERT INTO professeur(nom) VALUES(?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nom);
            pstmt.executeUpdate();
        }
    }

    public void update(int id, String nom) throws SQLException {
        String sql = "UPDATE professeur SET nom = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nom);
            pstmt.setInt(2, id);
            pstmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM professeur WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}
