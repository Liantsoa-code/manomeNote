package com.grading.dao;

import com.grading.model.Correcteur;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CorrecteurDAO {
    public List<Correcteur> getAll() throws SQLException {
        List<Correcteur> list = new ArrayList<>();
        String sql = "SELECT * FROM correcteur ORDER BY id";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Correcteur(rs.getInt("id"), rs.getString("nom")));
            }
        }
        return list;
    }

    public void add(String nom) throws SQLException {
        String sql = "INSERT INTO correcteur(nom) VALUES(?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nom);
            pstmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM correcteur WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}
