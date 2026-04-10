import 'package:get_it/get_it.dart';
import 'package:meeting_room_booking_mvvm/data/repositories/booking_repository.dart';
import 'package:meeting_room_booking_mvvm/data/repositories/room_repository.dart';
import 'package:meeting_room_booking_mvvm/presentation/cubits/booking/booking_cubit.dart';
import 'package:meeting_room_booking_mvvm/presentation/cubits/rooms/rooms_cubit.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {

  sl.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl());
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl());

  sl.registerFactory<RoomsCubit>(() => RoomsCubit(roomRepository: sl()));
  sl.registerFactory<BookingCubit>(() => BookingCubit(bookingRepository: sl()));
}
