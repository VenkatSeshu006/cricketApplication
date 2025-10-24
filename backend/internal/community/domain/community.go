package domain

import "time"

// Post represents a community post
type Post struct {
	ID            string    `json:"id"`
	UserID        string    `json:"user_id"`
	UserName      string    `json:"user_name"`  // From users table
	UserPhoto     string    `json:"user_photo"` // From users table
	Content       string    `json:"content"`
	MediaURLs     []string  `json:"media_urls,omitempty"`
	PostType      string    `json:"post_type"`  // general, match, training, achievement, question
	Visibility    string    `json:"visibility"` // public, friends, private
	LikesCount    int       `json:"likes_count"`
	CommentsCount int       `json:"comments_count"`
	SharesCount   int       `json:"shares_count"`
	IsLikedByUser bool      `json:"is_liked_by_user"` // Indicates if current user liked this post
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// Comment represents a comment on a post
type Comment struct {
	ID            string    `json:"id"`
	PostID        string    `json:"post_id"`
	UserID        string    `json:"user_id"`
	UserName      string    `json:"user_name"`  // From users table
	UserPhoto     string    `json:"user_photo"` // From users table
	Content       string    `json:"content"`
	LikesCount    int       `json:"likes_count"`
	IsLikedByUser bool      `json:"is_liked_by_user"` // Indicates if current user liked this comment
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// Like represents a like on a post or comment
type Like struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	PostID    string    `json:"post_id,omitempty"`
	CommentID string    `json:"comment_id,omitempty"`
	CreatedAt time.Time `json:"created_at"`
}

// CreatePostRequest represents post creation request
type CreatePostRequest struct {
	Content    string   `json:"content"`
	MediaURLs  []string `json:"media_urls"`
	PostType   string   `json:"post_type"`
	Visibility string   `json:"visibility"`
}

// CreateCommentRequest represents comment creation request
type CreateCommentRequest struct {
	Content string `json:"content"`
}

// FeedResponse represents paginated feed
type FeedResponse struct {
	Posts      []Post     `json:"posts"`
	Pagination Pagination `json:"pagination"`
}

// Pagination represents pagination info
type Pagination struct {
	Page       int `json:"page"`
	Limit      int `json:"limit"`
	Total      int `json:"total"`
	TotalPages int `json:"total_pages"`
}
