package config

import (
	"os"
	"time"
)

type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
	JWT      JWTConfig
}

type ServerConfig struct {
	Port           string
	Environment    string
	AllowedOrigins []string
}

type DatabaseConfig struct {
	Host     string
	Port     string
	User     string
	Password string
	DBName   string
	SSLMode  string
}

type JWTConfig struct {
	Secret             string
	AccessTokenExpiry  time.Duration
	RefreshTokenExpiry time.Duration
}

func Load() *Config {
	return &Config{
		Server: ServerConfig{
			Port:        getEnv("PORT", "8080"),
			Environment: getEnv("ENV", "development"),
			AllowedOrigins: []string{
				getEnv("ALLOWED_ORIGINS", "http://localhost:3000"),
			},
		},
		Database: DatabaseConfig{
			Host:     getEnv("DB_HOST", "localhost"),
			Port:     getEnv("DB_PORT", "5432"),
			User:     getEnv("DB_USER", "postgres"),
			Password: getEnv("DB_PASSWORD", "postgres"),
			DBName:   getEnv("DB_NAME", "cricketapp"),
			SSLMode:  getEnv("SSL_MODE", "disable"),
		},
		JWT: JWTConfig{
			Secret:             getEnv("JWT_SECRET", "change-this-secret"),
			AccessTokenExpiry:  15 * time.Minute,
			RefreshTokenExpiry: 7 * 24 * time.Hour,
		},
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
