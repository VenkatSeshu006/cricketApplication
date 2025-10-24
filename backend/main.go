package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/cricketapp/backend/config"
	"github.com/cricketapp/backend/internal/database"
	"github.com/cricketapp/backend/internal/http/server"
)

func main() {
	// Load configuration
	cfg := config.Load()

	// Connect to database
	db, err := database.Connect(cfg.Database)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	log.Println("✅ Database connected successfully")

	// Create HTTP server
	srv := server.New(cfg, db)

	// Start server
	addr := fmt.Sprintf(":%s", cfg.Server.Port)
	log.Printf("🚀 Server starting on http://localhost%s", addr)
	log.Printf("📝 Environment: %s", cfg.Server.Environment)

	if err := http.ListenAndServe(addr, srv.Router()); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
