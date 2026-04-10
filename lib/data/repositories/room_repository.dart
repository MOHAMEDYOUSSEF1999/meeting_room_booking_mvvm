import 'package:dio/dio.dart';
import '../models/room_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_client.dart';
import '../../core/utils/dio_exception_mapper.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
}

class RoomRepositoryImpl implements RoomRepository {
  final Dio _dio;

  RoomRepositoryImpl({Dio? dio}) : _dio = dio ?? NetworkClient.instance;

  @override
  Future<List<Room>> getRooms() async {
    try {
      final response = await _dio.get(AppConstants.roomsEndpoint);
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data.map((json) => Room.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    } catch (e) {
      throw const UnknownFailure();
    }
  }
}