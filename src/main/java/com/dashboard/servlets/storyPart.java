package com.dashboard.servlets;

public class storyPart {
    private int id;
    private int storyId;  // Added story_id as a foreign key
    private String title;
    private String content;
    private String status;
    private String payment;

    
    public storyPart(int id, int storyId, String title, String content, String status, String payment) {
		super();
		this.id = id;
		this.storyId = storyId;
		this.title = title;
		this.content = content;
		this.status = status;
		this.payment = payment;
	}

	// Constructor
    public storyPart(int storyId, String title, String content, String status, String payment) {
        this.storyId = storyId;
        this.title = title;
        this.content = content;
        this.status = status;
        this.payment = payment;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStoryId() {
        return storyId;
    }

    public void setStoryId(int storyId) {
        this.storyId = storyId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }
}
