// JavaScript for Write Story Button
function openWriteStoryModal() {
    document.getElementById("writeStoryModal").style.display = "flex";
}

function closeModal() {
    document.querySelectorAll(".modal").forEach(modal => {
        modal.style.display = "none";
    });
}

function showNewStoryInterface() {
    // Redirect to a new JSP for better structure
    window.location.href = "newStory.jsp";
}

function redirectToMyStories() {
    window.location.href = "myStories.jsp"; // Adjust this path to your My Stories page
}
/**
 * 
 */