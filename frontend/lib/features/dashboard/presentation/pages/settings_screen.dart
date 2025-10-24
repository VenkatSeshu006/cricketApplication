import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _matchReminders = true;
  bool _socialUpdates = true;
  bool _autoplayVideos = true;
  bool _dataSaverMode = false;
  String _language = 'English';
  String _dateFormat = 'DD/MM/YYYY';
  String _timeFormat = '12 Hour';

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveHelper.getValue(
      context,
      mobile: double.infinity,
      tablet: 700,
      desktop: 900,
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.border.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: ResponsiveHelper.getPagePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Section
                _buildSectionHeader('Account'),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: 'Profile Information',
                      subtitle: 'Update your personal details',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: 'player@cricnet.com',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Notifications Section
                _buildSectionHeader('Notifications'),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.notifications_outlined,
                      title: 'All Notifications',
                      subtitle: 'Enable or disable all notifications',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                          if (!value) {
                            _emailNotifications = false;
                            _pushNotifications = false;
                          }
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: Icons.email_outlined,
                      title: 'Email Notifications',
                      subtitle: 'Receive notifications via email',
                      value: _emailNotifications,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() {
                                _emailNotifications = value;
                              });
                            }
                          : null,
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: Icons.phone_android,
                      title: 'Push Notifications',
                      subtitle: 'Receive push notifications',
                      value: _pushNotifications,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() {
                                _pushNotifications = value;
                              });
                            }
                          : null,
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: Icons.sports_cricket,
                      title: 'Match Reminders',
                      subtitle: 'Get notified before matches start',
                      value: _matchReminders,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() {
                                _matchReminders = value;
                              });
                            }
                          : null,
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: Icons.people_outline,
                      title: 'Social Updates',
                      subtitle: 'Network and community notifications',
                      value: _socialUpdates,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() {
                                _socialUpdates = value;
                              });
                            }
                          : null,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Appearance Section
                _buildSectionHeader('Appearance'),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: 'Switch to dark theme',
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: _language,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () {
                        _showLanguageDialog();
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.calendar_today,
                      title: 'Date Format',
                      subtitle: _dateFormat,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () {
                        _showDateFormatDialog();
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.access_time,
                      title: 'Time Format',
                      subtitle: _timeFormat,
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () {
                        _showTimeFormatDialog();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // App Preferences Section
                _buildSectionHeader('App Preferences'),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.play_circle_outline,
                      title: 'Autoplay Videos',
                      subtitle: 'Automatically play videos in feed',
                      value: _autoplayVideos,
                      onChanged: (value) {
                        setState(() {
                          _autoplayVideos = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: Icons.data_saver_on,
                      title: 'Data Saver Mode',
                      subtitle: 'Reduce data usage',
                      value: _dataSaverMode,
                      onChanged: (value) {
                        setState(() {
                          _dataSaverMode = value;
                          if (value) {
                            _autoplayVideos = false;
                          }
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.storage,
                      title: 'Storage',
                      subtitle: 'Manage app storage and cache',
                      onTap: () {
                        _showStorageDialog();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Privacy & Security Section
                _buildSectionHeader('Privacy & Security'),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.security_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.shield_outlined,
                      title: 'Terms of Service',
                      subtitle: 'Read our terms and conditions',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.block,
                      title: 'Blocked Users',
                      subtitle: 'Manage blocked users',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // About Section
                _buildSectionHeader('About'),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: 'App Version',
                      subtitle: '1.0.0 (Build 1)',
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.update,
                      title: 'Check for Updates',
                      subtitle: 'You are using the latest version',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You are already on the latest version!',
                            ),
                            backgroundColor: AppColors.primaryGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help or contact support',
                      onTap: () {
                        _showHelpDialog();
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.feedback_outlined,
                      title: 'Send Feedback',
                      subtitle: 'Help us improve CricNet',
                      onTap: () {
                        _showFeedbackDialog();
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.star_outline,
                      title: 'Rate Us',
                      subtitle: 'Rate us on the app store',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thank you for your support!'),
                            backgroundColor: AppColors.primaryGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Danger Zone
                _buildSectionHeader('Danger Zone'),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.delete_outline,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account',
                      onTap: () {
                        _showDeleteAccountDialog();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show logout confirmation dialog
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (trailing == null && onTap != null)
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout, color: AppColors.error),
              SizedBox(width: 12),
              Text('Logout'),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout? You will need to login again to access your account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Trigger logout event
                context.read<AuthBloc>().add(const LogoutRequested());
                // Navigate to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {
    final languages = [
      'English',
      'Hindi',
      'Tamil',
      'Telugu',
      'Malayalam',
      'Kannada',
      'Bengali',
      'Marathi',
      'Gujarati',
      'Punjabi',
    ];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Select Language'),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: SizedBox(
            width: ResponsiveHelper.getValue(
              context,
              mobile: 300,
              tablet: 400,
              desktop: 500,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected = language == _language;
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _language,
                  activeColor: AppColors.primaryGreen,
                  selected: isSelected,
                  onChanged: (value) {
                    setState(() {
                      _language = value!;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $value'),
                        backgroundColor: AppColors.primaryGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDateFormatDialog() {
    final dateFormats = {
      'DD/MM/YYYY': '22/10/2025',
      'MM/DD/YYYY': '10/22/2025',
      'YYYY-MM-DD': '2025-10-22',
      'DD MMM YYYY': '22 Oct 2025',
      'MMM DD, YYYY': 'Oct 22, 2025',
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Select Date Format'),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dateFormats.length,
              itemBuilder: (context, index) {
                final format = dateFormats.keys.elementAt(index);
                final example = dateFormats[format];
                final isSelected = format == _dateFormat;
                return RadioListTile<String>(
                  title: Text(format),
                  subtitle: Text(
                    'Example: $example',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: format,
                  groupValue: _dateFormat,
                  activeColor: AppColors.primaryGreen,
                  selected: isSelected,
                  onChanged: (value) {
                    setState(() {
                      _dateFormat = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTimeFormatDialog() {
    final timeFormats = {'12 Hour': '02:30 PM', '24 Hour': '14:30'};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Select Time Format'),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: timeFormats.length,
              itemBuilder: (context, index) {
                final format = timeFormats.keys.elementAt(index);
                final example = timeFormats[format];
                final isSelected = format == _timeFormat;
                return RadioListTile<String>(
                  title: Text(format),
                  subtitle: Text(
                    'Example: $example',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: format,
                  groupValue: _timeFormat,
                  activeColor: AppColors.primaryGreen,
                  selected: isSelected,
                  onChanged: (value) {
                    setState(() {
                      _timeFormat = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showStorageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Storage Management'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStorageItem('App Size', '45 MB'),
              const SizedBox(height: 12),
              _buildStorageItem('Cache', '12 MB'),
              const SizedBox(height: 12),
              _buildStorageItem('Downloaded Media', '28 MB'),
              const SizedBox(height: 12),
              _buildStorageItem('Total', '85 MB', isTotal: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cache cleared successfully!'),
                        backgroundColor: AppColors.primaryGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear Cache'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStorageItem(String label, String size, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          size,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primaryGreen : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.primaryGreen),
              SizedBox(width: 12),
              Text('Help & Support'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need help? Contact us through:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                Icons.email_outlined,
                'Email',
                'support@cricnet.com',
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                Icons.phone_outlined,
                'Phone',
                '+91 98765 43210',
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                Icons.chat_bubble_outline,
                'Live Chat',
                'Available 24/7',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactOption(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.feedback_outlined, color: AppColors.primaryGreen),
              SizedBox(width: 12),
              Text('Send Feedback'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'We would love to hear from you! Please share your thoughts, suggestions, or report any issues.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type your feedback here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                feedbackController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (feedbackController.text.trim().isNotEmpty) {
                  feedbackController.dispose();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you for your feedback!'),
                      backgroundColor: AppColors.primaryGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              SizedBox(width: 12),
              Text('Delete Account'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'This action cannot be undone. All your data including:',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8),
              Text('• Profile information', style: TextStyle(fontSize: 14)),
              Text('• Match history', style: TextStyle(fontSize: 14)),
              Text('• Bookings and records', style: TextStyle(fontSize: 14)),
              Text('• Network connections', style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text(
                'will be permanently deleted.',
                style: TextStyle(color: AppColors.textSecondary),
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
                Navigator.pop(context);
                // Show confirmation input dialog
                _showDeleteConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type "DELETE" to confirm account deletion:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmController,
                decoration: InputDecoration(
                  hintText: 'Type DELETE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                confirmController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (confirmController.text == 'DELETE') {
                  confirmController.dispose();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deletion request submitted'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please type DELETE to confirm'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm Delete'),
            ),
          ],
        );
      },
    );
  }
}
