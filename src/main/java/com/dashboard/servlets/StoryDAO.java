package com.dashboard.servlets;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.dashboard.utils.DBConnection;

public class StoryDAO {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/storyline";
    private static final String DB_USER = "root";  // Change to your DB user
    private static final String DB_PASSWORD = "shinn";  // Change to your DB password

    public static List<Story> getPublishedStories() {
        List<Story> stories = new ArrayList<>();
        String query = "SELECT s.id, s.title, s.description, s.cover_image, " +
                       "(SELECT COUNT(DISTINCT v.user_id) FROM views v WHERE v.story_id = s.id) AS view_count " +
                       "FROM stories s WHERE s.status = 'published' ORDER BY s.created_at DESC LIMIT 6";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Story story = new Story();
                story.setId(rs.getInt("id"));
                story.setTitle(rs.getString("title"));
                story.setDescription(rs.getString("description"));
                story.setCoverImage(rs.getString("cover_image"));
                story.setViewCount(rs.getInt("view_count"));  // Setting view count
                stories.add(story);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stories;
    }

    // New method to get the most liked stories
    public static List<Story> getMostLikedStories() {
        List<Story> stories = new ArrayList<>();
        String query = "SELECT s.id, s.title, s.description, s.cover_image, COUNT(l.user_id) AS like_count " +
                       "FROM stories s " +
                       "LEFT JOIN likes l ON s.id = l.story_id " +
                       "WHERE s.status = 'published' " +
                       "GROUP BY s.id " +
                       "ORDER BY like_count DESC " +
                       "LIMIT 6";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Story story = new Story();
                story.setId(rs.getInt("id"));
                story.setTitle(rs.getString("title"));
                story.setDescription(rs.getString("description"));
                story.setCoverImage(rs.getString("cover_image"));
                story.setLikeCount(rs.getInt("like_count"));  // Setting like count
                stories.add(story);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stories;
    }

    // New method to get story details by ID
    public static Story getStoryById(int storyId) {
        Story story = null;
        String query = "SELECT id, title, description, cover_image FROM stories WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, storyId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    story = new Story();
                    story.setId(rs.getInt("id"));
                    story.setTitle(rs.getString("title"));
                    story.setDescription(rs.getString("description"));
                    story.setCoverImage(rs.getString("cover_image"));
                   
                    // Add other properties as needed
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return story;
    }
    public static List<Story> getUserLibraryStories(int userId) {
        List<Story> stories = new ArrayList<>();
        String query = "SELECT s.* FROM stories s INNER JOIN downloads d ON s.id = d.story_id WHERE d.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Story story = new Story();
                story.setId(rs.getInt("id"));
                story.setTitle(rs.getString("title"));
                story.setDescription(rs.getString("description"));
                story.setCoverImage(rs.getString("cover_image"));
                stories.add(story);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stories;
    }

}
