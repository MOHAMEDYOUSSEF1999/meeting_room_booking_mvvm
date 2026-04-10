import 'package:dio/dio.dart';
import 'package:meeting_room_booking_mvvm/core/errors/failures.dart';
import '../errors/failures.dart';

class DioExceptionMapper {
  DioExceptionMapper._();

  static Failure map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _extractMessage(e.response);
        return ServerFailure(message, statusCode: statusCode);
      default:
        return const UnknownFailure();
    }
  }

  static String _extractMessage(Response? response) {
    if (response == null) return 'Unknown server error.';
    final data = response.data;
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Server error (${response.statusCode})';
    }
    return 'Server error (${response.statusCode})';
  }
}
