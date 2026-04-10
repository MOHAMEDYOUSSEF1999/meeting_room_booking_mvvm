import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meeting_room_booking_mvvm/core/constants/app_theme.dart';
import 'package:meeting_room_booking_mvvm/core/di/service_locator.dart';
import 'package:meeting_room_booking_mvvm/core/utils/responsive.dart';
import 'package:meeting_room_booking_mvvm/data/models/room_model.dart';

import '../cubits/booking/booking_cubit.dart';
import '../cubits/booking/booking_state.dart';
import '../widgets/booking_form.dart';
import '../widgets/booking_list_item.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/shimmer_widgets.dart';

class BookingScreen extends StatelessWidget {
  final Room room;

  const BookingScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingCubit>()..loadBookings(room.id),
      child: _BookingView(room: room),
    );
  }
}

class _BookingView extends StatelessWidget {
  final Room room;

  const _BookingView({required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: _buildAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final device = Responsive.fromConstraints(constraints);

          switch (device) {
            case DeviceType.desktop:
            case DeviceType.tablet:
              return _DesktopLayout(room: room);
            case DeviceType.mobile:
              return _MobileLayout(room: room);
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(room.name,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          Text(
            'Capacity: ${room.capacity} people',
            style: GoogleFonts.inter(
                fontSize: 12, color: Colors.white60),
          ),
        ],
      ),
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }
}

/// Desktop / Tablet: two-column side-by-side
class _DesktopLayout extends StatelessWidget {
  final Room room;

  const _DesktopLayout({required this.room});

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        Responsive.getDeviceType(context) == DeviceType.desktop;
    final padding = isDesktop ? 48.0 : 24.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column – booking form
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'New Booking',
                  subtitle: 'Fill in the details to reserve this room.',
                  icon: Icons.add_circle_outline_rounded,
                ),
                const SizedBox(height: 24,),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: BookingForm(
                    room: room,
                    onSuccess: () =>
                        context.read<BookingCubit>().loadBookings(room.id),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divider
        Container(width: 1, color: AppTheme.divider),

        // Right column – existing bookings
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  title: 'Existing Bookings',
                  subtitle: 'All reservations for this room.',
                  icon: Icons.event_note_rounded,
                ),
                const SizedBox(height: 24),
                _BookingsList(roomId: room.id),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Mobile: DefaultTabController with two tabs
class _MobileLayout extends StatelessWidget {
  final Room room;

  const _MobileLayout({required this.room});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppTheme.primary,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: AppTheme.highlight,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(
                  icon: Icon(Icons.add_circle_outline_rounded, size: 18),
                  text: 'New Booking',
                ),
                Tab(
                  icon: Icon(Icons.event_note_rounded, size: 18),
                  text: 'Existing',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Tab 1 – Form
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: BookingForm(
                    room: room,
                    onSuccess: () {
                      context.read<BookingCubit>().loadBookings(room.id);
                      DefaultTabController.of(context).animateTo(1);
                    },
                  ),
                ),
                // Tab 2 – Bookings list
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _BookingsList(roomId: room.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookingsList extends StatelessWidget {
  final int roomId;

  const _BookingsList({required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingsLoading || state is BookingInitial) {
          return Column(
            children: List.generate(
              4,
              (_) => const ShimmerBookingItem(),
            ),
          );
        }

        if (state is BookingsError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () =>
                context.read<BookingCubit>().loadBookings(roomId),
          );
        }

        List<dynamic> bookings = [];
        int? newBookingId;

        if (state is BookingsLoaded) {
          bookings = state.bookings;
        } else if (state is BookingCreated) {
          newBookingId = state.booking.id;
          // Show current list with the newly created one highlighted
          bookings = [
            state.booking,
            ...context
                    .read<BookingCubit>()
                    // ignore: invalid_use_of_protected_member
                    .state is BookingsLoaded
                ? (context.read<BookingCubit>().state as BookingsLoaded)
                    .bookings
                    .where((b) => b.id != state.booking.id)
                    .toList()
                : [],
          ];
        } else if (state is BookingCreating) {
          return Column(
            children: List.generate(
              4,
              (_) => const ShimmerBookingItem(),
            ),
          );
        }

        if (bookings.isEmpty) {
          return const EmptyStateWidget(
            title: 'No Bookings Yet',
            subtitle: 'Be the first to book this room!',
            icon: Icons.event_available_rounded,
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha:  0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${bookings.length} ${bookings.length == 1 ? 'booking' : 'bookings'}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...bookings.map((b) => BookingListItem(
                  booking: b,
                  isHighlighted: b.id == newBookingId,
                )),
          ],
        );
      },
    );
  }
}
