import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_mvvm/core/constants/app_theme.dart';
import 'package:meeting_room_booking_mvvm/data/models/booking_model.dart';


class BookingListItem extends StatelessWidget {
  final Booking booking;
  final bool isHighlighted;

  const BookingListItem({
    super.key,
    required this.booking,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppTheme.success.withValues(alpha:  0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? AppTheme.success : AppTheme.divider,
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _buildTimeBox(),
            const SizedBox(width: 14),
            Expanded(child: _buildDetails()),
            if (isHighlighted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'New',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox() {
    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            _formatTime(booking.startTime),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            height: 1,
            width: 20,
            color: AppTheme.primary.withValues(alpha:  0.3),
          ),
          Text(
            _formatTime(booking.endTime),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.accent,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline_rounded,
                size: 14, color: AppTheme.textSecondary),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                booking.userName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 13, color: AppTheme.textLight),
            const SizedBox(width: 5),
            Text(
              _formatDate(booking.date),
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final dt = DateTime(2000, 1, 1, hour, minute);
      return DateFormat('h:mm\na').format(dt);
    } catch (_) {
      return time;
    }
  }

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return DateFormat('EEE, MMM d, yyyy').format(dt);
    } catch (_) {
      return date;
    }
  }
}
