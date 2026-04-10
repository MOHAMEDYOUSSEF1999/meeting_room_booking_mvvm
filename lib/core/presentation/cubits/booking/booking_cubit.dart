import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_room_booking_mvvm/core/errors/failures.dart';
import 'package:meeting_room_booking_mvvm/data/models/booking_model.dart';
import 'package:meeting_room_booking_mvvm/data/models/booking_request.dart';
import 'package:meeting_room_booking_mvvm/data/repositories/booking_repository.dart';

import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository bookingRepository;

  List<Booking> _currentBookings = [];

  BookingCubit({required this.bookingRepository}) : super(const BookingInitial());

  Future<void> loadBookings(int roomId) async {
    emit(const BookingsLoading());
    try {
      final bookings = await bookingRepository.getBookingsByRoom(roomId);
      _currentBookings = bookings;
      emit(BookingsLoaded(bookings));
    } on Failure catch (e) {
      emit(BookingsError(e));
    } catch (e) {
      emit(const BookingsError(UnknownFailure()));
    }
  }

  Future<void> createBooking(BookingRequest request) async {
  
   

    emit(const BookingCreating());
    try {
      final booking = await bookingRepository.createBooking(request);
      _currentBookings.add(booking);
      emit(BookingCreated(booking));
    } on Failure catch (e) {
      emit(BookingCreateError(e));
    } catch (e) {
      emit(const BookingCreateError(UnknownFailure()));
    }
  }

  void resetToLoaded() {
    if (_currentBookings.isNotEmpty) {
      emit(BookingsLoaded(_currentBookings));
    } else {
      emit(const BookingInitial());
    }
  }
}
