package com.grading.dao;

import com.grading.model.Note;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoteDAO {

    public List<Double> getValeursParCandidatEtMatiere(int candidatId, int matiereId) {
        List<Double> notes = new ArrayList<>();
        String sql = "SELECT valeur FROM note WHERE candidat_id = ? AND matiere_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, candidatId);
            stmt.setInt(2, matiereId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notes.add(rs.getDouble("valeur"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notes;
    }

    public List<Note> getAllWithNames() {
        List<Note> list = new ArrayList<>();
        String sql = "SELECT n.*, c.nom as candidat_nom, cr.nom as correcteur_nom, m.libelle as matiere_libelle " +
                "FROM note n " +
                "JOIN candidat c ON n.candidat_id = c.id " +
                "JOIN correcteur cr ON n.correcteur_id = cr.id " +
                "JOIN matiere m ON n.matiere_id = m.id " +
                "ORDER BY n.date_heure DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Note n = new Note();
                n.setId(rs.getInt("id"));
                n.setEtudiantNom(rs.getString("candidat_nom"));
                n.setProfesseurNom(rs.getString("correcteur_nom"));
                n.setMatiereNom(rs.getString("matiere_libelle"));
                n.setValeur(rs.getDouble("valeur"));
                n.setDateHeure(rs.getTimestamp("date_heure"));
                list.add(n);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void add(int candId, int corrId, int matId, double valeur) throws SQLException {
        String sql = "INSERT INTO note (candidat_id, correcteur_id, matiere_id, valeur) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, candId);
            stmt.setInt(2, corrId);
            stmt.setInt(3, matId);
            stmt.setDouble(4, valeur);
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM note WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
