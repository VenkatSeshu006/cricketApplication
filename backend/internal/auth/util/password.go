package util

import (
	"fmt"

	"golang.org/x/crypto/bcrypt"
)

// HashPassword generates a bcrypt hash of the password
// Using cost 8 for better performance (instead of default 10)
// Still secure but faster for mobile/cloud deployments
func HashPassword(password string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), 8)
	if err != nil {
		return "", fmt.Errorf("failed to hash password: %w", err)
	}
	return string(hash), nil
}

// CheckPassword compares a password with a hash
func CheckPassword(password, hash string) error {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
}
