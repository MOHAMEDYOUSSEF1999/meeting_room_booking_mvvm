class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://employeevoice.hub2.icall.com.eg';

  // Endpoints
  static const String roomsEndpoint = '/items/rooms';
  static const String bookingsEndpoint = '/items/bookings';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
