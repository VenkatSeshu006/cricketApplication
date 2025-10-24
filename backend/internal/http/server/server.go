package server

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/cricketapp/backend/config"
	authhttp "github.com/cricketapp/backend/internal/auth/delivery/http"
	communityhttp "github.com/cricketapp/backend/internal/community/delivery/http"
	communityrepo "github.com/cricketapp/backend/internal/community/repository/postgres"
	communityservice "github.com/cricketapp/backend/internal/community/service"
	groundhttp "github.com/cricketapp/backend/internal/ground/delivery/http"
	hiringhttp "github.com/cricketapp/backend/internal/hiring/delivery/http"
	hiringrepo "github.com/cricketapp/backend/internal/hiring/repository/postgres"
	hiringservice "github.com/cricketapp/backend/internal/hiring/service"
	"github.com/cricketapp/backend/internal/http/middleware"
	matchhttp "github.com/cricketapp/backend/internal/match/delivery/http"
	matchrepo "github.com/cricketapp/backend/internal/match/repository/postgres"
	matchservice "github.com/cricketapp/backend/internal/match/service"
	medicalhttp "github.com/cricketapp/backend/internal/medical/delivery/http"
	medicalrepo "github.com/cricketapp/backend/internal/medical/repository/postgres"
	medicalservice "github.com/cricketapp/backend/internal/medical/service"
	statisticshttp "github.com/cricketapp/backend/internal/statistics/delivery/http"
	statisticsrepo "github.com/cricketapp/backend/internal/statistics/repository/postgres"
	statisticsservice "github.com/cricketapp/backend/internal/statistics/service"
	tournamenthttp "github.com/cricketapp/backend/internal/tournament/delivery/http"
	tournamentrepo "github.com/cricketapp/backend/internal/tournament/repository/postgres"
	tournamentservice "github.com/cricketapp/backend/internal/tournament/service"
	userhttp "github.com/cricketapp/backend/internal/user/delivery/http"
	"github.com/go-chi/chi/v5"
	chimiddleware "github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

type Server struct {
	config            *config.Config
	db                *sql.DB
	authHandler       *authhttp.AuthHandler
	userHandler       *userhttp.UserHandler
	groundHandler     *groundhttp.GroundHandler
	medicalHandler    *medicalhttp.MedicalHandler
	hiringHandler     *hiringhttp.HiringHandler
	communityHandler  *communityhttp.CommunityHandler
	matchHandler      *matchhttp.MatchHandler
	tournamentHandler *tournamenthttp.TournamentHandler
	statisticsHandler *statisticshttp.StatisticsHandler
}

func New(cfg *config.Config, db *sql.DB) *Server {
	// Initialize medical service layers
	medicalRepo := medicalrepo.NewMedicalRepository(db)
	medicalSvc := medicalservice.NewMedicalService(medicalRepo)

	// Initialize hiring service layers
	hiringRepo := hiringrepo.NewHiringRepository(db)
	hiringSvc := hiringservice.NewHiringService(hiringRepo)

	// Initialize community service layers
	communityRepo := communityrepo.NewCommunityRepository(db)
	communitySvc := communityservice.NewCommunityService(communityRepo)

	// Initialize match service layers
	matchRepo := matchrepo.NewMatchRepository(db)
	matchSvc := matchservice.NewMatchService(matchRepo)

	// Initialize tournament service layers
	tournamentRepo := tournamentrepo.NewTournamentRepository(db)
	tournamentSvc := tournamentservice.NewTournamentService(tournamentRepo)

	// Initialize statistics service layers
	statisticsRepo := statisticsrepo.NewStatisticsRepository(db)
	statisticsSvc := statisticsservice.NewStatisticsService(statisticsRepo)

	return &Server{
		config:            cfg,
		db:                db,
		authHandler:       authhttp.NewAuthHandler(db, cfg),
		userHandler:       userhttp.NewUserHandler(db),
		groundHandler:     groundhttp.NewGroundHandler(db),
		medicalHandler:    medicalhttp.NewMedicalHandler(medicalSvc),
		hiringHandler:     hiringhttp.NewHiringHandler(hiringSvc),
		communityHandler:  communityhttp.NewCommunityHandler(communitySvc),
		matchHandler:      matchhttp.NewMatchHandler(matchSvc),
		tournamentHandler: tournamenthttp.NewTournamentHandler(tournamentSvc),
		statisticsHandler: statisticshttp.NewStatisticsHandler(statisticsSvc),
	}
}

