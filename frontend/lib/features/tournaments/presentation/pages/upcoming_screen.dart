import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  String _selectedFilter = 'All';
  bool _isCalendarView = false;

  final List<String> _filters = [
    'All',
    'Matches',
    'Tournaments',
    'Training',
    'Bookings',
  ];

  final List<Map<String, dynamic>> _events = [
    {
      'type': 'Match',
      'title': 'Bangladesh vs India - 3rd ODI',
      'date': DateTime(2024, 10, 25, 14, 0),
      'venue': 'Mirpur, Dhaka',
      'description': 'Crucial decider match in the 3-match series',
      'participants': 'Bangladesh vs India',
      'isLive': false,
    },
    {
      'type': 'Training',
      'title': 'Batting Practice Session',
      'date': DateTime(2024, 10, 22, 9, 0),
      'venue': 'BKSP Ground 2',
      'description': 'Weekly batting technique improvement session',
      'coach': 'Mohammad Salahuddin',
      'duration': '2 hours',
    },
    {
      'type': 'Tournament',
      'title': 'Corporate Cricket Championship',
      'date': DateTime(2024, 11, 1, 8, 0),
      'venue': 'Multiple Venues, Dhaka',
      'description': 'T20 tournament for corporate teams',
      'teams': '8 teams',
      'registrationDeadline': DateTime(2024, 10, 28),
    },
    {
      'type': 'Booking',
      'title': 'Ground Booking - Mirpur Turf',
      'date': DateTime(2024, 10, 23, 16, 0),
      'venue': 'Mirpur Turf Cricket Ground',
      'description': 'Team practice session',
      'duration': '2 hours',
      'bookingId': 'BK-2024-1023',
    },
    {
      'type': 'Match',
      'title': 'Dhaka vs Chittagong - DPL',
      'date': DateTime(2024, 10, 24, 9, 30),
      'venue': 'Sher-e-Bangla Stadium',
      'description': 'Dhaka Premier League match',
      'participants': 'Dhaka Dynamites vs Chittagong Vikings',
      'isLive': false,
    },
    {
      'type': 'Training',
      'title': 'Spin Bowling Masterclass',
      'date': DateTime(2024, 10, 26, 15, 0),
      'venue': 'Sylhet Academy',
      'description': 'Advanced spin bowling techniques workshop',
      'coach': 'Nazmul Islam',
      'duration': '3 hours',
    },
    {
      'type': 'Tournament',
      'title': 'U-19 District Championship',
      'date': DateTime(2024, 10, 25, 8, 0),
      'venue': 'Chittagong',
      'description': 'Youth cricket development tournament',
      'teams': '16 teams',
      'ageGroup': 'Under 19',
    },
    {
      'type': 'Booking',
      'title': 'Physio Consultation',
      'date': DateTime(2024, 10, 22, 11, 0),
      'venue': 'Sports Medicine Clinic, Dhaka',
      'description': 'Regular checkup with Dr. Ashraful Islam',
      'duration': '45 minutes',
      'bookingId': 'PC-2024-1022',
    },
    {
      'type': 'Match',
      'title': 'BPL Opening Ceremony',
      'date': DateTime(2024, 11, 20, 18, 0),
      'venue': 'Mirpur, Dhaka',
      'description': 'Bangladesh Premier League 2024 kickoff',
      'participants': 'All BPL Teams',
      'isLive': false,
    },
    {
      'type': 'Training',
      'title': 'Fitness Bootcamp',
      'date': DateTime(2024, 10, 27, 7, 0),
      'venue': 'BKSP Campus',
      'description': 'Intensive cricket fitness program',
      'coach': 'Fitness Team',
      'duration': '4 hours',
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    var filtered = _events;

    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((e) => e['type'] == _selectedFilter.replaceAll('s', ''))
          .toList();
    }

    // Sort by date
    filtered.sort((a, b) => a['date'].compareTo(b['date']));

    return filtered;
  }

  Map<String, List<Map<String, dynamic>>> get _groupedEvents {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var event in _filteredEvents) {
      final dateKey = DateFormat('yyyy-MM-dd').format(event['date']);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(event);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getValue(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(
                            context,
                            size: 'medium',
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.event,
                        color: Colors.white,
                        size: ResponsiveHelper.getIconSize(
                          context,
                          size: 'large',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getSpacing(
                        context,
                        size: 'medium',
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming Events',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getTitle1(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              size: 'small',
                            ),
                          ),
                          Text(
                            '${_filteredEvents.length} events scheduled',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBody(context),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // View Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(
                            context,
                            size: 'small',
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.view_list,
                              color: !_isCalendarView
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              size: ResponsiveHelper.getIconSize(
                                context,
                                size: 'medium',
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isCalendarView = false;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: _isCalendarView
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              size: ResponsiveHelper.getIconSize(
                                context,
                                size: 'medium',
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isCalendarView = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Filter Chips
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  final count = filter == 'All'
                      ? _events.length
                      : _events
                            .where(
                              (e) => e['type'] == filter.replaceAll('s', ''),
                            )
                            .length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text('$filter ($count)'),
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primaryOrange,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryOrange
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // Events Content
        if (_isCalendarView) _buildCalendarView() else _buildListView(),

        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }

  Widget _buildListView() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          // Calculate number of columns based on screen width
          // Using 2 columns max for events since they're larger cards
          int crossAxisCount = 1; // Default for mobile
          if (constraints.crossAxisExtent > 900) {
            crossAxisCount = 2; // Desktop/Tablet - 2 columns
          }

          // Use list for mobile, grid for larger screens
          if (crossAxisCount == 1) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final event = _filteredEvents[index];
                return _buildEventCard(event);
              }, childCount: _filteredEvents.length),
            );
          } else {
            return SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final event = _filteredEvents[index];
                return _buildEventCard(event);
              }, childCount: _filteredEvents.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCalendarView() {
    final grouped = _groupedEvents;
    final dates = grouped.keys.toList()..sort();

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final dateKey = dates[index];
        final eventsForDate = grouped[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen.withValues(alpha: 0.1),
                      AppColors.accentBlue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM d, y').format(date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${eventsForDate.length} events',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Events for this date - Responsive Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate number of columns based on screen width
                  int crossAxisCount = 1; // Default for mobile
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 2; // Desktop/Tablet - 2 columns
                  }

                  if (crossAxisCount == 1) {
                    // Mobile - use Column for vertical list
                    return Column(
                      children: eventsForDate
                          .map((event) => _buildEventCard(event))
                          .toList(),
                    );
                  } else {
                    // Web - use GridView for 2-column layout
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: eventsForDate.length,
                      itemBuilder: (context, eventIndex) {
                        return _buildEventCard(eventsForDate[eventIndex]);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      }, childCount: dates.length),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final eventColor = _getEventTypeColor(event['type']);
    final eventIcon = _getEventTypeIcon(event['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(left: BorderSide(color: eventColor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: eventColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(eventIcon, color: eventColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: eventColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              event['type'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: eventColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat(
                              'MMM d, y • h:mm a',
                            ).format(event['date']),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event['venue'],
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              event['description'],
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Type-specific info
            if (event['participants'] != null) ...[
              _buildInfoChip(Icons.people, event['participants']),
            ],
            if (event['coach'] != null) ...[
              _buildInfoChip(Icons.person, 'Coach: ${event['coach']}'),
            ],
            if (event['duration'] != null) ...[
              _buildInfoChip(Icons.timer, 'Duration: ${event['duration']}'),
            ],
            if (event['teams'] != null) ...[
              _buildInfoChip(Icons.groups, event['teams']),
            ],
            if (event['bookingId'] != null) ...[
              _buildInfoChip(
                Icons.confirmation_number,
                'ID: ${event['bookingId']}',
              ),
            ],
            const SizedBox(height: 16),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'View details functionality coming soon!',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: eventColor,
                      side: BorderSide(color: eventColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _addToCalendar(event);
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Add to Calendar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: eventColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Color _getEventTypeColor(String type) {
    switch (type) {
      case 'Match':
        return AppColors.primaryGreen;
      case 'Tournament':
        return AppColors.primaryOrange;
      case 'Training':
        return AppColors.accentBlue;
      case 'Booking':
        return Colors.purple;
      default:
        return AppColors.textPrimary;
    }
  }

  IconData _getEventTypeIcon(String type) {
    switch (type) {
      case 'Match':
        return Icons.sports_cricket;
      case 'Tournament':
        return Icons.emoji_events;
      case 'Training':
        return Icons.fitness_center;
      case 'Booking':
        return Icons.event_available;
      default:
        return Icons.event;
    }
  }

  void _addToCalendar(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event['title']} added to calendar!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
