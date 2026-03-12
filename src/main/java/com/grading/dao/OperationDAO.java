package com.grading.dao;

import com.grading.model.Operation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OperationDAO {
    public List<Operation> getAll() throws SQLException {
        List<Operation> list = new ArrayList<>();
        String sql = "SELECT * FROM operation ORDER BY id";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Operation(rs.getInt("id"), rs.getString("signe")));
            }
        }
        return list;
    }

    public void add(String signe) throws SQLException {
        String sql = "INSERT INTO operation(signe) VALUES(?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, signe);
            pstmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM operation WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}
