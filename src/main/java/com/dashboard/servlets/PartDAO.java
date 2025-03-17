package com.dashboard.servlets;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class PartDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/storyline";
    private String jdbcUsername = "root";  // Change to your DB user
    private String jdbcPassword = "shinn";  // Change to your DB password

    private static final String INSERT_PART_SQL = "INSERT INTO parts (story_id, title, content, status, payment) VALUES (?, ?, ?, ?, ?);";
    private static final String SELECT_PARTS_BY_STORY_ID  = "SELECT * FROM parts WHERE story_id = ? ORDER BY id ASC";
    private static final String DELETE_PART_SQL = "DELETE FROM parts WHERE id = ?";
    private static final String SELECT_PUBLISH_PARTS = "SELECT * FROM parts WHERE status = 'published' AND story_id = ?";
    private static final String SELECT_PART_BY_ID = "SELECT * FROM parts WHERE id = ?";
    private static final String UPDATE_PART_SQL = "UPDATE parts SET title = ?, content = ?, status = ?, payment = ? WHERE id = ?";

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    public void insertPart(storyPart part) {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_PART_SQL)) {
        	preparedStatement.setInt(1, part.getStoryId());
            preparedStatement.setString(2, part.getTitle());
            preparedStatement.setString(3, part.getContent());
            preparedStatement.setString(4, part.getStatus());
            preparedStatement.setString(5, part.getPayment());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean updatePart(storyPart part) throws SQLException {
        boolean rowUpdated = false;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_PART_SQL)) {
            
            // ✅ Set all parameters before executing
            statement.setString(1, part.getTitle());
            statement.setString(2, part.getContent());
            statement.setString(3, part.getStatus());
            statement.setString(4, part.getPayment());
            statement.setInt(5, part.getId());  // ✅ Ensure ID is set before execution

            int rowsAffected = statement.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);  // Debugging

            rowUpdated = rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }



    public List<storyPart> selectPartsByStatus(int storyId) {
        List<storyPart> parts = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PUBLISH_PARTS)) {
             
        	 preparedStatement.setInt(1, storyId);
        	 ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
            	storyPart part = new storyPart(
                        rs.getInt("id"),
                        rs.getInt("story_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("status"),
                        rs.getString("payment")
                        );
            	 parts.add(part);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return parts;
    }

    public List<storyPart> getPartsByStoryId(int storyId) {
        List<storyPart> parts = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PARTS_BY_STORY_ID )) {
        	preparedStatement.setInt(1, storyId);
        	ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
            	storyPart part = new storyPart(
            			rs.getInt("id"),
                        rs.getInt("story_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("status"),
                        rs.getString("payment")
                    );
                    parts.add(part);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return parts;
    }
    
    public storyPart getPartById(int partId) {
    	storyPart part = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PART_BY_ID)) {
            
            preparedStatement.setInt(1, partId);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                part = new storyPart(
                    rs.getInt("id"),
                    rs.getInt("story_id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("status"),
                    rs.getString("payment")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return part; // Return the retrieved part or null if not found
    }
    

    public boolean deletePart(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_PART_SQL)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

}
