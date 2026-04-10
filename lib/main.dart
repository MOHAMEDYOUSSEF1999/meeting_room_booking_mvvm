import 'package:flutter/material.dart';
import 'package:meeting_room_booking_mvvm/core/presentation/screens/rooms_screen.dart';
import 'core/constants/app_theme.dart';
import 'core/di/service_locator.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const MeetRoomApp());
}

class MeetRoomApp extends StatelessWidget {
  const MeetRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetRoom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoomsScreen(),
    );
  }
}
