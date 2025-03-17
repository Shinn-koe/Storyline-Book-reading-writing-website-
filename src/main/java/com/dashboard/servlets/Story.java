package com.dashboard.servlets;

public class Story {
    private int id;
    private String title;
    private String description;
    private String coverImage;
    private int viewCount;
    private int likeCount; // New field for storing likes

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }

    public int getLikeCount() { return likeCount; } // New getter
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; } // New setter
}
