package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/cricketapp/backend/internal/community/domain"
	"github.com/lib/pq"
)

type communityRepository struct {
	db *sql.DB
}

// NewCommunityRepository creates a new community repository
func NewCommunityRepository(db *sql.DB) domain.CommunityRepository {
	return &communityRepository{db: db}
}

func (r *communityRepository) CreatePost(ctx context.Context, post *domain.Post) error {
	query := `
		INSERT INTO posts (
			id, user_id, content, media_urls, post_type, visibility
		) VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING created_at, updated_at
	`

	err := r.db.QueryRowContext(
		ctx, query,
		post.ID, post.UserID, post.Content, pq.Array(post.MediaURLs),
		post.PostType, post.Visibility,
	).Scan(&post.CreatedAt, &post.UpdatedAt)

	if err != nil {
		return fmt.Errorf("failed to create post: %w", err)
	}

	return nil
}

func (r *communityRepository) GetPostByID(ctx context.Context, postID string, userID string) (*domain.Post, error) {
	query := `
		SELECT 
			p.id, p.user_id, u.full_name, u.profile_picture_url, p.content, p.media_urls,
			p.post_type, p.visibility, p.likes_count, p.comments_count, p.shares_count,
			p.created_at, p.updated_at
		FROM posts p
		JOIN users u ON p.user_id = u.id
		WHERE p.id = $1
	`

	var post domain.Post
	var userPhoto sql.NullString

	err := r.db.QueryRowContext(ctx, query, postID).Scan(
		&post.ID, &post.UserID, &post.UserName, &userPhoto, &post.Content, pq.Array(&post.MediaURLs),
		&post.PostType, &post.Visibility, &post.LikesCount, &post.CommentsCount, &post.SharesCount,
		&post.CreatedAt, &post.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("post not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get post: %w", err)
	}

	if userPhoto.Valid {
		post.UserPhoto = userPhoto.String
	}

	// Check if user liked this post
	if userID != "" {
		post.IsLikedByUser, _ = r.IsPostLikedByUser(ctx, userID, postID)
	}

	return &post, nil
}

func (r *communityRepository) ListPosts(ctx context.Context, page, limit int, postType string, userID string) ([]domain.Post, int, error) {
	offset := (page - 1) * limit

	// Count query
	countQuery := `SELECT COUNT(*) FROM posts WHERE visibility = 'public'`
	args := []interface{}{}
	argCount := 1

	if postType != "" {
		countQuery += fmt.Sprintf(" AND post_type = $%d", argCount)
		args = append(args, postType)
		argCount++
	}

	var total int
	err := r.db.QueryRowContext(ctx, countQuery, args...).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count posts: %w", err)
	}

	// List query
	listQuery := `
		SELECT 
			p.id, p.user_id, u.full_name, u.profile_picture_url, p.content, p.media_urls,
			p.post_type, p.visibility, p.likes_count, p.comments_count, p.shares_count,
			p.created_at, p.updated_at
		FROM posts p
		JOIN users u ON p.user_id = u.id
		WHERE p.visibility = 'public'
	`

	args = []interface{}{}
	argCount = 1

	if postType != "" {
		listQuery += fmt.Sprintf(" AND p.post_type = $%d", argCount)
		args = append(args, postType)
		argCount++
	}

	listQuery += fmt.Sprintf(" ORDER BY p.created_at DESC LIMIT $%d OFFSET $%d", argCount, argCount+1)
	args = append(args, limit, offset)

	rows, err := r.db.QueryContext(ctx, listQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to list posts: %w", err)
	}
	defer rows.Close()

	var posts []domain.Post
	for rows.Next() {
		var post domain.Post
		var userPhoto sql.NullString

		err := rows.Scan(
			&post.ID, &post.UserID, &post.UserName, &userPhoto, &post.Content, pq.Array(&post.MediaURLs),
			&post.PostType, &post.Visibility, &post.LikesCount, &post.CommentsCount, &post.SharesCount,
			&post.CreatedAt, &post.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan post: %w", err)
		}

		if userPhoto.Valid {
			post.UserPhoto = userPhoto.String
		}

		// Check if user liked this post
		if userID != "" {
			post.IsLikedByUser, _ = r.IsPostLikedByUser(ctx, userID, post.ID)
		}

		posts = append(posts, post)
	}

	return posts, total, nil
}

