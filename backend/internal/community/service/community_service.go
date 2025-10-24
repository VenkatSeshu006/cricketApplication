package service

import (
	"context"
	"fmt"
	"strings"

	"github.com/cricketapp/backend/internal/community/domain"
	"github.com/google/uuid"
)

type communityService struct {
	repo domain.CommunityRepository
}

// NewCommunityService creates a new community service
func NewCommunityService(repo domain.CommunityRepository) domain.CommunityService {
	return &communityService{repo: repo}
}

func (s *communityService) CreatePost(ctx context.Context, userID string, req *domain.CreatePostRequest) (*domain.Post, error) {
	// Validation
	content := strings.TrimSpace(req.Content)
	if len(content) == 0 {
		return nil, fmt.Errorf("content cannot be empty")
	}
	if len(content) > 2000 {
		return nil, fmt.Errorf("content must be at most 2000 characters")
	}

	// Validate post type
	validTypes := map[string]bool{
		"general":     true,
		"match":       true,
		"training":    true,
		"achievement": true,
		"question":    true,
	}
	if !validTypes[req.PostType] {
		return nil, fmt.Errorf("invalid post type")
	}

	// Validate visibility
	validVisibility := map[string]bool{
		"public":  true,
		"friends": true,
		"private": true,
	}
	if !validVisibility[req.Visibility] {
		return nil, fmt.Errorf("invalid visibility setting")
	}

	post := &domain.Post{
		ID:         uuid.New().String(),
		UserID:     userID,
		Content:    content,
		MediaURLs:  req.MediaURLs,
		PostType:   req.PostType,
		Visibility: req.Visibility,
	}

	if err := s.repo.CreatePost(ctx, post); err != nil {
		return nil, err
	}

	// Fetch full post details with user info
	return s.repo.GetPostByID(ctx, post.ID, userID)
}

func (s *communityService) GetFeed(ctx context.Context, page, limit int, postType string, userID string) (*domain.FeedResponse, error) {
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 20
	}

	posts, total, err := s.repo.ListPosts(ctx, page, limit, postType, userID)
	if err != nil {
		return nil, err
	}

	totalPages := (total + limit - 1) / limit

	return &domain.FeedResponse{
		Posts: posts,
		Pagination: domain.Pagination{
			Page:       page,
			Limit:      limit,
			Total:      total,
			TotalPages: totalPages,
		},
	}, nil
}

func (s *communityService) GetPostDetails(ctx context.Context, postID string, userID string) (*domain.Post, error) {
	return s.repo.GetPostByID(ctx, postID, userID)
}

func (s *communityService) UpdatePost(ctx context.Context, userID, postID, content string) error {
	// Get existing post
	post, err := s.repo.GetPostByID(ctx, postID, "")
	if err != nil {
		return err
	}

	// Authorization check
	if post.UserID != userID {
		return fmt.Errorf("unauthorized: you can only edit your own posts")
	}

	// Validation
	content = strings.TrimSpace(content)
	if len(content) == 0 {
		return fmt.Errorf("content cannot be empty")
	}
	if len(content) > 2000 {
		return fmt.Errorf("content must be at most 2000 characters")
	}

	return s.repo.UpdatePost(ctx, postID, content)
}

func (s *communityService) DeletePost(ctx context.Context, userID, postID string) error {
	// Get existing post
	post, err := s.repo.GetPostByID(ctx, postID, "")
	if err != nil {
		return err
	}

	// Authorization check
	if post.UserID != userID {
		return fmt.Errorf("unauthorized: you can only delete your own posts")
	}

	return s.repo.DeletePost(ctx, postID)
}

func (s *communityService) GetUserPosts(ctx context.Context, targetUserID string, viewerUserID string) ([]domain.Post, error) {
	return s.repo.GetUserPosts(ctx, targetUserID, viewerUserID)
}