func (s *Server) Router() http.Handler {
	r := chi.NewRouter()

	// Middleware
	r.Use(chimiddleware.Logger)
	r.Use(chimiddleware.Recoverer)
	r.Use(chimiddleware.RequestID)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   s.config.Server.AllowedOrigins,
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Health check
	r.Get("/health", s.handleHealth)

	// API routes
	r.Route("/api/v1", func(r chi.Router) {
		// Public auth routes
		r.Post("/auth/register", s.authHandler.Register)
		r.Post("/auth/login", s.authHandler.Login)

		// Public ground routes (no auth required for browsing)
		r.Get("/grounds", s.groundHandler.ListGrounds)
		r.Get("/grounds/{id}", s.groundHandler.GetGroundDetails)

		// Public medical routes (browse physiotherapists)
		r.Get("/physiotherapists", s.medicalHandler.ListPhysiotherapists)
		r.Get("/physiotherapists/{id}", s.medicalHandler.GetPhysiotherapistDetails)

		// Public job listing routes (browse jobs)
		r.Get("/jobs", s.hiringHandler.ListJobs)
		r.Get("/jobs/{id}", s.hiringHandler.GetJobDetails)

		// Public community feed routes (browse posts)
		r.Get("/posts", s.communityHandler.GetFeed)
		r.Get("/posts/{id}", s.communityHandler.GetPostDetails)
		r.Get("/posts/{id}/comments", s.communityHandler.GetPostComments)

		// Public match routes (browse matches and teams)
		r.Get("/teams", s.matchHandler.ListTeams)
		r.Get("/teams/{id}", s.matchHandler.GetTeam)
		r.Get("/teams/{id}/stats", s.matchHandler.GetTeamStats)
		r.Get("/teams/{id}/players", s.matchHandler.ListTeamPlayers)
		r.Get("/matches", s.matchHandler.ListMatches)
		r.Get("/matches/{id}", s.matchHandler.GetMatch)
		r.Get("/matches/{id}/squad", s.matchHandler.GetMatchSquad)
		r.Get("/players/{id}", s.matchHandler.GetPlayer)

		// Public tournament routes (browse tournaments)
		r.Get("/tournaments", s.tournamentHandler.ListTournaments)
		r.Get("/tournaments/{id}", s.tournamentHandler.GetTournament)
		r.Get("/tournaments/{id}/registrations", s.tournamentHandler.ListRegistrations)
		r.Get("/tournaments/{id}/standings", s.tournamentHandler.GetStandings)
		r.Get("/tournaments/{id}/matches", s.tournamentHandler.GetTournamentMatches)

		// Public statistics routes (browse stats and leaderboards)
		r.Get("/performances", s.statisticsHandler.ListPerformances)
		r.Get("/performances/{id}", s.statisticsHandler.GetPerformance)
		r.Get("/players/{id}/stats", s.statisticsHandler.GetPlayerStats)
		r.Get("/leaderboards/batting", s.statisticsHandler.GetBattingLeaderboard)
		r.Get("/leaderboards/bowling", s.statisticsHandler.GetBowlingLeaderboard)
		r.Get("/leaderboards/most-runs", s.statisticsHandler.GetMostRunsLeaderboard)
		r.Get("/leaderboards/most-wickets", s.statisticsHandler.GetMostWicketsLeaderboard)

		// Protected routes (require authentication)
		r.Group(func(r chi.Router) {
			r.Use(middleware.AuthMiddleware(s.config))

			// User profile endpoints
			r.Get("/users/profile", s.userHandler.GetProfile)
			r.Put("/users/profile", s.userHandler.UpdateProfile)
			r.Get("/users/{id}", s.userHandler.GetUserByID)

			// Booking endpoints
			r.Post("/bookings", s.groundHandler.CreateBooking)
			r.Get("/bookings/my", s.groundHandler.GetUserBookings)

			// Medical/Appointment endpoints
			r.Post("/appointments", s.medicalHandler.CreateAppointment)
			r.Get("/appointments/my", s.medicalHandler.GetMyAppointments)

			// Job posting endpoints
			r.Post("/jobs", s.hiringHandler.CreateJob)
			r.Get("/jobs/my", s.hiringHandler.GetMyJobs)
			r.Put("/jobs/{id}/close", s.hiringHandler.CloseJob)
			r.Post("/jobs/{id}/apply", s.hiringHandler.ApplyForJob)
			r.Get("/jobs/{id}/applications", s.hiringHandler.GetJobApplications)

			// Application endpoints
			r.Get("/applications/my", s.hiringHandler.GetMyApplications)
			r.Put("/applications/{id}/status", s.hiringHandler.UpdateApplicationStatus)

			// Community post endpoints
			r.Post("/posts", s.communityHandler.CreatePost)
			r.Put("/posts/{id}", s.communityHandler.UpdatePost)
			r.Delete("/posts/{id}", s.communityHandler.DeletePost)
			r.Get("/users/{userId}/posts", s.communityHandler.GetUserPosts)

			// Community comment endpoints
			r.Post("/posts/{id}/comments", s.communityHandler.AddComment)
			r.Delete("/comments/{commentId}", s.communityHandler.DeleteComment)

			// Community like endpoints
			r.Post("/posts/{id}/like", s.communityHandler.LikePost)
			r.Delete("/posts/{id}/like", s.communityHandler.UnlikePost)
			r.Post("/comments/{commentId}/like", s.communityHandler.LikeComment)
			r.Delete("/comments/{commentId}/like", s.communityHandler.UnlikeComment)

			// Team management endpoints
			r.Post("/teams", s.matchHandler.CreateTeam)
			r.Put("/teams/{id}", s.matchHandler.UpdateTeam)
			r.Delete("/teams/{id}", s.matchHandler.DeleteTeam)

			// Player management endpoints
			r.Post("/players", s.matchHandler.AddPlayer)
			r.Delete("/players/{id}", s.matchHandler.RemovePlayer)

			// Match management endpoints
			r.Post("/matches", s.matchHandler.CreateMatch)
			r.Put("/matches/{id}", s.matchHandler.UpdateMatch)
			r.Put("/matches/{id}/status", s.matchHandler.UpdateMatchStatus)
			r.Delete("/matches/{id}", s.matchHandler.DeleteMatch)

			// Match squad management endpoints
			r.Post("/matches/{id}/squad", s.matchHandler.AddPlayerToSquad)
			r.Delete("/matches/{matchId}/squad/{playerId}", s.matchHandler.RemovePlayerFromSquad)

			// Tournament management endpoints
			r.Post("/tournaments", s.tournamentHandler.CreateTournament)
			r.Put("/tournaments/{id}", s.tournamentHandler.UpdateTournament)
			r.Delete("/tournaments/{id}", s.tournamentHandler.DeleteTournament)
			r.Post("/tournaments/{id}/open-registration", s.tournamentHandler.OpenRegistration)
			r.Post("/tournaments/{id}/close-registration", s.tournamentHandler.CloseRegistration)
			r.Post("/tournaments/{id}/start", s.tournamentHandler.StartTournament)
			r.Post("/tournaments/{id}/complete", s.tournamentHandler.CompleteTournament)
			r.Post("/tournaments/{id}/cancel", s.tournamentHandler.CancelTournament)

			// Tournament registration endpoints
			r.Post("/tournaments/{id}/register", s.tournamentHandler.RegisterTeam)
			r.Post("/registrations/{registrationId}/approve", s.tournamentHandler.ApproveRegistration)
			r.Post("/registrations/{registrationId}/reject", s.tournamentHandler.RejectRegistration)
			r.Delete("/tournaments/{id}/teams/{teamId}/withdraw", s.tournamentHandler.WithdrawRegistration)

			// Statistics management endpoints
			r.Post("/performances", s.statisticsHandler.RecordPerformance)
			r.Put("/performances/{id}", s.statisticsHandler.UpdatePerformance)
			r.Delete("/performances/{id}", s.statisticsHandler.DeletePerformance)
			r.Post("/players/{id}/refresh-stats", s.statisticsHandler.RefreshPlayerStats)
			r.Post("/leaderboards/refresh", s.statisticsHandler.RefreshLeaderboards)
		})
	})

	return r
}

func (s *Server) handleHealth(w http.ResponseWriter, r *http.Request) {
	response := map[string]interface{}{
		"status":  "success",
		"message": "CricketApp API is running",
		"version": "1.0.0",
	}
	s.respondJSON(w, http.StatusOK, response)
}

func (s *Server) handleNotImplemented(w http.ResponseWriter, r *http.Request) {
	response := map[string]interface{}{
		"status":  "error",
		"message": "Endpoint not implemented yet",
	}
	s.respondJSON(w, http.StatusNotImplemented, response)
}

func (s *Server) respondJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(data)
}