func (r *communityRepository) GetUserPosts(ctx context.Context, targetUserID string, viewerUserID string) ([]domain.Post, error) {
	query := `
		SELECT 
			p.id, p.user_id, u.full_name, u.profile_picture_url, p.content, p.media_urls,
			p.post_type, p.visibility, p.likes_count, p.comments_count, p.shares_count,
			p.created_at, p.updated_at
		FROM posts p
		JOIN users u ON p.user_id = u.id
		WHERE p.user_id = $1 AND p.visibility = 'public'
		ORDER BY p.created_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, targetUserID)
	if err != nil {
		return nil, fmt.Errorf("failed to get user posts: %w", err)
	}
	defer rows.Close()

	var posts []domain.Post
	for rows.Next() {
		var post domain.Post
		var userPhoto sql.NullString

		err := rows.Scan(
			&post.ID, &post.UserID, &post.UserName, &userPhoto, &post.Content, pq.Array(&post.MediaURLs),
			&post.PostType, &post.Visibility, &post.LikesCount, &post.CommentsCount, &post.SharesCount,
			&post.CreatedAt, &post.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan post: %w", err)
		}

		if userPhoto.Valid {
			post.UserPhoto = userPhoto.String
		}

		if viewerUserID != "" {
			post.IsLikedByUser, _ = r.IsPostLikedByUser(ctx, viewerUserID, post.ID)
		}

		posts = append(posts, post)
	}

	return posts, nil
}

func (r *communityRepository) DeletePost(ctx context.Context, postID string) error {
	query := `DELETE FROM posts WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, postID)
	if err != nil {
		return fmt.Errorf("failed to delete post: %w", err)
	}
	return nil
}

func (r *communityRepository) UpdatePost(ctx context.Context, postID, content string) error {
	query := `UPDATE posts SET content = $1, updated_at = $2 WHERE id = $3`
	_, err := r.db.ExecContext(ctx, query, content, time.Now(), postID)
	if err != nil {
		return fmt.Errorf("failed to update post: %w", err)
	}
	return nil
}

func (r *communityRepository) CreateComment(ctx context.Context, comment *domain.Comment) error {
	query := `
		INSERT INTO comments (id, post_id, user_id, content)
		VALUES ($1, $2, $3, $4)
		RETURNING created_at, updated_at
	`

	err := r.db.QueryRowContext(
		ctx, query,
		comment.ID, comment.PostID, comment.UserID, comment.Content,
	).Scan(&comment.CreatedAt, &comment.UpdatedAt)

	if err != nil {
		return fmt.Errorf("failed to create comment: %w", err)
	}

	return nil
}

func (r *communityRepository) GetPostComments(ctx context.Context, postID string, userID string) ([]domain.Comment, error) {
	query := `
		SELECT 
			c.id, c.post_id, c.user_id, u.full_name, u.profile_picture_url,
			c.content, c.likes_count, c.created_at, c.updated_at
		FROM comments c
		JOIN users u ON c.user_id = u.id
		WHERE c.post_id = $1
		ORDER BY c.created_at ASC
	`

	rows, err := r.db.QueryContext(ctx, query, postID)
	if err != nil {
		return nil, fmt.Errorf("failed to get comments: %w", err)
	}
	defer rows.Close()

	var comments []domain.Comment
	for rows.Next() {
		var comment domain.Comment
		var userPhoto sql.NullString

		err := rows.Scan(
			&comment.ID, &comment.PostID, &comment.UserID, &comment.UserName, &userPhoto,
			&comment.Content, &comment.LikesCount, &comment.CreatedAt, &comment.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan comment: %w", err)
		}

		if userPhoto.Valid {
			comment.UserPhoto = userPhoto.String
		}

		if userID != "" {
			comment.IsLikedByUser, _ = r.IsCommentLikedByUser(ctx, userID, comment.ID)
		}

		comments = append(comments, comment)
	}

	return comments, nil
}

