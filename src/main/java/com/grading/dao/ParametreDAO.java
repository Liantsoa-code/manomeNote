package com.grading.dao;

import com.grading.model.Parametre;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParametreDAO {

    public List<Parametre> getAll() throws SQLException {
        List<Parametre> list = new ArrayList<>();
        String sql = "SELECT p.*, m.libelle as matiere_libelle, r.libelle as resolution_libelle, o.signe as operation_signe "
                +
                "FROM parametre p " +
                "JOIN matiere m ON p.matiere_id = m.id " +
                "JOIN resolution r ON p.resolution_id = r.id " +
                "JOIN operation o ON p.operation_id = o.id " +
                "ORDER BY m.libelle";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Parametre p = new Parametre();
                p.setId(rs.getInt("id"));
                p.setMatiereNom(rs.getString("matiere_libelle"));
                p.setResolutionNom(rs.getString("resolution_libelle"));
                p.setComparateurSymbole(rs.getString("operation_signe"));
                p.setValeurLimite(rs.getDouble("valeur_limite"));
                list.add(p);
            }
        }
        return list;
    }

    public void add(int matId, int opId, int resId, double limite) throws SQLException {
        String sql = "INSERT INTO parametre (matiere_id, operation_id, resolution_id, valeur_limite) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, matId);
            pstmt.setInt(2, opId);
            pstmt.setInt(3, resId);
            pstmt.setDouble(4, limite);
            pstmt.executeUpdate();
        }
    }

    public String getResolutionAppropriee(int matiereId, double sadCalculée) {
        String sql = "SELECT r.libelle, p.valeur_limite FROM parametre p " +
                "JOIN resolution r ON p.resolution_id = r.id " +
                "JOIN operation o ON p.operation_id = o.id " +
                "WHERE p.matiere_id = ? " +
                "AND ((o.signe = '<' AND ? < p.valeur_limite) OR " +
                "     (o.signe = '<=' AND ? <= p.valeur_limite) OR " +
                "     (o.signe = '>' AND ? > p.valeur_limite) OR " +
                "     (o.signe = '>=' AND ? >= p.valeur_limite))";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, matiereId);
            for (int i = 2; i <= 5; i++)
                stmt.setDouble(i, sadCalculée);
            try (ResultSet rs = stmt.executeQuery()) {
                List<String> resolutions = new ArrayList<>();
                List<Double> limites = new ArrayList<>();
                
                while (rs.next()) {
                    resolutions.add(rs.getString("libelle"));
                    limites.add(rs.getDouble("valeur_limite"));
                }
                
                if (resolutions.isEmpty()) {
                    return "Moyenne";
                }
                if (resolutions.size() == 1) {
                    return resolutions.get(0);
                }
                
                // Lorsque la moyenne est dans les deux conditions d'opération
                int bestIndex = 0;
                double minEcart = Math.abs(sadCalculée - limites.get(0));
                
                for (int i = 1; i < resolutions.size(); i++) {
                    double ecart = Math.abs(sadCalculée - limites.get(i));
                    if (ecart < minEcart) {
                        minEcart = ecart;
                        bestIndex = i;
                    } else if (ecart == minEcart) {
                        // Si l'ecart est egal pour les deux, on prends la condition avec le seuil le plus petit
                        if (limites.get(i) < limites.get(bestIndex)) {
                            bestIndex = i;
                        }
                    }
                }
                return resolutions.get(bestIndex);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Moyenne";
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM parametre WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}
