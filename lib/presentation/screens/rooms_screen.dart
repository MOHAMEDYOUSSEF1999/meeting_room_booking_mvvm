import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meeting_room_booking_mvvm/core/constants/app_theme.dart';
import 'package:meeting_room_booking_mvvm/core/di/service_locator.dart';
import 'package:meeting_room_booking_mvvm/core/utils/responsive.dart';

import '../cubits/rooms/rooms_cubit.dart';
import '../cubits/rooms/rooms_state.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/room_card.dart';
import '../widgets/shimmer_widgets.dart';
import 'booking_screen.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RoomsCubit>()..loadRooms(),
      child: const _RoomsView(),
    );
  }
}

class _RoomsView extends StatelessWidget {
  const _RoomsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final device = Responsive.fromConstraints(constraints);
          final isDesktop = device == DeviceType.desktop;

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, isDesktop),
              _buildHeader(context, constraints),
              _buildContent(context, constraints),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, bool isDesktop) {
    return SliverAppBar(
      expandedHeight: isDesktop ? 0 : 0,
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppTheme.primary,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.highlight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.meeting_room_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'MeetRoom',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        BlocBuilder<RoomsCubit, RoomsState>(
          builder: (context, state) {
            if (state is RoomsLoaded) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${state.rooms.length} rooms',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildHeader(
      BuildContext context, BoxConstraints constraints) {
    final device = Responsive.fromConstraints(constraints);
    final isDesktop = device == DeviceType.desktop;
    final horizontalPadding = isDesktop ? 48.0 : 16.0;

    return SliverToBoxAdapter(
      child: Container(
        color: AppTheme.primary,
        padding: EdgeInsets.fromLTRB(
            horizontalPadding, 8, horizontalPadding, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find Your\nPerfect Space',
              style: GoogleFonts.plusJakartaSans(
                fontSize: isDesktop ? 36 : 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse and book meeting rooms instantly.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildContent(
      BuildContext context, BoxConstraints constraints) {
    final device = Responsive.fromConstraints(constraints);
    final isDesktop = device == DeviceType.desktop;
    final isTablet = device == DeviceType.tablet;

    final horizontalPadding = isDesktop ? 48.0 : 16.0;
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    final childAspectRatio = isDesktop ? 0.85 : (isTablet ? 0.80 : 1.1);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, 24, horizontalPadding, 32),
      sliver: BlocBuilder<RoomsCubit, RoomsState>(
        builder: (context, state) {
          if (state is RoomsLoading || state is RoomsInitial) {
            return SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, __) => const ShimmerRoomCard(),
                childCount: 6,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
            );
          }

          if (state is RoomsError) {
            return SliverFillRemaining(
              child: ErrorStateWidget(
                message: state.message,
                onRetry: () => context.read<RoomsCubit>().loadRooms(),
              ),
            );
          }

          if (state is RoomsLoaded) {
            if (state.rooms.isEmpty) {
              return const SliverFillRemaining(
                child: EmptyStateWidget(
                  title: 'No Rooms Available',
                  subtitle: 'No meeting rooms have been added yet.',
                  icon: Icons.meeting_room_outlined,
                ),
              );
            }

            return SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final room = state.rooms[index];
                  return RoomCard(
                    room: room,
                    onBook: () => _navigateToBooking(context, room),
                  );
                },
                childCount: state.rooms.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
            );
          }

          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),
    );
  }

  void _navigateToBooking(BuildContext context, room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingScreen(room: room),
      ),
    );
  }
}
