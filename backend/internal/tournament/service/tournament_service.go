package service

import (
	"context"
	"fmt"
	"time"

	"github.com/cricketapp/backend/internal/tournament/domain"
	"github.com/google/uuid"
)

type tournamentService struct {
	repo domain.TournamentRepository
}

func NewTournamentService(repo domain.TournamentRepository) domain.TournamentService {
	return &tournamentService{repo: repo}
}

// Tournament operations

func (s *tournamentService) CreateTournament(ctx context.Context, req domain.CreateTournamentRequest, organizerID uuid.UUID) (*domain.Tournament, error) {
	// Validate dates
	if req.EndDate.Before(req.StartDate) {
		return nil, fmt.Errorf("end date must be after start date")
	}
	if req.RegistrationDeadline.After(req.StartDate) {
		return nil, fmt.Errorf("registration deadline must be before start date")
	}
	if req.MinTeams > req.MaxTeams {
		return nil, fmt.Errorf("min teams cannot be greater than max teams")
	}
	if req.MinTeams < 2 {
		return nil, fmt.Errorf("minimum teams must be at least 2")
	}

	// Validate tournament type
	validTypes := map[string]bool{"knockout": true, "round_robin": true, "league": true, "mixed": true}
	if !validTypes[req.TournamentType] {
		return nil, fmt.Errorf("invalid tournament type: %s", req.TournamentType)
	}

	// Validate match format
	validFormats := map[string]bool{"T10": true, "T20": true, "ODI": true, "Test": true}
	if !validFormats[req.MatchFormat] {
		return nil, fmt.Errorf("invalid match format: %s", req.MatchFormat)
	}

	tournament := &domain.Tournament{
		ID:                   uuid.New(),
		Name:                 req.Name,
		ShortName:            req.ShortName,
		Description:          req.Description,
		TournamentType:       req.TournamentType,
		MatchFormat:          req.MatchFormat,
		StartDate:            req.StartDate,
		EndDate:              req.EndDate,
		RegistrationDeadline: req.RegistrationDeadline,
		MaxTeams:             req.MaxTeams,
		MinTeams:             req.MinTeams,
		EntryFee:             req.EntryFee,
		PrizePool:            req.PrizePool,
		Rules:                req.Rules,
		Status:               "upcoming",
		VenueName:            req.VenueName,
		VenueCity:            req.VenueCity,
		GroundID:             req.GroundID,
		OrganizerID:          organizerID,
		LogoURL:              req.LogoURL,
		BannerURL:            req.BannerURL,
		CreatedAt:            time.Now(),
		UpdatedAt:            time.Now(),
	}

	if tournament.Rules == nil {
		tournament.Rules = make(map[string]interface{})
	}

	if err := s.repo.CreateTournament(ctx, tournament); err != nil {
		return nil, err
	}

	return tournament, nil
}

func (s *tournamentService) GetTournament(ctx context.Context, tournamentID uuid.UUID) (*domain.Tournament, error) {
	return s.repo.GetTournamentByID(ctx, tournamentID)
}

func (s *tournamentService) ListTournaments(ctx context.Context, filters domain.TournamentFilters) (*domain.TournamentListResponse, error) {
	if filters.Page <= 0 {
		filters.Page = 1
	}
	if filters.Limit <= 0 {
		filters.Limit = 20
	}

	tournaments, total, err := s.repo.ListTournaments(ctx, filters)
	if err != nil {
		return nil, err
	}

	return &domain.TournamentListResponse{
		Tournaments: tournaments,
		Total:       total,
	}, nil
}

func (s *tournamentService) UpdateTournament(ctx context.Context, tournamentID uuid.UUID, req domain.UpdateTournamentRequest, userID uuid.UUID) (*domain.Tournament, error) {
	// Get existing tournament
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return nil, err
	}

	// Check authorization
	if tournament.OrganizerID != userID {
		return nil, fmt.Errorf("unauthorized: only the organizer can update this tournament")
	}

	// Update fields if provided
	if req.Name != nil {
		tournament.Name = *req.Name
	}
	if req.ShortName != nil {
		tournament.ShortName = req.ShortName
	}
	if req.Description != nil {
		tournament.Description = req.Description
	}
	if req.StartDate != nil {
		tournament.StartDate = *req.StartDate
	}
	if req.EndDate != nil {
		tournament.EndDate = *req.EndDate
	}
	if req.RegistrationDeadline != nil {
		tournament.RegistrationDeadline = *req.RegistrationDeadline
	}
	if req.MaxTeams != nil {
		tournament.MaxTeams = *req.MaxTeams
	}
	if req.EntryFee != nil {
		tournament.EntryFee = *req.EntryFee
	}
	if req.PrizePool != nil {
		tournament.PrizePool = *req.PrizePool
	}
	if req.Rules != nil {
		tournament.Rules = req.Rules
	}
	if req.VenueName != nil {
		tournament.VenueName = req.VenueName
	}
	if req.VenueCity != nil {
		tournament.VenueCity = req.VenueCity
	}
	if req.LogoURL != nil {
		tournament.LogoURL = req.LogoURL
	}
	if req.BannerURL != nil {
		tournament.BannerURL = req.BannerURL
	}

	tournament.UpdatedAt = time.Now()

	if err := s.repo.UpdateTournament(ctx, tournamentID, tournament); err != nil {
		return nil, err
	}

	return tournament, nil
}

