package com.grading.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoteDAO {

    /**
     * Récupère les notes d'un étudiant pour une matière spécifique depuis
     * PostgreSQL
     */
    public List<Double> getNotesParEtudiantEtMatiere(int etudiantId, int matiereId) {
        List<Double> notes = new ArrayList<>();
        String sql = "SELECT valeur FROM note WHERE etudiant_id = ? AND matiere_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, etudiantId);
            stmt.setInt(2, matiereId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notes.add(rs.getDouble("valeur"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des notes : " + e.getMessage());
            e.printStackTrace();
        }
        return notes;
    }
}
