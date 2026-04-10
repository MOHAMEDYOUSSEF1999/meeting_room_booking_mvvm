import 'package:dio/dio.dart';
import '../models/booking_model.dart';
import '../models/booking_request.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_client.dart';
import '../../core/utils/dio_exception_mapper.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookingsByRoom(int roomId);
  Future<Booking> createBooking(BookingRequest request);
}

class BookingRepositoryImpl implements BookingRepository {
  final Dio _dio;

  BookingRepositoryImpl({Dio? dio}) : _dio = dio ?? NetworkClient.instance;

  @override
  Future<List<Booking>> getBookingsByRoom(int roomId) async {
    try {
      final response = await _dio.get(
        AppConstants.bookingsEndpoint,
        queryParameters: {'filter[room_id][_eq]': roomId},
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<Booking> createBooking(BookingRequest request) async {
    try {
      final response = await _dio.post(
        AppConstants.bookingsEndpoint,
        data: request.toJson(),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return Booking.fromJson(data);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }
}