func (s *tournamentService) DeleteTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error {
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return err
	}

	if tournament.OrganizerID != userID {
		return fmt.Errorf("unauthorized: only the organizer can delete this tournament")
	}

	return s.repo.DeleteTournament(ctx, tournamentID)
}

// Tournament status management

func (s *tournamentService) OpenRegistration(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error {
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return err
	}

	if tournament.OrganizerID != userID {
		return fmt.Errorf("unauthorized: only the organizer can open registration")
	}

	if tournament.Status != "upcoming" {
		return fmt.Errorf("can only open registration for upcoming tournaments")
	}

	return s.repo.UpdateTournamentStatus(ctx, tournamentID, "registration_open")
}

func (s *tournamentService) CloseRegistration(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error {
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return err
	}

	if tournament.OrganizerID != userID {
		return fmt.Errorf("unauthorized: only the organizer can close registration")
	}

	if tournament.Status != "registration_open" {
		return fmt.Errorf("can only close registration for tournaments with open registration")
	}

	// Check if minimum teams registered
	approvedCount, err := s.repo.GetRegistrationCount(ctx, tournamentID, strPtr("approved"))
	if err != nil {
		return err
	}

	if approvedCount < tournament.MinTeams {
		return fmt.Errorf("cannot close registration: need at least %d approved teams, got %d", tournament.MinTeams, approvedCount)
	}

	return s.repo.UpdateTournamentStatus(ctx, tournamentID, "registration_closed")
}

func (s *tournamentService) StartTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error {
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return err
	}

	if tournament.OrganizerID != userID {
		return fmt.Errorf("unauthorized: only the organizer can start the tournament")
	}

	if tournament.Status != "registration_closed" {
		return fmt.Errorf("can only start tournaments with closed registration")
	}

	return s.repo.UpdateTournamentStatus(ctx, tournamentID, "ongoing")
}

func (s *tournamentService) CompleteTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error {
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return err
	}

	if tournament.OrganizerID != userID {
		return fmt.Errorf("unauthorized: only the organizer can complete the tournament")
	}

	if tournament.Status != "ongoing" {
		return fmt.Errorf("can only complete ongoing tournaments")
	}

	return s.repo.UpdateTournamentStatus(ctx, tournamentID, "completed")
}

func (s *tournamentService) CancelTournament(ctx context.Context, tournamentID uuid.UUID, userID uuid.UUID) error {
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return err
	}

	if tournament.OrganizerID != userID {
		return fmt.Errorf("unauthorized: only the organizer can cancel the tournament")
	}

	if tournament.Status == "completed" || tournament.Status == "cancelled" {
		return fmt.Errorf("cannot cancel a %s tournament", tournament.Status)
	}

	return s.repo.UpdateTournamentStatus(ctx, tournamentID, "cancelled")
}

// Registration operations

