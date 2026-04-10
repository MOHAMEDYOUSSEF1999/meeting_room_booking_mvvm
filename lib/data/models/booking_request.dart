class BookingRequest {
  final int roomId;
  final String date;
  final String startTime;
  final String endTime;
  final String userName;

  const BookingRequest({
    required this.roomId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
    'room_id': roomId,
    'date': date,
    'start_time': startTime,
    'end_time': endTime,
    'user_name': userName,
  };
}
