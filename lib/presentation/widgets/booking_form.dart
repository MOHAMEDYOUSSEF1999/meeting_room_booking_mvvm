import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_mvvm/core/constants/app_theme.dart';
import 'package:meeting_room_booking_mvvm/data/models/booking_request.dart';
import 'package:meeting_room_booking_mvvm/data/models/room_model.dart';

import '../cubits/booking/booking_cubit.dart';
import '../cubits/booking/booking_state.dart';

class BookingForm extends StatefulWidget {
  final Room room;
  final VoidCallback? onSuccess;

  const BookingForm({super.key, required this.room, this.onSuccess});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) => DateFormat('EEEE, MMM d, yyyy').format(dt);
  String _formatTime(TimeOfDay t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeDisplay(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat('h:mm a').format(dt);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) => _timePickerTheme(child!),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ??
          (_startTime != null
              ? TimeOfDay(hour: _startTime!.hour + 1, minute: _startTime!.minute)
              : const TimeOfDay(hour: 10, minute: 0)),
      builder: (context, child) => _timePickerTheme(child!),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  Widget _timePickerTheme(Widget child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child,
      );

  bool _validateTimes() {
    if (_startTime == null || _endTime == null) return true;
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    return endMinutes > startMinutes;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showError('Please select a date.');
      return;
    }
    if (_startTime == null) {
      _showError('Please select a start time.');
      return;
    }
    if (_endTime == null) {
      _showError('Please select an end time.');
      return;
    }
    if (!_validateTimes()) {
      _showError('End time must be after start time.');
      return;
    }

    final request = BookingRequest(
      roomId: widget.room.id,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      startTime: _formatTime(_startTime!),
      endTime: _formatTime(_endTime!),
      userName: _nameController.text.trim(),
    );

    context.read<BookingCubit>().createBooking(request);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingCreating) {
          setState(() => _isSubmitting = true);
        } else {
          setState(() => _isSubmitting = false);
        }

        if (state is BookingCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
          const  SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text('Room booked successfully!'),
                ],
              ),
              backgroundColor: AppTheme.success,
            ),
          );
          widget.onSuccess?.call();
        } else if (state is BookingConflict) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppTheme.warning,
              duration: const Duration(seconds: 4),
            ),
          );
          context.read<BookingCubit>().resetToLoaded();
        } else if (state is BookingCreateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
            ),
          );
          context.read<BookingCubit>().resetToLoaded();
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionLabel('Your Name'),
            const SizedBox(height: 8,),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Ahmed Mohamed',
                prefixIcon: Icon(Icons.person_outline_rounded,
                    color: AppTheme.textSecondary),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your name.';
                if (v.trim().length < 2) return 'Name must be at least 2 characters.';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _sectionLabel('Date'),
            const SizedBox(height: 8),
            _pickerTile(
              icon: Icons.calendar_today_rounded,
              label: _selectedDate != null
                  ? _formatDate(_selectedDate!)
                  : 'Select date',
              isEmpty: _selectedDate == null,
              onTap: _pickDate,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Start Time'),
                      const SizedBox(height: 8),
                      _pickerTile(
                        icon: Icons.access_time_rounded,
                        label: _startTime != null
                            ? _formatTimeDisplay(_startTime!)
                            : 'Start',
                        isEmpty: _startTime == null,
                        onTap: _pickStartTime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('End Time'),
                      const SizedBox(height: 8),
                      _pickerTile(
                        icon: Icons.access_time_filled_rounded,
                        label: _endTime != null
                            ? _formatTimeDisplay(_endTime!)
                            : 'End',
                        isEmpty: _endTime == null,
                        onTap: _pickEndTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 18),
                          const SizedBox(width: 8),
                          const Text('Confirm Booking'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required bool isEmpty,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: isEmpty ? AppTheme.textLight : AppTheme.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isEmpty ? AppTheme.textLight : AppTheme.textPrimary,
                  fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
