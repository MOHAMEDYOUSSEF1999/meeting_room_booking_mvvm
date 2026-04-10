
class Booking  {
  final int id;
  final int roomId;
  final String date;
  final String startTime;
  final String endTime;
  final String userName;

  const Booking({
    required this.id,
    required this.roomId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.userName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      roomId: _parseInt(json['room_id']),
      date: json['date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
    'room_id': roomId,
    'date': date,
    'start_time': startTime,
    'end_time': endTime,
    'user_name': userName,
  };

 


  
}
