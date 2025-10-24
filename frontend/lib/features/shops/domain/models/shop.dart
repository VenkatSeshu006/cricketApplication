class Shop {
  final String id;
  final String name;
  final String location;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category; // Cricket Equipment, Sportswear, Accessories, etc.
  final List<String> specialties;
  final bool isOpen;
  final String openingHours;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final int itemCount;
  final bool hasDelivery;
  final double deliveryFee;
  final String ownerName;

  Shop({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.specialties,
    required this.isOpen,
    required this.openingHours,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.itemCount,
    required this.hasDelivery,
    required this.deliveryFee,
    required this.ownerName,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      category: json['category'] as String,
      specialties: (json['specialties'] as List<dynamic>).cast<String>(),
      isOpen: json['isOpen'] as bool,
      openingHours: json['openingHours'] as String,
      phoneNumber: json['phoneNumber'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      itemCount: json['itemCount'] as int,
      hasDelivery: json['hasDelivery'] as bool,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      ownerName: json['ownerName'] as String,
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
      'category': category,
      'specialties': specialties,
      'isOpen': isOpen,
      'openingHours': openingHours,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'itemCount': itemCount,
      'hasDelivery': hasDelivery,
      'deliveryFee': deliveryFee,
      'ownerName': ownerName,
    };
  }
}
