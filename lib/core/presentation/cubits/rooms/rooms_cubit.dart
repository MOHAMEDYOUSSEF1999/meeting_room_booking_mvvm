import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_room_booking_mvvm/core/errors/failures.dart';
import 'package:meeting_room_booking_mvvm/data/repositories/room_repository.dart';
import 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  final RoomRepository roomRepository;

  RoomsCubit({required this.roomRepository}) : super(const RoomsInitial());

  Future<void> loadRooms() async {
    emit(const RoomsLoading());
    try {
      final rooms = await roomRepository.getRooms();
      emit(RoomsLoaded(rooms));
    } on Failure catch (e) {
      emit(RoomsError(e));
    } catch (e) {
      emit(const RoomsError(UnknownFailure()));
    }
  }
}
