import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Basic Information
  final _tournamentNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _organizerController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _prizePoolController = TextEditingController();

  // Tournament Settings
  String _tournamentType = 'Knockout';
  String _ballType = 'Tennis Ball';
  String _matchFormat = 'Limited Overs';
  int _oversPerMatch = 10;
  int _playersPerTeam = 11;
  int _minimumTeams = 4;
  int _maximumTeams = 16;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _registrationDeadline;

  // Match Settings
  bool _allowTies = false;
  bool _usePowerplay = false;
  bool _useDRS = false;
  int _powerplayOvers = 0;
  String _tieBreaker = 'Super Over';

  // Registration Settings
  double _registrationFee = 0;
  bool _requireApproval = true;
  int _maxPlayersPerTeam = 15;
  int _minPlayersPerTeam = 11;

  // Team Selection
  final List<String> _selectedTeams = [];
  final List<String> _availableTeams = [
    'Dhaka Warriors',
    'Chittagong Challengers',
    'Sylhet Strikers',
    'Khulna Tigers',
    'Rajshahi Rangers',
    'Comilla Victorians',
    'Barisal Bulls',
    'Rangpur Riders',
  ];

  // Rules and Regulations
  final _rulesController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _tournamentNameController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _prizePoolController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Create Tournament',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getPagePadding(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentStep == 0) _buildBasicInfoStep(),
                    if (_currentStep == 1) _buildTournamentSettingsStep(),
                    if (_currentStep == 2) _buildMatchSettingsStep(),
                    if (_currentStep == 3) _buildTeamSelectionStep(),
                    if (_currentStep == 4) _buildRegistrationStep(),
                    if (_currentStep == 5) _buildReviewStep(),
                  ],
                ),
              ),
            ),
          ),
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final steps = [
      'Basic Info',
      'Settings',
      'Match Rules',
      'Teams',
      'Registration',
      'Review',
    ];

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
                      width: 32,
                      height: 32,
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
                                size: 16,
                                color: Colors.white,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 12,
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
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 10,
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

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle('Basic Information'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _tournamentNameController,
          label: 'Tournament Name *',
          hint: 'e.g., Summer Cricket Championship 2025',
          icon: Icons.emoji_events,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Tournament name is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _descriptionController,
          label: 'Description',
          hint: 'Brief description of the tournament',
          icon: Icons.description,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _venueController,
          label: 'Venue *',
          hint: 'e.g., Shere Bangla National Stadium',
          icon: Icons.location_on,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Venue is required' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _organizerController,
          label: 'Organizer Name *',
          hint: 'Your name or organization',
          icon: Icons.person,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Organizer name is required' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _contactController,
                label: 'Contact Number *',
                hint: '+880 1XXX-XXXXXX',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Contact is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _emailController,
                label: 'Email *',
                hint: 'email@example.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _prizePoolController,
          label: 'Prize Pool (Optional)',
          hint: 'e.g., ৳50,000',
          icon: Icons.money,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTournamentSettingsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle('Tournament Settings'),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Tournament Type',
          value: _tournamentType,
          items: ['Knockout', 'Round Robin', 'League', 'Mixed'],
          icon: Icons.format_list_bulleted,
          onChanged: (value) => setState(() => _tournamentType = value!),
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Ball Type',
          value: _ballType,
          items: ['Tennis Ball', 'Leather Ball', 'Season Ball'],
          icon: Icons.sports_cricket,
          onChanged: (value) => setState(() => _ballType = value!),
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Match Format',
          value: _matchFormat,
          items: ['Limited Overs', 'T20', 'T10', 'One Day', 'Test'],
          icon: Icons.access_time,
          onChanged: (value) => setState(() => _matchFormat = value!),
        ),
        const SizedBox(height: 16),
        _buildNumberField(
          label: 'Overs Per Match',
          value: _oversPerMatch,
          min: 5,
          max: 50,
          onChanged: (value) => setState(() => _oversPerMatch = value),
        ),
        const SizedBox(height: 16),
        _buildNumberField(
          label: 'Players Per Team',
          value: _playersPerTeam,
          min: 6,
          max: 16,
          onChanged: (value) => setState(() => _playersPerTeam = value),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                label: 'Minimum Teams',
                value: _minimumTeams,
                min: 2,
                max: 32,
                onChanged: (value) => setState(() => _minimumTeams = value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField(
                label: 'Maximum Teams',
                value: _maximumTeams,
                min: 2,
                max: 64,
                onChanged: (value) => setState(() => _maximumTeams = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Start Date *',
          selectedDate: _startDate,
          onTap: () => _selectDate(context, true),
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'End Date *',
          selectedDate: _endDate,
          onTap: () => _selectDate(context, false),
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Registration Deadline',
          selectedDate: _registrationDeadline,
          onTap: () => _selectRegistrationDeadline(context),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMatchSettingsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle('Match Rules & Settings'),
        const SizedBox(height: 16),
        _buildSwitchTile(
          title: 'Allow Ties',
          subtitle: 'Matches can end in a tie',
          value: _allowTies,
          onChanged: (value) => setState(() => _allowTies = value),
        ),
        if (_allowTies) ...[
          const SizedBox(height: 8),
          _buildDropdownField(
            label: 'Tie Breaker Method',
            value: _tieBreaker,
            items: ['Super Over', 'Bowl Out', 'Coin Toss', 'Share Points'],
            icon: Icons.gavel,
            onChanged: (value) => setState(() => _tieBreaker = value!),
          ),
        ],
        const SizedBox(height: 16),
        _buildSwitchTile(
          title: 'Use Powerplay',
          subtitle: 'Enable powerplay overs',
          value: _usePowerplay,
          onChanged: (value) => setState(() => _usePowerplay = value),
        ),
        if (_usePowerplay) ...[
          const SizedBox(height: 8),
          _buildNumberField(
            label: 'Powerplay Overs',
            value: _powerplayOvers,
            min: 1,
            max: _oversPerMatch ~/ 2,
            onChanged: (value) => setState(() => _powerplayOvers = value),
          ),
        ],
        const SizedBox(height: 16),
        _buildSwitchTile(
          title: 'Use DRS (Decision Review System)',
          subtitle: 'Enable DRS for matches',
          value: _useDRS,
          onChanged: (value) => setState(() => _useDRS = value),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Additional Rules'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _rulesController,
          label: 'Tournament Rules & Regulations',
          hint: 'Enter any specific rules for this tournament...',
          icon: Icons.rule,
          maxLines: 5,
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
        _buildSectionTitle('Select Participating Teams'),
        const SizedBox(height: 8),
        Text(
          'Select ${_selectedTeams.length} of $_minimumTeams-$_maximumTeams teams',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You can also allow teams to register themselves after tournament creation',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableTeams.map((team) {
            final isSelected = _selectedTeams.contains(team);
            return FilterChip(
              label: Text(team),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (_selectedTeams.length < _maximumTeams) {
                      _selectedTeams.add(team);
                    }
                  } else {
                    _selectedTeams.remove(team);
                  }
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primaryGreen,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.border.withValues(alpha: 0.3),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Navigate to create team page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Create new team feature coming soon!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create New Team'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primaryGreen),
              foregroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRegistrationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle('Registration Settings'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: TextEditingController(
            text: _registrationFee > 0 ? _registrationFee.toString() : '',
          ),
          label: 'Registration Fee per Team (Optional)',
          hint: 'e.g., ৳5000',
          icon: Icons.payments,
          keyboardType: TextInputType.number,
          onChanged: (value) => _registrationFee = double.tryParse(value) ?? 0,
        ),
        const SizedBox(height: 16),
        _buildSwitchTile(
          title: 'Require Approval',
          subtitle: 'Team registrations need your approval',
          value: _requireApproval,
          onChanged: (value) => setState(() => _requireApproval = value),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                label: 'Minimum Players per Team',
                value: _minPlayersPerTeam,
                min: 6,
                max: 20,
                onChanged: (value) =>
                    setState(() => _minPlayersPerTeam = value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField(
                label: 'Maximum Players per Team',
                value: _maxPlayersPerTeam,
                min: 11,
                max: 25,
                onChanged: (value) =>
                    setState(() => _maxPlayersPerTeam = value),
              ),
            ),
          ],
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
        _buildSectionTitle('Review Tournament Details'),
        const SizedBox(height: 16),
        _buildReviewCard('Basic Information', [
          _buildReviewItem('Name', _tournamentNameController.text),
          _buildReviewItem('Venue', _venueController.text),
          _buildReviewItem('Organizer', _organizerController.text),
          _buildReviewItem('Contact', _contactController.text),
          if (_prizePoolController.text.isNotEmpty)
            _buildReviewItem('Prize Pool', _prizePoolController.text),
        ]),
        const SizedBox(height: 16),
        _buildReviewCard('Tournament Settings', [
          _buildReviewItem('Type', _tournamentType),
          _buildReviewItem('Ball Type', _ballType),
          _buildReviewItem('Format', _matchFormat),
          _buildReviewItem('Overs', '$_oversPerMatch overs'),
          _buildReviewItem('Players', '$_playersPerTeam per team'),
          _buildReviewItem('Teams', '$_minimumTeams - $_maximumTeams teams'),
          if (_startDate != null)
            _buildReviewItem(
              'Start Date',
              '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
            ),
          if (_endDate != null)
            _buildReviewItem(
              'End Date',
              '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
            ),
        ]),
        const SizedBox(height: 16),
        _buildReviewCard('Match Rules', [
          _buildReviewItem('Ties Allowed', _allowTies ? 'Yes' : 'No'),
          if (_allowTies) _buildReviewItem('Tie Breaker', _tieBreaker),
          _buildReviewItem('Powerplay', _usePowerplay ? 'Yes' : 'No'),
          if (_usePowerplay)
            _buildReviewItem('Powerplay Overs', '$_powerplayOvers overs'),
          _buildReviewItem('DRS', _useDRS ? 'Yes' : 'No'),
        ]),
        const SizedBox(height: 16),
        _buildReviewCard('Teams', [
          _buildReviewItem('Selected Teams', '${_selectedTeams.length} teams'),
          if (_selectedTeams.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTeams
                    .map(
                      (team) => Chip(
                        label: Text(team, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.primaryGreen.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ]),
        const SizedBox(height: 16),
        _buildReviewCard('Registration', [
          _buildReviewItem(
            'Fee',
            _registrationFee > 0 ? '৳$_registrationFee' : 'Free',
          ),
          _buildReviewItem(
            'Approval Required',
            _requireApproval ? 'Yes' : 'No',
          ),
          _buildReviewItem(
            'Players per Team',
            '$_minPlayersPerTeam - $_maxPlayersPerTeam',
          ),
        ]),
        const SizedBox(height: 24),
        CheckboxListTile(
          value: _acceptTerms,
          onChanged: (value) => setState(() => _acceptTerms = value!),
          title: const Text(
            'I accept the terms and conditions',
            style: TextStyle(fontSize: 14),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.primaryGreen,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
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

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(
            Icons.calendar_today,
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
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Select date',
          style: TextStyle(
            color: selectedDate != null
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryGreen,
      ),
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
                  _createTournament();
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
              child: Text(_currentStep < 5 ? 'Next' : 'Create Tournament'),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) return false;
      if (_tournamentNameController.text.isEmpty ||
          _venueController.text.isEmpty ||
          _organizerController.text.isEmpty ||
          _contactController.text.isEmpty ||
          _emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return false;
      }
    } else if (_currentStep == 1) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end dates')),
        );
        return false;
      }
      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date must be after start date')),
        );
        return false;
      }
    } else if (_currentStep == 3) {
      if (_selectedTeams.length < _minimumTeams) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select at least $_minimumTeams teams'),
          ),
        );
        return false;
      }
    } else if (_currentStep == 5) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept terms and conditions')),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
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
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectRegistrationDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: _startDate ?? DateTime.now().add(const Duration(days: 365)),
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
    if (picked != null) {
      setState(() => _registrationDeadline = picked);
    }
  }

  void _createTournament() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 32),
            SizedBox(width: 12),
            Text('Success!'),
          ],
        ),
        content: const Text(
          'Your tournament has been created successfully! You will receive a confirmation email shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
