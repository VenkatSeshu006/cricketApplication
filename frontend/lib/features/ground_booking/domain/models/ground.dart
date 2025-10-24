class Ground {
  final String id;
  final String name;
  final String location;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double pricePerHour;
  final List<String> facilities;
  final String type; // Turf, Grass, etc.
  final String size; // Full, Half
  final bool isAvailable;
  final double latitude;
  final double longitude;

  Ground({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerHour,
    required this.facilities,
    required this.type,
    required this.size,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
  });

  factory Ground.fromJson(Map<String, dynamic> json) {
    return Ground(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      facilities: (json['facilities'] as List<dynamic>).cast<String>(),
      type: json['type'] as String,
      size: json['size'] as String,
      isAvailable: json['isAvailable'] as bool,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerHour': pricePerHour,
      'facilities': facilities,
      'type': type,
      'size': size,
      'isAvailable': isAvailable,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class TimeSlot {
  final String id;
  final String startTime;
  final String endTime;
  final bool isBooked;
  final double price;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.price,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isBooked: json['isBooked'] as bool,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'isBooked': isBooked,
      'price': price,
    };
  }
}
