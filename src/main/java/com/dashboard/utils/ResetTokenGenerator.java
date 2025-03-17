package com.dashboard.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

public class ResetTokenGenerator {
    public static String generateResetToken(String email) throws SQLException {
        String token = UUID.randomUUID().toString();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE users SET reset_token = ? WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);
            stmt.setString(2, email);
            stmt.executeUpdate();
        }
        return token;
    }
}
