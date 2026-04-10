

class Room  {
  final int id;
  final String name;
  final int capacity;
  final String? imageUrl;
  final String? location;
  final String? description;

  const Room({
    required this.id,
    required this.name,
    required this.capacity,
    this.imageUrl,
    this.location,
    this.description,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int,
      name: json['name']?.toString() ?? 'Unnamed Room',
      capacity: _parseCapacity(json['capacity']),
      imageUrl: json['image']?.toString(),
      location: json['location']?.toString(),
      description: json['description']?.toString(),
    );
  }

  static int _parseCapacity(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

}
