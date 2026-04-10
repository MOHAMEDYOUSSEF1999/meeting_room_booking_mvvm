
import 'package:meeting_room_booking_mvvm/core/errors/failures.dart';
import 'package:meeting_room_booking_mvvm/data/models/room_model.dart';

abstract class RoomsState{
  const RoomsState();

  
}

class RoomsInitial extends RoomsState {
  const RoomsInitial();
}

class RoomsLoading extends RoomsState {
  const RoomsLoading();
}

class RoomsLoaded extends RoomsState {
  final List<Room> rooms;

  const RoomsLoaded(this.rooms);

 
}

class RoomsError extends RoomsState {
  final Failure failure;

  const RoomsError(this.failure);

  String get message => failure.message;

  
}
