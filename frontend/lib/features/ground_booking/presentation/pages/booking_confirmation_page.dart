import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ground.dart';

class BookingConfirmationPage extends StatefulWidget {
  final Ground ground;
  final DateTime selectedDate;
  final TimeSlot selectedSlot;

  const BookingConfirmationPage({
    super.key,
    required this.ground,
    required this.selectedDate,
    required this.selectedSlot,
  });

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _teamNameController = TextEditingController();
  final _playersController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPaymentMethod = 'bkash';
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _teamNameController.dispose();
    _playersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _processBooking() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your booking for ${widget.ground.name} has been confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to detail
                Navigator.of(context).pop(); // Go back to list
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Confirm Booking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1a2332),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Booking Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1a2332), AppColors.accentBlue],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          Icons.stadium,
                          'Ground',
                          widget.ground.name,
                        ),
                        const Divider(color: Colors.white24, height: 24),
                        _buildSummaryRow(
                          Icons.calendar_today,
                          'Date',
                          DateFormat(
                            'EEEE, MMM d, yyyy',
                          ).format(widget.selectedDate),
                        ),
                        const Divider(color: Colors.white24, height: 24),
                        _buildSummaryRow(
                          Icons.access_time,
                          'Time',
                          '${widget.selectedSlot.startTime} - ${widget.selectedSlot.endTime}',
                        ),
                        const Divider(color: Colors.white24, height: 24),
                        _buildSummaryRow(
                          Icons.payments,
                          'Amount',
                          '৳${widget.selectedSlot.price.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Contact Information
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 11) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email (Optional)',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 32),

                    // Team Information
                    const Text(
                      'Team Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _teamNameController,
                      label: 'Team Name',
                      icon: Icons.groups,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your team name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _playersController,
                      label: 'Number of Players',
                      icon: Icons.people,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of players';
                        }
                        final players = int.tryParse(value);
                        if (players == null || players < 1) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _notesController,
                      label: 'Additional Notes (Optional)',
                      icon: Icons.note,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 32),

                    // Payment Method
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildPaymentMethod('bkash', 'bKash', Icons.phone_android),
                    const SizedBox(height: 12),
                    _buildPaymentMethod(
                      'nagad',
                      'Nagad',
                      Icons.account_balance_wallet,
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentMethod(
                      'card',
                      'Credit/Debit Card',
                      Icons.credit_card,
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentMethod('cash', 'Pay at Venue', Icons.money),

                    const SizedBox(height: 32),

                    // Terms and Conditions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primaryGreen,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _agreedToTerms = !_agreedToTerms;
                                    });
                                  },
                                  child: const Text(
                                    'I agree to the terms and conditions and cancellation policy',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Cancellation must be done 24 hours before booking\n'
                            '• 50% refund for cancellation within 24 hours\n'
                            '• No refund for same-day cancellations',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _processBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm & Pay',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
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
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: AppColors.accentBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.accentBlue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String value, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen.withValues(alpha: 0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryGreen : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.textPrimary : Colors.grey[700],
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
