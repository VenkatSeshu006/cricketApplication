import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';

class CreateMatchPage extends StatefulWidget {
  const CreateMatchPage({super.key});

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Match Details
  final _matchTitleController = TextEditingController();
  final _venueController = TextEditingController();
  String _matchType = 'Friendly';
  String _matchFormat = 'T20';
  int _overs = 20;
  DateTime? _matchDate;
  TimeOfDay? _matchTime;

  // Team Selection
  String? _teamA;
  String? _teamB;
  final List<String> _availableTeams = [
    'Dhaka Warriors',
    'Chittagong Challengers',
    'Sylhet Strikers',
    'Khulna Tigers',
    'Rajshahi Rangers',
    'Comilla Victorians',
  ];

  // Team A Players
  final List<Map<String, String>> _teamAPlayers = [];
  final List<Map<String, String>> _selectedTeamAPlayers = [];

  // Team B Players
  final List<Map<String, String>> _teamBPlayers = [];
  final List<Map<String, String>> _selectedTeamBPlayers = [];

  // Toss Settings
  String? _tossWinner;
  String? _tossDecision;

  // Match Officials
  final _umpire1Controller = TextEditingController();
  final _umpire2Controller = TextEditingController();
  final _scorerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSamplePlayers();
  }

  void _initializeSamplePlayers() {
    // Sample players for existing teams
    _teamAPlayers.addAll([
      {'name': 'Mohammad Rahim', 'role': 'Batsman', 'jerseyNo': '10'},
      {'name': 'Shakib Rahman', 'role': 'All-rounder', 'jerseyNo': '15'},
      {'name': 'Tamim Hasan', 'role': 'Batsman', 'jerseyNo': '28'},
      {'name': 'Mustafizur Khan', 'role': 'Bowler', 'jerseyNo': '5'},
      {'name': 'Mushfiqur Ali', 'role': 'Wicket-keeper', 'jerseyNo': '1'},
      {'name': 'Mehidy Ahmed', 'role': 'All-rounder', 'jerseyNo': '27'},
      {'name': 'Liton Islam', 'role': 'Batsman', 'jerseyNo': '18'},
      {'name': 'Taskin Uddin', 'role': 'Bowler', 'jerseyNo': '7'},
      {'name': 'Mahmudullah Hassan', 'role': 'All-rounder', 'jerseyNo': '30'},
      {'name': 'Soumya Sarkar', 'role': 'Batsman', 'jerseyNo': '9'},
      {'name': 'Rubel Hossain', 'role': 'Bowler', 'jerseyNo': '11'},
    ]);

    _teamBPlayers.addAll([
      {'name': 'Imrul Kayes', 'role': 'Batsman', 'jerseyNo': '12'},
      {'name': 'Sabbir Rahman', 'role': 'Batsman', 'jerseyNo': '24'},
      {'name': 'Anamul Haque', 'role': 'Wicket-keeper', 'jerseyNo': '2'},
      {'name': 'Nasir Hossain', 'role': 'All-rounder', 'jerseyNo': '17'},
      {'name': 'Al-Amin Hossain', 'role': 'Bowler', 'jerseyNo': '8'},
      {'name': 'Mominul Haque', 'role': 'Batsman', 'jerseyNo': '16'},
      {'name': 'Shafiul Islam', 'role': 'Bowler', 'jerseyNo': '6'},
      {'name': 'Nurul Hasan', 'role': 'Wicket-keeper', 'jerseyNo': '3'},
      {'name': 'Nazmul Islam', 'role': 'Bowler', 'jerseyNo': '21'},
      {'name': 'Afif Hossain', 'role': 'All-rounder', 'jerseyNo': '13'},
      {'name': 'Saifuddin Ahmed', 'role': 'All-rounder', 'jerseyNo': '19'},
    ]);
  }

  @override
  void dispose() {
    _matchTitleController.dispose();
    _venueController.dispose();
    _umpire1Controller.dispose();
    _umpire2Controller.dispose();
    _scorerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Create Match',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getPagePadding(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentStep == 0) _buildMatchDetailsStep(),
                    if (_currentStep == 1) _buildTeamSelectionStep(),
                    if (_currentStep == 2) _buildTeamAPlayersStep(),
                    if (_currentStep == 3) _buildTeamBPlayersStep(),
                    if (_currentStep == 4) _buildTossAndOfficialsStep(),
                    if (_currentStep == 5) _buildReviewStep(),
                  ],
                ),
              ),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final steps = ['Details', 'Teams', 'Team A', 'Team B', 'Toss', 'Review'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppColors.primaryGreen
                              : AppColors.border.withValues(alpha: 0.3),
                        ),
                      ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppColors.primaryGreen
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted || isCurrent
                              ? AppColors.primaryGreen
                              : AppColors.border.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                      ),
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppColors.primaryGreen
                              : AppColors.border.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMatchDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Match Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _matchTitleController,
          decoration: InputDecoration(
            labelText: 'Match Title',
            hintText: 'e.g., Season Opener 2025',
            prefixIcon: const Icon(Icons.title, color: AppColors.primaryGreen),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Match title is required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _venueController,
          decoration: InputDecoration(
            labelText: 'Venue',
            hintText: 'e.g., Shere Bangla Stadium',
            prefixIcon: const Icon(
              Icons.location_on,
              color: AppColors.primaryGreen,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Venue is required' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _matchType,
          decoration: InputDecoration(
            labelText: 'Match Type',
            prefixIcon: const Icon(
              Icons.category,
              color: AppColors.primaryGreen,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
          items: ['Friendly', 'League', 'Tournament', 'Practice']
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) => setState(() => _matchType = value!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _matchFormat,
          decoration: InputDecoration(
            labelText: 'Match Format',
            prefixIcon: const Icon(
              Icons.sports_cricket,
              color: AppColors.primaryGreen,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
          items: ['T10', 'T20', 'One Day', 'Test']
              .map(
                (format) =>
                    DropdownMenuItem(value: format, child: Text(format)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _matchFormat = value!;
              _overs = value == 'T10'
                  ? 10
                  : value == 'T20'
                  ? 20
                  : value == 'One Day'
                  ? 50
                  : 90;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildNumberField(
          label: 'Overs per Innings',
          value: _overs,
          min: 5,
          max: 50,
          onChanged: (value) => setState(() => _overs = value),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Match Date',
              prefixIcon: const Icon(
                Icons.calendar_today,
                color: AppColors.primaryGreen,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Text(
              _matchDate != null
                  ? '${_matchDate!.day}/${_matchDate!.month}/${_matchDate!.year}'
                  : 'Select match date',
              style: TextStyle(
                color: _matchDate != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _selectTime(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Match Time',
              prefixIcon: const Icon(
                Icons.access_time,
                color: AppColors.primaryGreen,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Text(
              _matchTime != null
                  ? _matchTime!.format(context)
                  : 'Select match time',
              style: TextStyle(
                color: _matchTime != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTeamSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Select Teams',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose two teams or create new ones',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        // Team A
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shield,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Team A',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _teamA,
                decoration: InputDecoration(
                  labelText: 'Select Team A',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                items: _availableTeams
                    .where((team) => team != _teamB)
                    .map(
                      (team) =>
                          DropdownMenuItem(value: team, child: Text(team)),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _teamA = value;
                }),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showCreateTeamDialog('A');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Team A'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primaryGreen),
                    foregroundColor: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // VS Indicator
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Team B
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Team B',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _teamB,
                decoration: InputDecoration(
                  labelText: 'Select Team B',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                items: _availableTeams
                    .where((team) => team != _teamA)
                    .map(
                      (team) =>
                          DropdownMenuItem(value: team, child: Text(team)),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _teamB = value;
                }),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showCreateTeamDialog('B');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Team B'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.blue),
                    foregroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTeamAPlayersStep() {
    return _buildTeamPlayersSelection(
      'Team A',
      _teamA ?? 'Team A',
      _teamAPlayers,
      _selectedTeamAPlayers,
      AppColors.primaryGreen,
    );
  }

  Widget _buildTeamBPlayersStep() {
    return _buildTeamPlayersSelection(
      'Team B',
      _teamB ?? 'Team B',
      _teamBPlayers,
      _selectedTeamBPlayers,
      Colors.blue,
    );
  }

  Widget _buildTeamPlayersSelection(
    String teamLabel,
    String teamName,
    List<Map<String, String>> allPlayers,
    List<Map<String, String>> selectedPlayers,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Select $teamLabel Players',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selected: ${selectedPlayers.length}/11 players',
          style: TextStyle(
            fontSize: 14,
            color: selectedPlayers.length >= 11
                ? AppColors.primaryGreen
                : AppColors.textSecondary,
            fontWeight: selectedPlayers.length >= 11
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: color, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Select at least 11 players for the playing XI',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allPlayers.length,
          itemBuilder: (context, index) {
            final player = allPlayers[index];
            final isSelected = selectedPlayers.contains(player);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      if (selectedPlayers.length < 11) {
                        selectedPlayers.add(player);
                      }
                    } else {
                      selectedPlayers.remove(player);
                    }
                  });
                },
                title: Text(
                  player['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${player['role']} • Jersey #${player['jerseyNo']}',
                ),
                secondary: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Text(
                    player['jerseyNo']!,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
                activeColor: color,
                enabled: isSelected || selectedPlayers.length < 11,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showAddPlayerDialog(teamLabel, allPlayers),
            icon: const Icon(Icons.person_add),
            label: const Text('Add New Player'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: color),
              foregroundColor: color,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTossAndOfficialsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Toss & Match Officials',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Toss Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _tossWinner,
          decoration: InputDecoration(
            labelText: 'Toss Winner (Optional)',
            prefixIcon: const Icon(
              Icons.emoji_events,
              color: AppColors.primaryGreen,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
          ),
          items: [_teamA, _teamB]
              .where((team) => team != null)
              .map((team) => DropdownMenuItem(value: team, child: Text(team!)))
              .toList(),
          onChanged: (value) => setState(() => _tossWinner = value),
        ),
        if (_tossWinner != null) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _tossDecision,
            decoration: InputDecoration(
              labelText: 'Toss Decision',
              prefixIcon: const Icon(
                Icons.touch_app,
                color: AppColors.primaryGreen,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
            ),
            items: ['Bat', 'Bowl']
                .map(
                  (decision) =>
                      DropdownMenuItem(value: decision, child: Text(decision)),
                )
                .toList(),
            onChanged: (value) => setState(() => _tossDecision = value),
          ),
        ],
        const SizedBox(height: 24),
        const Text(
          'Match Officials',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _umpire1Controller,
          decoration: InputDecoration(
            labelText: 'Umpire 1 (Optional)',
            hintText: 'Name of first umpire',
            prefixIcon: const Icon(Icons.person, color: AppColors.primaryGreen),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _umpire2Controller,
          decoration: InputDecoration(
            labelText: 'Umpire 2 (Optional)',
            hintText: 'Name of second umpire',
            prefixIcon: const Icon(Icons.person, color: AppColors.primaryGreen),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _scorerController,
          decoration: InputDecoration(
            labelText: 'Scorer (Optional)',
            hintText: 'Name of the scorer',
            prefixIcon: const Icon(
              Icons.edit_note,
              color: AppColors.primaryGreen,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Review Match Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildReviewCard('Match Information', [
          _buildReviewItem('Title', _matchTitleController.text),
          _buildReviewItem('Venue', _venueController.text),
          _buildReviewItem('Type', _matchType),
          _buildReviewItem('Format', _matchFormat),
          _buildReviewItem('Overs', '$_overs overs'),
          if (_matchDate != null)
            _buildReviewItem(
              'Date',
              '${_matchDate!.day}/${_matchDate!.month}/${_matchDate!.year}',
            ),
          if (_matchTime != null)
            _buildReviewItem('Time', _matchTime!.format(context)),
        ]),
        const SizedBox(height: 16),
        _buildReviewCard('Teams', [
          _buildReviewItem('Team A', _teamA ?? 'Not selected'),
          _buildReviewItem(
            'Team A Players',
            '${_selectedTeamAPlayers.length} players',
          ),
          const Divider(),
          _buildReviewItem('Team B', _teamB ?? 'Not selected'),
          _buildReviewItem(
            'Team B Players',
            '${_selectedTeamBPlayers.length} players',
          ),
        ]),
        if (_tossWinner != null) ...[
          const SizedBox(height: 16),
          _buildReviewCard('Toss', [
            _buildReviewItem('Winner', _tossWinner!),
            if (_tossDecision != null)
              _buildReviewItem('Decision', _tossDecision!),
          ]),
        ],
        if (_umpire1Controller.text.isNotEmpty ||
            _umpire2Controller.text.isNotEmpty ||
            _scorerController.text.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildReviewCard('Officials', [
            if (_umpire1Controller.text.isNotEmpty)
              _buildReviewItem('Umpire 1', _umpire1Controller.text),
            if (_umpire2Controller.text.isNotEmpty)
              _buildReviewItem('Umpire 2', _umpire2Controller.text),
            if (_scorerController.text.isNotEmpty)
              _buildReviewItem('Scorer', _scorerController.text),
          ]),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required int min,
    required int max,
    required void Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
                color: AppColors.primaryGreen,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: value < max ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add),
                color: AppColors.primaryGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryGreen),
                  foregroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep < 5) {
                  if (_validateCurrentStep()) {
                    setState(() => _currentStep++);
                  }
                } else {
                  _createMatch();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_currentStep < 5 ? 'Next' : 'Create Match'),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) return false;
      if (_matchDate == null || _matchTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select match date and time')),
        );
        return false;
      }
    } else if (_currentStep == 1) {
      if (_teamA == null || _teamB == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both teams')),
        );
        return false;
      }
    } else if (_currentStep == 2) {
      if (_selectedTeamAPlayers.length < 11) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least 11 players for Team A'),
          ),
        );
        return false;
      }
    } else if (_currentStep == 3) {
      if (_selectedTeamBPlayers.length < 11) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least 11 players for Team B'),
          ),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _matchDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _matchTime = picked);
  }

  void _showCreateTeamDialog(String teamLabel) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Team $teamLabel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                hintText: 'Enter team name',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You can add players in the next step',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  if (teamLabel == 'A') {
                    _teamA = nameController.text;
                  } else {
                    _teamB = nameController.text;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${nameController.text} created successfully!',
                    ),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddPlayerDialog(
    String teamLabel,
    List<Map<String, String>> playersList,
  ) {
    final nameController = TextEditingController();
    final jerseyController = TextEditingController();
    String selectedRole = 'Batsman';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add Player to $teamLabel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Player Name',
                    hintText: 'Enter player name',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper']
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedRole = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: jerseyController,
                  decoration: const InputDecoration(
                    labelText: 'Jersey Number',
                    hintText: 'e.g., 10',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    jerseyController.text.isNotEmpty) {
                  setState(() {
                    playersList.add({
                      'name': nameController.text,
                      'role': selectedRole,
                      'jerseyNo': jerseyController.text,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${nameController.text} added successfully!',
                      ),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text('Add Player'),
            ),
          ],
        ),
      ),
    );
  }

  void _createMatch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 32),
            SizedBox(width: 12),
            Text('Match Created!'),
          ],
        ),
        content: const Text(
          'Your match has been created successfully! You can now start the match or set it up for live streaming.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Navigate to live streaming setup
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Setup Streaming'),
          ),
        ],
      ),
    );
  }
}
