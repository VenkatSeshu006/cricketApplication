import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AllPagesScreen extends StatelessWidget {
  const AllPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        title: const Text('All Features'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.accentBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.explore, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Explore All Features',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Access all features of your cricket companion app',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Cricket Features Section
          _buildSectionTitle('Cricket Features'),
          _buildFeatureCard(
            context,
            icon: Icons.sports_cricket,
            title: 'Live Matches',
            description: 'Watch live cricket matches and scores',
            color: AppColors.primaryOrange,
            pageIndex: 2,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.stadium,
            title: 'Ground Booking',
            description: 'Book cricket grounds for your matches',
            color: AppColors.accentBlue,
            pageIndex: 3,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.emoji_events,
            title: 'Tournaments',
            description: 'Join and manage cricket tournaments',
            color: AppColors.primaryGreen,
            pageIndex: 11,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.event,
            title: 'Upcoming Events',
            description: 'View upcoming cricket events',
            color: AppColors.primaryOrange,
            pageIndex: 10,
          ),

          const SizedBox(height: 32),

          // Services & Marketplace Section
          _buildSectionTitle('Services & Marketplace'),
          _buildFeatureCard(
            context,
            icon: Icons.shopping_bag,
            title: 'Cricket Shops',
            description: 'Buy cricket equipment and gear',
            color: AppColors.accentBlue,
            pageIndex: 4,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.school,
            title: 'Cricket Academies',
            description: 'Find and join cricket training academies',
            color: AppColors.primaryGreen,
            pageIndex: 5,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.business,
            title: 'Organizations',
            description: 'Connect with cricket organizations',
            color: AppColors.primaryOrange,
            pageIndex: 6,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.medical_services,
            title: 'Consult Physio',
            description: 'Get expert physiotherapy consultation',
            color: AppColors.accentBlue,
            pageIndex: 7,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.work,
            title: 'Hire Staff',
            description: 'Hire cricket coaches and staff',
            color: AppColors.primaryGreen,
            pageIndex: 9,
          ),

          const SizedBox(height: 32),

          // Social & Community Section
          _buildSectionTitle('Social & Community'),
          _buildFeatureCard(
            context,
            icon: Icons.people,
            title: 'My Network',
            description: 'Connect with cricket players',
            color: AppColors.primaryOrange,
            badge: '24',
            pageIndex: 8,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.forum,
            title: 'Community',
            description: 'Join cricket discussions and forums',
            color: AppColors.accentBlue,
            pageIndex: 12,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            icon: Icons.chat_bubble,
            title: 'Messages',
            description: 'Chat with your cricket network',
            color: AppColors.primaryGreen,
            badge: '5',
            pageIndex: 13,
          ),

          const SizedBox(height: 32),

          // Quick Actions Section
          _buildSectionTitle('Quick Actions'),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Icons.person,
                  title: 'My Profile',
                  color: AppColors.primaryGreen,
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  color: AppColors.primaryOrange,
                  badge: '12',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon!')),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  color: AppColors.accentBlue,
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Icons.help,
                  title: 'Help',
                  color: AppColors.textSecondary,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help & Support coming soon!'),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int pageIndex,
    String? badge,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () {
          // Navigate back to main shell with the selected page
          Navigator.pop(context, pageIndex);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 28),
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
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
