package com.grading.dao;

import com.grading.model.Etudiant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EtudiantDAO {
    public List<Etudiant> getAll() throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String sql = "SELECT * FROM etudiant ORDER BY id";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Etudiant(rs.getInt("id"), rs.getString("nom")));
            }
        }
        return list;
    }

    public void add(String nom) throws SQLException {
        String sql = "INSERT INTO etudiant(nom) VALUES(?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nom);
            pstmt.executeUpdate();
        }
    }

    public void update(int id, String nom) throws SQLException {
        String sql = "UPDATE etudiant SET nom = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nom);
            pstmt.setInt(2, id);
            pstmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM etudiant WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}
