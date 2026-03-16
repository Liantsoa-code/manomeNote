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
        String sql = "SELECT p.valeur_limite, r.libelle, o.signe FROM parametre p " +
                "JOIN resolution r ON p.resolution_id = r.id " +
                "JOIN operation o ON p.operation_id = o.id " +
                "WHERE p.matiere_id = ?";
                
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, matiereId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                List<String> validResolutions = new ArrayList<>();
                List<Double> validLimites = new ArrayList<>();
                
                List<String> allResolutions = new ArrayList<>();
                List<Double> allLimites = new ArrayList<>();
                
                while (rs.next()) {
                    double limite = rs.getDouble("valeur_limite");
                    String resolution = rs.getString("libelle");
                    String signe = rs.getString("signe");
                    
                    allResolutions.add(resolution);
                    allLimites.add(limite);
                    
                    boolean conditionMet = false;
                    switch(signe) {
                        case "<": conditionMet = sadCalculée < limite; break;
                        case "<=": conditionMet = sadCalculée <= limite; break;
                        case ">": conditionMet = sadCalculée > limite; break;
                        case ">=": conditionMet = sadCalculée >= limite; break;
                        case "=": conditionMet = sadCalculée == limite; break;
                    }
                    if (conditionMet) {
                        validResolutions.add(resolution);
                        validLimites.add(limite);
                    }
                }
                
                // Si aucune règle n'est configurée pour la matière
                if (allResolutions.isEmpty()) {
                    return "Moyenne";
                }
                
                // S'il y a des conditions qui correspondent exactement, on les compare, 
                // sinon on compare avec toutes les conditions pour trouver le seuil le plus proche
                List<String> resToCompare = validResolutions.isEmpty() ? allResolutions : validResolutions;
                List<Double> limToCompare = validLimites.isEmpty() ? allLimites : validLimites;
                
                if (resToCompare.size() == 1) {
                    return resToCompare.get(0);
                }
                
                int bestIndex = 0;
                double minEcart = Math.abs(sadCalculée - limToCompare.get(0));
                
                for (int i = 1; i < resToCompare.size(); i++) {
                    double ecart = Math.abs(sadCalculée - limToCompare.get(i));
                    if (ecart < minEcart) {
                        minEcart = ecart;
                        bestIndex = i;
                    } else if (ecart == minEcart) {
                        // Si l'écart est égal pour les deux, on prend la condition avec le seuil le plus petit
                        if (limToCompare.get(i) < limToCompare.get(bestIndex)) {
                            bestIndex = i;
                        }
                    }
                }
                return resToCompare.get(bestIndex);
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
