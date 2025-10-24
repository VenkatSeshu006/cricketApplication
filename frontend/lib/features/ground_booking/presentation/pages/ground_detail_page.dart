import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ground.dart';
import 'booking_confirmation_page.dart';

class GroundDetailPage extends StatefulWidget {
  final Ground ground;

  const GroundDetailPage({super.key, required this.ground});

  @override
  State<GroundDetailPage> createState() => _GroundDetailPageState();
}

class _GroundDetailPageState extends State<GroundDetailPage> {
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedSlot;

  // Generate dummy time slots for the selected date
  List<TimeSlot> get _timeSlots {
    final random = DateTime.now().microsecond % 5;
    return [
      TimeSlot(
        id: '1',
        startTime: '06:00 AM',
        endTime: '08:00 AM',
        isBooked: random == 0,
        price: widget.ground.pricePerHour * 2,
      ),
      TimeSlot(
        id: '2',
        startTime: '08:00 AM',
        endTime: '10:00 AM',
        isBooked: random == 1,
        price: widget.ground.pricePerHour * 2,
      ),
      TimeSlot(
        id: '3',
        startTime: '10:00 AM',
        endTime: '12:00 PM',
        isBooked: false,
        price: widget.ground.pricePerHour * 2,
      ),
      TimeSlot(
        id: '4',
        startTime: '12:00 PM',
        endTime: '02:00 PM',
        isBooked: random == 2,
        price: widget.ground.pricePerHour * 2,
      ),
      TimeSlot(
        id: '5',
        startTime: '02:00 PM',
        endTime: '04:00 PM',
        isBooked: false,
        price: widget.ground.pricePerHour * 2,
      ),
      TimeSlot(
        id: '6',
        startTime: '04:00 PM',
        endTime: '06:00 PM',
        isBooked: random == 3,
        price: widget.ground.pricePerHour * 2,
      ),
      TimeSlot(
        id: '7',
        startTime: '06:00 PM',
        endTime: '08:00 PM',
        isBooked: false,
        price: widget.ground.pricePerHour * 2 * 1.5, // Peak hours
      ),
      TimeSlot(
        id: '8',
        startTime: '08:00 PM',
        endTime: '10:00 PM',
        isBooked: random == 4,
        price: widget.ground.pricePerHour * 2 * 1.5, // Peak hours
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Image Header with Back Button
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1a2332),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature - Coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to favorites!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.stadium,
                      size: 120,
                      color: Colors.grey,
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
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Available Now',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.ground.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.ground.location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ground Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats
                  Row(
                    children: [
                      _buildStatCard(
                        Icons.star,
                        widget.ground.rating.toString(),
                        'Rating',
                        Colors.amber,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        Icons.square_foot,
                        widget.ground.size,
                        'Ground Size',
                        AppColors.accentBlue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        Icons.grass,
                        widget.ground.type,
                        'Surface',
                        AppColors.primaryGreen,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Address Section
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: AppColors.primaryOrange,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.ground.address,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening in maps...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('Get Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Facilities
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.checklist,
                              color: AppColors.primaryGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Facilities',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: widget.ground.facilities.map((facility) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.primaryGreen.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getFacilityIcon(facility),
                                    size: 18,
                                    color: AppColors.primaryGreen,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    facility,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Date Selection
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 14, // Show next 2 weeks
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isSelected =
                            _selectedDate.day == date.day &&
                            _selectedDate.month == date.month;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildDateCard(date, isSelected),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Time Slots
                  const Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Time Slot Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: _timeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = _timeSlots[index];
                      return _buildTimeSlotCard(slot);
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Bar with Price and Book Button
      bottomNavigationBar: _selectedSlot != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '৳${_selectedSlot!.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingConfirmationPage(
                                ground: widget.ground,
                                selectedDate: _selectedDate,
                                selectedSlot: _selectedSlot!,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue to Book',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(DateTime date, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _selectedSlot = null; // Reset slot selection
        });
      },
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.accentBlue, AppColors.primaryGreen],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentBlue.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Text(
              DateFormat('MMM').format(date).toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white70 : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(TimeSlot slot) {
    final isSelected = _selectedSlot?.id == slot.id;
    final isBooked = slot.isBooked;

    return InkWell(
      onTap: isBooked
          ? null
          : () {
              setState(() {
                _selectedSlot = slot;
              });
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.accentBlue],
                )
              : null,
          color: isBooked
              ? Colors.grey[200]
              : isSelected
              ? null
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isBooked
                ? Colors.grey[300]!
                : isSelected
                ? Colors.transparent
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${slot.startTime} - ${slot.endTime}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isBooked
                    ? Colors.grey[500]
                    : isSelected
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            if (isBooked)
              Text(
                'Booked',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              )
            else
              Text(
                '৳${slot.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? Colors.white : AppColors.primaryGreen,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getFacilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'floodlights':
        return Icons.lightbulb;
      case 'parking':
        return Icons.local_parking;
      case 'changing room':
        return Icons.meeting_room;
      case 'cafeteria':
        return Icons.restaurant;
      case 'scoreboard':
        return Icons.scoreboard;
      case 'practice nets':
        return Icons.sports_cricket;
      case 'bowling machine':
        return Icons.sports_baseball;
      case 'video analysis':
        return Icons.videocam;
      default:
        return Icons.check_circle;
    }
  }
}
