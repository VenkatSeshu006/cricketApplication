package middleware

import (
	"context"
	"net/http"
	"strings"

	"github.com/cricketapp/backend/config"
	"github.com/cricketapp/backend/internal/auth/util"
)

// AuthMiddleware validates JWT tokens and adds user info to context
func AuthMiddleware(cfg *config.Config) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Extract token from Authorization header
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				respondError(w, http.StatusUnauthorized, "Missing authorization header")
				return
			}

			// Check Bearer prefix
			parts := strings.Split(authHeader, " ")
			if len(parts) != 2 || parts[0] != "Bearer" {
				respondError(w, http.StatusUnauthorized, "Invalid authorization header format")
				return
			}

			token := parts[1]

			// Validate token
			jwtUtil := util.NewJWTUtil(cfg.JWT.Secret, cfg.JWT.AccessTokenExpiry)
			claims, err := jwtUtil.ValidateToken(token)
			if err != nil {
				respondError(w, http.StatusUnauthorized, "Invalid or expired token")
				return
			}

			// Add user info to context
			ctx := context.WithValue(r.Context(), "user_id", claims.UserID)
			ctx = context.WithValue(ctx, "user_email", claims.Email)
			ctx = context.WithValue(ctx, "user_role", claims.Role)

			// Call next handler
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func respondError(w http.ResponseWriter, status int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	w.Write([]byte(`{"status":"error","message":"` + message + `"}`))
}