func (s *tournamentService) RegisterTeam(ctx context.Context, tournamentID uuid.UUID, req domain.RegisterTeamRequest, userID uuid.UUID) (*domain.TournamentRegistration, error) {
	tournament, err := s.repo.GetTournamentByID(ctx, tournamentID)
	if err != nil {
		return nil, err
	}

	// Check if registration is open
	if tournament.Status != "registration_open" {
		return nil, fmt.Errorf("registration is not open for this tournament")
	}

	// Check if deadline passed
	if time.Now().After(tournament.RegistrationDeadline) {
		return nil, fmt.Errorf("registration deadline has passed")
	}

	// Check if team already registered
	existing, _ := s.repo.GetRegistration(ctx, tournamentID, req.TeamID)
	if existing != nil {
		return nil, fmt.Errorf("team already registered for this tournament")
	}

	// Check if max teams reached
	approvedCount, err := s.repo.GetRegistrationCount(ctx, tournamentID, strPtr("approved"))
	if err != nil {
		return nil, err
	}
	pendingCount, err := s.repo.GetRegistrationCount(ctx, tournamentID, strPtr("pending"))
	if err != nil {
		return nil, err
	}

	if approvedCount+pendingCount >= tournament.MaxTeams {
		return nil, fmt.Errorf("tournament has reached maximum teams")
	}

	// Validate squad size
	if req.SquadSize < 11 {
		return nil, fmt.Errorf("squad size must be at least 11 players")
	}

	registration := &domain.TournamentRegistration{
		ID:               uuid.New(),
		TournamentID:     tournamentID,
		TeamID:           req.TeamID,
		RegistrationDate: time.Now(),
		Status:           "pending",
		PaymentStatus:    "pending",
		CaptainID:        req.CaptainID,
		SquadSize:        req.SquadSize,
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
	}

	if err := s.repo.RegisterTeam(ctx, registration); err != nil {
		return nil, err
	}

	return registration, nil
}

func (s *tournamentService) GetRegistration(ctx context.Context, tournamentID, teamID uuid.UUID) (*domain.TournamentRegistration, error) {
	return s.repo.GetRegistration(ctx, tournamentID, teamID)
}

func (s *tournamentService) ListRegistrations(ctx context.Context, tournamentID uuid.UUID, status *string) (*domain.RegistrationListResponse, error) {
	registrations, err := s.repo.ListRegistrations(ctx, tournamentID, status)
	if err != nil {
		return nil, err
	}

	return &domain.RegistrationListResponse{
		Registrations: registrations,
		Total:         len(registrations),
	}, nil
}

func (s *tournamentService) ApproveRegistration(ctx context.Context, registrationID uuid.UUID, userID uuid.UUID) error {
	// Get registration to find tournament
	// For now, we'll update directly - in production, we'd verify organizer access
	return s.repo.UpdateRegistrationStatus(ctx, registrationID, "approved", userID, nil)
}

func (s *tournamentService) RejectRegistration(ctx context.Context, registrationID uuid.UUID, reason string, userID uuid.UUID) error {
	return s.repo.UpdateRegistrationStatus(ctx, registrationID, "rejected", userID, &reason)
}

func (s *tournamentService) WithdrawRegistration(ctx context.Context, tournamentID, teamID uuid.UUID, userID uuid.UUID) error {
	registration, err := s.repo.GetRegistration(ctx, tournamentID, teamID)
	if err != nil {
		return err
	}

	if registration.Status == "approved" {
		return fmt.Errorf("cannot withdraw an approved registration")
	}

	return s.repo.WithdrawRegistration(ctx, registration.ID)
}

// Standings operations

func (s *tournamentService) GetStandings(ctx context.Context, tournamentID uuid.UUID, groupName *string) (*domain.StandingsResponse, error) {
	standings, err := s.repo.GetStandings(ctx, tournamentID, groupName)
	if err != nil {
		return nil, err
	}

	return &domain.StandingsResponse{
		Standings: standings,
		Total:     len(standings),
	}, nil
}

func (s *tournamentService) RefreshStandings(ctx context.Context, tournamentID uuid.UUID) error {
	return s.repo.RecalculateStandings(ctx, tournamentID)
}

// Tournament match operations

func (s *tournamentService) GetTournamentMatches(ctx context.Context, tournamentID uuid.UUID, roundNumber *int, groupName *string) (*domain.TournamentMatchesResponse, error) {
	matches, err := s.repo.GetTournamentMatches(ctx, tournamentID, roundNumber, groupName)
	if err != nil {
		return nil, err
	}

	return &domain.TournamentMatchesResponse{
		Matches: matches,
		Total:   len(matches),
	}, nil
}

func (s *tournamentService) ScheduleMatch(ctx context.Context, tournamentID uuid.UUID, matchID uuid.UUID, roundNumber int, roundName, groupName *string) error {
	tournamentMatch := &domain.TournamentMatch{
		ID:           uuid.New(),
		TournamentID: tournamentID,
		MatchID:      matchID,
		RoundNumber:  roundNumber,
		RoundName:    roundName,
		GroupName:    groupName,
		CreatedAt:    time.Now(),
	}

	return s.repo.LinkMatchToTournament(ctx, tournamentMatch)
}

// Helper functions

func strPtr(s string) *string {
	return &s
}
