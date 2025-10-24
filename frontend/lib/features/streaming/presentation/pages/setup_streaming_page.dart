import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';

class SetupStreamingPage extends StatefulWidget {
  const SetupStreamingPage({super.key});

  @override
  State<SetupStreamingPage> createState() => _SetupStreamingPageState();
}

class _SetupStreamingPageState extends State<SetupStreamingPage> {
  // Streaming Mode Selection
  String? _streamingMode; // 'phone' or 'professional'

  // Match Selection
  String? _selectedMatch;
  final List<String> _availableMatches = [
    'Dhaka Warriors vs Chittagong Challengers - T20 - Today 3:00 PM',
    'Sylhet Strikers vs Khulna Tigers - ODI - Today 5:30 PM',
    'Rajshahi Rangers vs Comilla Victorians - T20 - Tomorrow 2:00 PM',
  ];

  // Phone Streaming Settings
  String _phoneCamera = 'Back Camera';
  String _phoneResolution = '1080p';
  bool _phoneAutoFocus = true;
  bool _phoneStabilization = true;
  bool _phoneFlashlight = false;

  // Professional Streaming Settings
  int _numberOfCameras = 1;
  String _switchingMode = 'Manual';
  bool _useGraphics = true;
  bool _useReplays = false;
  bool _useScoreBug = true;

  // Stream Settings
  String _streamQuality = 'HD (720p)';
  String _platformSelection = 'YouTube';
  final _streamTitleController = TextEditingController();
  final _streamKeyController = TextEditingController();
  bool _enableChat = true;
  bool _recordStream = true;

