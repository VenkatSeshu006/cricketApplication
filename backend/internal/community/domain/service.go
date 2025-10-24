package domain

import "context"

// CommunityService defines community business logic interface
type CommunityService interface {
	// Posts
	CreatePost(ctx context.Context, userID string, req *CreatePostRequest) (*Post, error)
	GetPostDetails(ctx context.Context, postID string, userID string) (*Post, error)
	GetFeed(ctx context.Context, page, limit int, postType string, userID string) (*FeedResponse, error)
	GetUserPosts(ctx context.Context, targetUserID string, viewerUserID string) ([]Post, error)
	DeletePost(ctx context.Context, userID, postID string) error
	UpdatePost(ctx context.Context, userID, postID, content string) error

	// Comments
	AddComment(ctx context.Context, userID, postID string, req *CreateCommentRequest) (*Comment, error)
	GetPostComments(ctx context.Context, postID string, userID string) ([]Comment, error)
	DeleteComment(ctx context.Context, userID, commentID string) error

	// Likes
	LikePost(ctx context.Context, userID, postID string) error
	UnlikePost(ctx context.Context, userID, postID string) error
	LikeComment(ctx context.Context, userID, commentID string) error
	UnlikeComment(ctx context.Context, userID, commentID string) error
}
