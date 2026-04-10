import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meeting_room_booking_mvvm/core/constants/app_theme.dart';
import 'package:meeting_room_booking_mvvm/data/models/room_model.dart';
import 'package:shimmer/shimmer.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onBook;

  const RoomCard({
    super.key,
    required this.room,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildChip(
                      icon: Icons.people_outline_rounded,
                      label: '${room.capacity} people',
                      color: AppTheme.accent,
                    ),
                    if (room.location != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildChip(
                          icon: Icons.location_on_outlined,
                          label: room.location!,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                if (room.description != null && room.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    room.description!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onBook,
                    icon: const Icon(Icons.calendar_today_rounded, size: 16),
                    label: const Text('Book Room'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (room.imageUrl == null || room.imageUrl!.isEmpty) {
      return _buildPlaceholderImage();
    }
    return CachedNetworkImage(
      imageUrl: room.imageUrl!,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppTheme.shimmerBase,
        highlightColor: AppTheme.shimmerHighlight,
        child: Container(height: 160, color: Colors.white),
      ),
      errorWidget: (context, url, error) => _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.accent,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.meeting_room_rounded,
                  color: Colors.white54,
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  room.name,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
