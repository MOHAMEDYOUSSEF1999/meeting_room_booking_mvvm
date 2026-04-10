

import 'package:meeting_room_booking_mvvm/core/errors/failures.dart';
import 'package:meeting_room_booking_mvvm/data/models/booking_model.dart';

abstract class BookingState {
  const BookingState();

  
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

// Bookings list states
class BookingsLoading extends BookingState {
  const BookingsLoading();
}

class BookingsLoaded extends BookingState {
  final List<Booking> bookings;

  const BookingsLoaded(this.bookings);

  
}

class BookingsError extends BookingState {
  final Failure failure;

  const BookingsError(this.failure);

  String get message => failure.message;

 
}

// Create booking states
class BookingCreating extends BookingState {
  const BookingCreating();
}

class BookingCreated extends BookingState {
  final Booking booking;

  const BookingCreated(this.booking);

 
}

class BookingCreateError extends BookingState {
  final Failure failure;

  const BookingCreateError(this.failure);

  String get message => failure.message;

  
}

class BookingConflict extends BookingState {
  final String message;

  const BookingConflict(this.message);

}
