package http

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cricketapp/backend/internal/community/domain"
	"github.com/go-chi/chi/v5"
)

type CommunityHandler struct {
	service domain.CommunityService
}

// NewCommunityHandler creates a new community handler
func NewCommunityHandler(service domain.CommunityService) *CommunityHandler {
	return &CommunityHandler{service: service}
}

// CreatePost creates a new post
func (h *CommunityHandler) CreatePost(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	var req domain.CreatePostRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	post, err := h.service.CreatePost(r.Context(), userID, &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Post created successfully",
		"data":    post,
	})
}

// GetFeed retrieves the community feed
func (h *CommunityHandler) GetFeed(w http.ResponseWriter, r *http.Request) {
	// Optional user ID from context (for is_liked_by_user flag)
	userID, _ := r.Context().Value("user_id").(string)

	page, _ := strconv.Atoi(r.URL.Query().Get("page"))
	if page < 1 {
		page = 1
	}

	limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))
	if limit < 1 || limit > 100 {
		limit = 20
	}

	postType := r.URL.Query().Get("type")

	feed, err := h.service.GetFeed(r.Context(), page, limit, postType, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Feed retrieved successfully",
		"data":    feed,
	})
}

// GetPostDetails retrieves a specific post with details
func (h *CommunityHandler) GetPostDetails(w http.ResponseWriter, r *http.Request) {
	postID := chi.URLParam(r, "id")
	userID, _ := r.Context().Value("user_id").(string)

	post, err := h.service.GetPostDetails(r.Context(), postID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Post retrieved successfully",
		"data":    post,
	})
}

// UpdatePost updates a post
func (h *CommunityHandler) UpdatePost(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	postID := chi.URLParam(r, "id")

	var req struct {
		Content string `json:"content"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	if err := h.service.UpdatePost(r.Context(), userID, postID, req.Content); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Post updated successfully",
	})
}

// DeletePost deletes a post
func (h *CommunityHandler) DeletePost(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	postID := chi.URLParam(r, "id")

	if err := h.service.DeletePost(r.Context(), userID, postID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Post deleted successfully",
	})
}

// GetUserPosts retrieves all posts by a specific user
func (h *CommunityHandler) GetUserPosts(w http.ResponseWriter, r *http.Request) {
	targetUserID := chi.URLParam(r, "userId")
	viewerUserID, _ := r.Context().Value("user_id").(string)

	posts, err := h.service.GetUserPosts(r.Context(), targetUserID, viewerUserID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "User posts retrieved successfully",
		"data":    posts,
	})
}

// AddComment adds a comment to a post
func (h *CommunityHandler) AddComment(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	postID := chi.URLParam(r, "id")

	var req domain.CreateCommentRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	comment, err := h.service.AddComment(r.Context(), userID, postID, &req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Comment added successfully",
		"data":    comment,
	})
}

// GetPostComments retrieves all comments for a post
func (h *CommunityHandler) GetPostComments(w http.ResponseWriter, r *http.Request) {
	postID := chi.URLParam(r, "id")
	userID, _ := r.Context().Value("user_id").(string)

	comments, err := h.service.GetPostComments(r.Context(), postID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Comments retrieved successfully",
		"data":    comments,
	})
}

// DeleteComment deletes a comment
func (h *CommunityHandler) DeleteComment(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	commentID := chi.URLParam(r, "commentId")

	if err := h.service.DeleteComment(r.Context(), userID, commentID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Comment deleted successfully",
	})
}

// LikePost likes a post
func (h *CommunityHandler) LikePost(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	postID := chi.URLParam(r, "id")

	if err := h.service.LikePost(r.Context(), userID, postID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Post liked successfully",
	})
}

// UnlikePost unlikes a post
func (h *CommunityHandler) UnlikePost(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	postID := chi.URLParam(r, "id")

	if err := h.service.UnlikePost(r.Context(), userID, postID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Post unliked successfully",
	})
}

// LikeComment likes a comment
func (h *CommunityHandler) LikeComment(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	commentID := chi.URLParam(r, "commentId")

	if err := h.service.LikeComment(r.Context(), userID, commentID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Comment liked successfully",
	})
}

// UnlikeComment unlikes a comment
func (h *CommunityHandler) UnlikeComment(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value("user_id").(string)
	if !ok {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}

	commentID := chi.URLParam(r, "commentId")

	if err := h.service.UnlikeComment(r.Context(), userID, commentID); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"message": "Comment unliked successfully",
	})
}
