package domain

import "context"

// CommunityRepository defines community data access interface
type CommunityRepository interface {
	// Posts
	CreatePost(ctx context.Context, post *Post) error
	GetPostByID(ctx context.Context, postID string, userID string) (*Post, error)
	ListPosts(ctx context.Context, page, limit int, postType string, userID string) ([]Post, int, error)
	GetUserPosts(ctx context.Context, targetUserID string, viewerUserID string) ([]Post, error)
	DeletePost(ctx context.Context, postID string) error
	UpdatePost(ctx context.Context, postID, content string) error

	// Comments
	CreateComment(ctx context.Context, comment *Comment) error
	GetCommentByID(ctx context.Context, commentID string) (*Comment, error)
	GetPostComments(ctx context.Context, postID string, userID string) ([]Comment, error)
	DeleteComment(ctx context.Context, commentID string) error
	IncrementCommentCount(ctx context.Context, postID string) error
	DecrementCommentCount(ctx context.Context, postID string) error

	// Likes
	LikePost(ctx context.Context, like *Like) error
	UnlikePost(ctx context.Context, userID, postID string) error
	LikeComment(ctx context.Context, like *Like) error
	UnlikeComment(ctx context.Context, userID, commentID string) error
	IncrementPostLikes(ctx context.Context, postID string) error
	DecrementPostLikes(ctx context.Context, postID string) error
	IncrementCommentLikes(ctx context.Context, commentID string) error
	DecrementCommentLikes(ctx context.Context, commentID string) error
	IsPostLikedByUser(ctx context.Context, userID, postID string) (bool, error)
	IsCommentLikedByUser(ctx context.Context, userID, commentID string) (bool, error)
}