  @override
  void dispose() {
    _streamTitleController.dispose();
    _streamKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Setup Live Streaming',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getPagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            if (_streamingMode == null) _buildModeSelection(),
            if (_streamingMode != null) ...[
              _buildBackButton(),
              const SizedBox(height: 24),
              _buildMatchSelection(),
              const SizedBox(height: 24),
              if (_streamingMode == 'phone')
                _buildPhoneStreamingSettings()
              else
                _buildProfessionalStreamingSettings(),
              const SizedBox(height: 24),
              _buildStreamSettings(),
              const SizedBox(height: 24),
              _buildPlatformSettings(),
              const SizedBox(height: 32),
              _buildStartStreamButton(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Streaming Mode',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select how you want to stream your cricket match',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        // Phone Streaming Card
        _buildModeCard(
          icon: Icons.phone_android,
          title: 'Phone Camera',
          description:
              'Stream using your smartphone camera. Perfect for casual matches and quick setup.',
          features: [
            'Quick and easy setup',
            'Single camera view',
            'Basic controls',
            'No additional equipment needed',
          ],
          color: AppColors.primaryGreen,
          onTap: () => setState(() => _streamingMode = 'phone'),
        ),
        const SizedBox(height: 24),
        // Professional Streaming Card
        _buildModeCard(
          icon: Icons.videocam,
          title: 'Professional Camera',
          description:
              'Multi-camera professional setup with advanced controls for high-quality broadcasts.',
          features: [
            'Multiple camera angles',
            'Graphics and overlays',
            'Instant replays',
            'Advanced switching controls',
          ],
          color: Colors.deepPurple,
          onTap: () => setState(() => _streamingMode = 'professional'),
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: color.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _streamingMode = null),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Change Mode'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primaryGreen),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _streamingMode == 'phone'
                ? AppColors.primaryGreen.withValues(alpha: 0.1)
                : Colors.deepPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                _streamingMode == 'phone'
                    ? Icons.phone_android
                    : Icons.videocam,
                size: 16,
                color: _streamingMode == 'phone'
                    ? AppColors.primaryGreen
                    : Colors.deepPurple,
              ),
              const SizedBox(width: 8),
              Text(
                _streamingMode == 'phone' ? 'Phone Camera' : 'Professional',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _streamingMode == 'phone'
                      ? AppColors.primaryGreen
                      : Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Match',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedMatch,
            decoration: InputDecoration(
              labelText: 'Choose a match to stream',
              prefixIcon: const Icon(
                Icons.sports_cricket,
                color: AppColors.primaryGreen,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: _availableMatches
                .map(
                  (match) => DropdownMenuItem(value: match, child: Text(match)),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedMatch = value),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneStreamingSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Camera Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              _buildDropdownSetting(
                label: 'Camera',
                value: _phoneCamera,
                items: ['Front Camera', 'Back Camera'],
                icon: Icons.flip_camera_android,
                onChanged: (value) => setState(() => _phoneCamera = value!),
              ),
              const SizedBox(height: 16),
              _buildDropdownSetting(
                label: 'Resolution',
                value: _phoneResolution,
                items: ['720p', '1080p', '4K'],
                icon: Icons.high_quality,
                onChanged: (value) => setState(() => _phoneResolution = value!),
              ),
              const SizedBox(height: 16),
              _buildSwitchSetting(
                title: 'Auto Focus',
                subtitle: 'Automatically focus on the action',
                value: _phoneAutoFocus,
                onChanged: (value) => setState(() => _phoneAutoFocus = value),
              ),
              const Divider(),
              _buildSwitchSetting(
                title: 'Video Stabilization',
                subtitle: 'Reduce camera shake',
                value: _phoneStabilization,
                onChanged: (value) =>
                    setState(() => _phoneStabilization = value),
              ),
              const Divider(),
              _buildSwitchSetting(
                title: 'Flashlight',
                subtitle: 'Use phone flashlight for better lighting',
                value: _phoneFlashlight,
                onChanged: (value) => setState(() => _phoneFlashlight = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalStreamingSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Professional Camera Setup',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
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
              const Text(
                'Number of Cameras',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _numberOfCameras > 1
                        ? () => setState(() => _numberOfCameras--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.deepPurple,
                  ),
                  Text(
                    '$_numberOfCameras Camera${_numberOfCameras > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: _numberOfCameras < 6
                        ? () => setState(() => _numberOfCameras++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDropdownSetting(
                label: 'Camera Switching',
                value: _switchingMode,
                items: ['Manual', 'Auto', 'AI-Assisted'],
                icon: Icons.switch_camera,
                onChanged: (value) => setState(() => _switchingMode = value!),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Stream Features',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildSwitchSetting(
                title: 'Graphics & Overlays',
                subtitle: 'Add score, team names, and graphics',
                value: _useGraphics,
                onChanged: (value) => setState(() => _useGraphics = value),
              ),
              const Divider(),
              _buildSwitchSetting(
                title: 'Score Bug',
                subtitle: 'Display live score on screen',
                value: _useScoreBug,
                onChanged: (value) => setState(() => _useScoreBug = value),
              ),
              const Divider(),
              _buildSwitchSetting(
                title: 'Instant Replays',
                subtitle: 'Show replays of key moments',
                value: _useReplays,
                onChanged: (value) => setState(() => _useReplays = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreamSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stream Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              TextField(
                controller: _streamTitleController,
                decoration: InputDecoration(
                  labelText: 'Stream Title',
                  hintText: 'e.g., Live Cricket Match - Dhaka vs Chittagong',
                  prefixIcon: const Icon(
                    Icons.title,
                    color: AppColors.primaryGreen,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdownSetting(
                label: 'Stream Quality',
                value: _streamQuality,
                items: ['SD (480p)', 'HD (720p)', 'Full HD (1080p)', '4K'],
                icon: Icons.hd,
                onChanged: (value) => setState(() => _streamQuality = value!),
              ),
              const SizedBox(height: 16),
              _buildSwitchSetting(
                title: 'Enable Live Chat',
                subtitle: 'Allow viewers to chat during stream',
                value: _enableChat,
                onChanged: (value) => setState(() => _enableChat = value),
              ),
              const Divider(),
              _buildSwitchSetting(
                title: 'Record Stream',
                subtitle: 'Save stream for later viewing',
                value: _recordStream,
                onChanged: (value) => setState(() => _recordStream = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Streaming Platform',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              _buildPlatformOption(
                platform: 'YouTube',
                icon: Icons.play_circle_outline,
                color: Colors.red,
              ),
              const Divider(),
              _buildPlatformOption(
                platform: 'Facebook',
                icon: Icons.facebook,
                color: Colors.blue,
              ),
              const Divider(),
              _buildPlatformOption(
                platform: 'Custom RTMP',
                icon: Icons.stream,
                color: AppColors.primaryGreen,
              ),
              if (_platformSelection == 'Custom RTMP') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _streamKeyController,
                  decoration: InputDecoration(
                    labelText: 'Stream Key',
                    hintText: 'Enter your RTMP stream key',
                    prefixIcon: const Icon(
                      Icons.key,
                      color: AppColors.primaryGreen,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformOption({
    required String platform,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _platformSelection == platform;
    return InkWell(
      onTap: () => setState(() => _platformSelection = platform),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                platform,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Radio<String>(
              value: platform,
              groupValue: _platformSelection,
              onChanged: (value) => setState(() => _platformSelection = value!),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSetting({
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
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      activeThumbColor: AppColors.primaryGreen,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildStartStreamButton() {
    final canStartStream =
        _selectedMatch != null &&
        (_streamingMode == 'phone' || _numberOfCameras > 0) &&
        _streamTitleController.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canStartStream ? _startStream : null,
        icon: const Icon(Icons.play_arrow, size: 28),
        label: const Text(
          'Start Live Stream',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: canStartStream
              ? Colors.red
              : AppColors.border.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _startStream() {
    // Capture context before async gap
    final navigator = Navigator.of(context);
    final dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.circle, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Going Live!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.red),
            const SizedBox(height: 24),
            Text(
              'Setting up your ${_streamingMode == 'phone' ? 'phone camera' : 'professional'} stream...',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Platform: $_platformSelection',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate stream setup
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      navigator.pop(); // Close loading dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: dialogContext,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 32),
              SizedBox(width: 12),
              Text('Stream Started!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your stream is now live! Viewers can watch on the selected platform.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stream Details:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mode: ${_streamingMode == 'phone' ? 'Phone Camera' : 'Professional'}',
                    ),
                    Text('Quality: $_streamQuality'),
                    Text('Platform: $_platformSelection'),
                  ],
                ),
              ),
            ],
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
                // Navigate to stream control page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text('Control Stream'),
            ),
          ],
        ),
      );
    });
  }
}
