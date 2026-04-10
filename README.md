

# MeetRoom — Meeting Room Booking App

A Flutter application for browsing and booking meeting rooms, built as part of an interview task.

---
## Approximate time spent on the task is one hour 
##  Screenshots

The app is fully responsive across **mobile**, **tablet**, and **desktop (web)**:

| Platform | Layout |
|---|---|
| Mobile | Tab-based layout (New Booking / Existing Bookings) |
| Tablet | Two-column side-by-side layout |
| Desktop | Two-column side-by-side with wider padding |

---

##  How to Run

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`

### Steps

```bash
# 1. Clone the repository
git clone <repo-url>
cd meeting_room_booking

# 2. Install dependencies
flutter pub get

# 3. Run on your target platform
flutter run                          # Connected device / emulator
flutter run -d chrome                # Web (Chrome)
flutter run -d macos                 # macOS desktop
flutter build apk --release          # Android APK
flutter build web --release          # Web build
```

---

##  Libraries Used

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc`  State management (Cubit) |
| `dio` HTTP client & API integration |
| `cached_network_image` Image caching & loading |
| `google_fonts`  Typography (Plus Jakarta Sans + Inter) |
| `shimmer`  Loading skeleton animations |
| `get_it`  Dependency injection (service locator) |

| `intl`  Date & time formatting |

| `flutter_svg`  SVG rendering |

---

##  Architecture & Technical Decisions

### Architecture: MVVM + Clean-ish Layering

```
lib/
├── core/
│   ├── constants/       # AppConstants, AppTheme
│   ├── di/              # GetIt service locator
│   ├── errors/          # Failure classes
│   ├── network/         # Dio NetworkClient
│   └── utils/           # Responsive helper, DioExceptionMapper
├── data/
│   ├── models/          # Room, Booking, BookingRequest
│   └── repositories/    # RoomRepository, BookingRepository (abstract + impl)
└── presentation/
    ├── cubits/
    │   ├── rooms/        # RoomsCubit + RoomsState
    │   └── booking/      # BookingCubit + BookingState
    ├── screens/          # RoomsScreen, BookingScreen
    └── widgets/          # Reusable UI components
```

### apk file present in releases folder