func (s *communityService) AddComment(ctx context.Context, userID, postID string, req *domain.CreateCommentRequest) (*domain.Comment, error) {
	// Validation
	content := strings.TrimSpace(req.Content)
	if len(content) == 0 {
		return nil, fmt.Errorf("comment content cannot be empty")
	}
	if len(content) > 1000 {
		return nil, fmt.Errorf("comment must be at most 1000 characters")
	}

	// Verify post exists
	_, err := s.repo.GetPostByID(ctx, postID, "")
	if err != nil {
		return nil, fmt.Errorf("post not found")
	}

	comment := &domain.Comment{
		ID:      uuid.New().String(),
		PostID:  postID,
		UserID:  userID,
		Content: content,
	}

	if err := s.repo.CreateComment(ctx, comment); err != nil {
		return nil, err
	}

	// Increment post comment count
	_ = s.repo.IncrementCommentCount(ctx, postID)

	// Fetch full comment with user info
	comments, err := s.repo.GetPostComments(ctx, postID, userID)
	if err != nil {
		return nil, err
	}

	// Find and return the newly created comment
	for _, c := range comments {
		if c.ID == comment.ID {
			return &c, nil
		}
	}

	return comment, nil
}

func (s *communityService) GetPostComments(ctx context.Context, postID string, userID string) ([]domain.Comment, error) {
	return s.repo.GetPostComments(ctx, postID, userID)
}

func (s *communityService) DeleteComment(ctx context.Context, userID, commentID string) error {
	// Get the comment to verify ownership and get postID
	comment, err := s.repo.GetCommentByID(ctx, commentID)
	if err != nil {
		return err
	}

	// Authorization check
	if comment.UserID != userID {
		return fmt.Errorf("unauthorized: you can only delete your own comments")
	}

	if err := s.repo.DeleteComment(ctx, commentID); err != nil {
		return err
	}

	// Decrement post comment count
	_ = s.repo.DecrementCommentCount(ctx, comment.PostID)

	return nil
}

func (s *communityService) LikePost(ctx context.Context, userID, postID string) error {
	// Check if already liked
	isLiked, err := s.repo.IsPostLikedByUser(ctx, userID, postID)
	if err != nil {
		return err
	}
	if isLiked {
		return fmt.Errorf("you have already liked this post")
	}

	like := &domain.Like{
		ID:     uuid.New().String(),
		UserID: userID,
		PostID: postID,
	}

	if err := s.repo.LikePost(ctx, like); err != nil {
		return err
	}

	// Increment likes count
	_ = s.repo.IncrementPostLikes(ctx, postID)

	return nil
}

func (s *communityService) UnlikePost(ctx context.Context, userID, postID string) error {
	// Check if actually liked
	isLiked, err := s.repo.IsPostLikedByUser(ctx, userID, postID)
	if err != nil {
		return err
	}
	if !isLiked {
		return fmt.Errorf("you have not liked this post")
	}

	if err := s.repo.UnlikePost(ctx, userID, postID); err != nil {
		return err
	}

	// Decrement likes count
	_ = s.repo.DecrementPostLikes(ctx, postID)

	return nil
}

func (s *communityService) LikeComment(ctx context.Context, userID, commentID string) error {
	// Check if already liked
	isLiked, err := s.repo.IsCommentLikedByUser(ctx, userID, commentID)
	if err != nil {
		return err
	}
	if isLiked {
		return fmt.Errorf("you have already liked this comment")
	}

	like := &domain.Like{
		ID:        uuid.New().String(),
		UserID:    userID,
		CommentID: commentID,
	}

	if err := s.repo.LikeComment(ctx, like); err != nil {
		return err
	}

	// Increment likes count
	_ = s.repo.IncrementCommentLikes(ctx, commentID)

	return nil
}

func (s *communityService) UnlikeComment(ctx context.Context, userID, commentID string) error {
	// Check if actually liked
	isLiked, err := s.repo.IsCommentLikedByUser(ctx, userID, commentID)
	if err != nil {
		return err
	}
	if !isLiked {
		return fmt.Errorf("you have not liked this comment")
	}

	if err := s.repo.UnlikeComment(ctx, userID, commentID); err != nil {
		return err
	}

	// Decrement likes count
	_ = s.repo.DecrementCommentLikes(ctx, commentID)

	return nil
}