func (r *communityRepository) DeleteComment(ctx context.Context, commentID string) error {
	query := `DELETE FROM comments WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, commentID)
	if err != nil {
		return fmt.Errorf("failed to delete comment: %w", err)
	}
	return nil
}

func (r *communityRepository) GetCommentByID(ctx context.Context, commentID string) (*domain.Comment, error) {
	query := `
		SELECT 
			c.id, c.post_id, c.user_id, u.full_name, u.profile_picture_url,
			c.content, c.likes_count, c.created_at, c.updated_at
		FROM comments c
		JOIN users u ON c.user_id = u.id
		WHERE c.id = $1
	`

	var comment domain.Comment
	var userPhoto sql.NullString

	err := r.db.QueryRowContext(ctx, query, commentID).Scan(
		&comment.ID, &comment.PostID, &comment.UserID, &comment.UserName, &userPhoto,
		&comment.Content, &comment.LikesCount, &comment.CreatedAt, &comment.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("comment not found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get comment: %w", err)
	}

	if userPhoto.Valid {
		comment.UserPhoto = userPhoto.String
	}

	return &comment, nil
}

func (r *communityRepository) IncrementCommentCount(ctx context.Context, postID string) error {
	query := `UPDATE posts SET comments_count = comments_count + 1 WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, postID)
	return err
}

func (r *communityRepository) DecrementCommentCount(ctx context.Context, postID string) error {
	query := `UPDATE posts SET comments_count = comments_count - 1 WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, postID)
	return err
}

func (r *communityRepository) LikePost(ctx context.Context, like *domain.Like) error {
	query := `INSERT INTO likes (id, user_id, post_id) VALUES ($1, $2, $3) RETURNING created_at`
	err := r.db.QueryRowContext(ctx, query, like.ID, like.UserID, like.PostID).Scan(&like.CreatedAt)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			if pqErr.Code == "23505" { // unique_violation
				return fmt.Errorf("already liked this post")
			}
		}
		return fmt.Errorf("failed to like post: %w", err)
	}
	return nil
}

func (r *communityRepository) UnlikePost(ctx context.Context, userID, postID string) error {
	query := `DELETE FROM likes WHERE user_id = $1 AND post_id = $2`
	result, err := r.db.ExecContext(ctx, query, userID, postID)
	if err != nil {
		return fmt.Errorf("failed to unlike post: %w", err)
	}

	rows, _ := result.RowsAffected()
	if rows == 0 {
		return fmt.Errorf("like not found")
	}

	return nil
}

func (r *communityRepository) LikeComment(ctx context.Context, like *domain.Like) error {
	query := `INSERT INTO likes (id, user_id, comment_id) VALUES ($1, $2, $3) RETURNING created_at`
	err := r.db.QueryRowContext(ctx, query, like.ID, like.UserID, like.CommentID).Scan(&like.CreatedAt)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			if pqErr.Code == "23505" { // unique_violation
				return fmt.Errorf("already liked this comment")
			}
		}
		return fmt.Errorf("failed to like comment: %w", err)
	}
	return nil
}

func (r *communityRepository) UnlikeComment(ctx context.Context, userID, commentID string) error {
	query := `DELETE FROM likes WHERE user_id = $1 AND comment_id = $2`
	result, err := r.db.ExecContext(ctx, query, userID, commentID)
	if err != nil {
		return fmt.Errorf("failed to unlike comment: %w", err)
	}

	rows, _ := result.RowsAffected()
	if rows == 0 {
		return fmt.Errorf("like not found")
	}

	return nil
}

func (r *communityRepository) IncrementPostLikes(ctx context.Context, postID string) error {
	query := `UPDATE posts SET likes_count = likes_count + 1 WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, postID)
	return err
}

func (r *communityRepository) DecrementPostLikes(ctx context.Context, postID string) error {
	query := `UPDATE posts SET likes_count = likes_count - 1 WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, postID)
	return err
}

func (r *communityRepository) IncrementCommentLikes(ctx context.Context, commentID string) error {
	query := `UPDATE comments SET likes_count = likes_count + 1 WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, commentID)
	return err
}

func (r *communityRepository) DecrementCommentLikes(ctx context.Context, commentID string) error {
	query := `UPDATE comments SET likes_count = likes_count - 1 WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, commentID)
	return err
}

func (r *communityRepository) IsPostLikedByUser(ctx context.Context, userID, postID string) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM likes WHERE user_id = $1 AND post_id = $2)`
	var exists bool
	err := r.db.QueryRowContext(ctx, query, userID, postID).Scan(&exists)
	return exists, err
}

func (r *communityRepository) IsCommentLikedByUser(ctx context.Context, userID, commentID string) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM likes WHERE user_id = $1 AND comment_id = $2)`
	var exists bool
	err := r.db.QueryRowContext(ctx, query, userID, commentID).Scan(&exists)
	return exists, err
}
