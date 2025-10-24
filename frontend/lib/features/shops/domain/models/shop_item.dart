class ShopItem {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double? discountPrice;
  final String category; // Bats, Balls, Pads, Gloves, Shoes, Clothing, etc.
  final String brand;
  final bool inStock;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final List<String> sizes;
  final List<String> colors;
  final List<String> images;
  final String material;
  final String weight;
  final bool isFeatured;
  final bool isNewArrival;

  ShopItem({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.discountPrice,
    required this.category,
    required this.brand,
    required this.inStock,
    required this.stockQuantity,
    required this.rating,
    required this.reviewCount,
    required this.sizes,
    required this.colors,
    required this.images,
    required this.material,
    required this.weight,
    required this.isFeatured,
    required this.isNewArrival,
  });

  double get finalPrice => discountPrice ?? price;

  double get discountPercentage {
    if (discountPrice == null) return 0;
    return ((price - discountPrice!) / price * 100);
  }

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discountPrice'] != null
          ? (json['discountPrice'] as num).toDouble()
          : null,
      category: json['category'] as String,
      brand: json['brand'] as String,
      inStock: json['inStock'] as bool,
      stockQuantity: json['stockQuantity'] as int,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      sizes: (json['sizes'] as List<dynamic>).cast<String>(),
      colors: (json['colors'] as List<dynamic>).cast<String>(),
      images: (json['images'] as List<dynamic>).cast<String>(),
      material: json['material'] as String,
      weight: json['weight'] as String,
      isFeatured: json['isFeatured'] as bool,
      isNewArrival: json['isNewArrival'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'discountPrice': discountPrice,
      'category': category,
      'brand': brand,
      'inStock': inStock,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'sizes': sizes,
      'colors': colors,
      'images': images,
      'material': material,
      'weight': weight,
      'isFeatured': isFeatured,
      'isNewArrival': isNewArrival,
    };
  }
}
