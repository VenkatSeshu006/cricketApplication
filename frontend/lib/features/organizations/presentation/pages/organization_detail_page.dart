import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/models/organization.dart';

class OrganizationDetailPage extends StatefulWidget {
  final Organization organization;

  const OrganizationDetailPage({super.key, required this.organization});

  @override
  State<OrganizationDetailPage> createState() => _OrganizationDetailPageState();
}

class _OrganizationDetailPageState extends State<OrganizationDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(children: [_buildInfoCards(), _buildTabBar()]),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(),
                _buildTeamsTab(),
                _buildMembershipTab(),
                _buildEventsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: _getTypeColor(widget.organization.type),
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.organization.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.organization.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: _getTypeColor(widget.organization.type),
                child: const Icon(
                  Icons.business,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            if (widget.organization.isVerified)
              Positioned(
                top: 60,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'VERIFIED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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

  Widget _buildInfoCards() {
    return Padding(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickInfoCard(
                  Icons.star,
                  widget.organization.rating.toString(),
                  '${widget.organization.reviewCount} Reviews',
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  Icons.people,
                  '${widget.organization.memberCount}+',
                  'Members',
                  AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  Icons.calendar_today,
                  widget.organization.established,
                  'Established',
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primaryGreen,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Teams'),
          Tab(text: 'Membership'),
          Tab(text: 'Events'),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('About ${widget.organization.type}'),
          const SizedBox(height: 12),
          Text(
            widget.organization.description,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Organization Type'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getTypeColor(
                widget.organization.type,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getTypeColor(
                  widget.organization.type,
                ).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getTypeIcon(widget.organization.type),
                  size: 32,
                  color: _getTypeColor(widget.organization.type),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.organization.type,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(widget.organization.type),
                        ),
                      ),
                      Text(
                        _getTypeDescription(widget.organization.type),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Leadership'),
          const SizedBox(height: 12),
          if (widget.organization.presidentName != null)
            _buildLeadershipCard(
              'President',
              widget.organization.presidentName!,
              Icons.workspace_premium,
            ),
          if (widget.organization.secretaryName != null)
            _buildLeadershipCard(
              'Secretary',
              widget.organization.secretaryName!,
              Icons.person,
            ),
          const SizedBox(height: 24),
          _buildSectionTitle('Contact Information'),
          const SizedBox(height: 12),
          _buildContactInfo(Icons.location_on, widget.organization.address),
          _buildContactInfo(Icons.phone, widget.organization.contactNumber),
          _buildContactInfo(Icons.email, widget.organization.email),
          if (widget.organization.website != null)
            _buildContactInfo(Icons.language, widget.organization.website!),
          const SizedBox(height: 24),
          _buildSectionTitle('Facilities'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.organization.facilities
                .map((facility) => _buildFacilityChip(facility))
                .toList(),
          ),
          if (widget.organization.affiliations.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Affiliations'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.organization.affiliations
                  .map((affiliation) => _buildAffiliationChip(affiliation))
                  .toList(),
            ),
          ],
          if (widget.organization.achievements.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Achievements'),
            const SizedBox(height: 12),
            ...widget.organization.achievements.map(
              (achievement) => _buildAchievementItem(achievement),
            ),
          ],
          const SizedBox(height: 24),
          _buildSectionTitle('Social Media'),
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.organization.facebookUrl != null)
                _buildSocialButton(
                  Icons.facebook,
                  Colors.blue[800]!,
                  widget.organization.facebookUrl!,
                ),
              if (widget.organization.instagramUrl != null)
                _buildSocialButton(
                  Icons.camera_alt,
                  Colors.pink,
                  widget.organization.instagramUrl!,
                ),
              if (widget.organization.twitterUrl != null)
                _buildSocialButton(
                  Icons.alternate_email,
                  Colors.blue,
                  widget.organization.twitterUrl!,
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTeamsTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('Our Teams'),
          const SizedBox(height: 16),
          if (widget.organization.teams.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No teams information available',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            )
          else
            ...widget.organization.teams.map((team) => _buildTeamCard(team)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String teamName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.groups,
                color: AppColors.primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teamName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Representing ${widget.organization.name}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Membership Status Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    widget.organization.acceptingMembers
                        ? Icons.how_to_reg
                        : Icons.cancel,
                    size: 48,
                    color: widget.organization.acceptingMembers
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.organization.acceptingMembers
                        ? 'Accepting New Members'
                        : 'Not Accepting Members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.organization.acceptingMembers
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (widget.organization.membershipFee != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '৳${widget.organization.membershipFee!.toInt()} per year',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    widget.organization.meetingSchedule,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (widget.organization.membershipBenefits.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Membership Benefits'),
            const SizedBox(height: 12),
            ...widget.organization.membershipBenefits.map(
              (benefit) => _buildBenefitItem(benefit),
            ),
          ],
          if (widget.organization.membershipRequirements.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Requirements'),
            const SizedBox(height: 12),
            ...widget.organization.membershipRequirements.map(
              (requirement) => _buildRequirementItem(requirement),
            ),
          ],
          if (widget.organization.acceptingMembers) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showMembershipDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply for Membership',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('Regular Events'),
          const SizedBox(height: 16),
          if (widget.organization.events.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No events information available',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            )
          else
            ...widget.organization.events.map(
              (event) => _buildEventCard(event),
            ),
          const SizedBox(height: 24),
          _buildSectionTitle('Activities'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.organization.activities
                .map((activity) => _buildActivityChip(activity))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEventCard(String eventName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.event, color: Colors.orange, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Organized regularly by the organization',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildLeadershipCard(String position, String name, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
              child: Icon(icon, color: AppColors.primaryGreen, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    position,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
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

  Widget _buildFacilityChip(String facility) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 6),
          Text(
            facility,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffiliationChip(String affiliation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link, size: 16, color: Colors.blue),
          const SizedBox(width: 6),
          Text(
            affiliation,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChip(String activity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Text(
        activity,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String achievement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.emoji_events, size: 20, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              achievement,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 20,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              benefit,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              requirement,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ElevatedButton.icon(
        onPressed: () {
          // Open social media link
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening: $url'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        },
        icon: Icon(icon, size: 18),
        label: const Text('Visit'),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Club':
        return AppColors.primaryGreen;
      case 'Association':
        return Colors.blue;
      case 'Federation':
        return Colors.purple;
      case 'League':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Club':
        return Icons.sports_cricket;
      case 'Association':
        return Icons.business;
      case 'Federation':
        return Icons.account_balance;
      case 'League':
        return Icons.emoji_events;
      default:
        return Icons.group;
    }
  }

  String _getTypeDescription(String type) {
    switch (type) {
      case 'Club':
        return 'Recreational and competitive cricket club';
      case 'Association':
        return 'Cricket governing body and organizer';
      case 'Federation':
        return 'Regional cricket federation';
      case 'League':
        return 'Professional cricket league';
      default:
        return 'Cricket organization';
    }
  }

  void _showMembershipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Membership'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Organization: ${widget.organization.name}'),
            const SizedBox(height: 16),
            const Text(
              'To apply for membership, please:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Fill out the membership form\n• Provide required documents\n• Pay the membership fee\n• Attend an interview (if required)',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Membership application feature coming soon!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}
