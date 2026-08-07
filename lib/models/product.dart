class Rating {
  final double rate;
  final int count;

  const Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(dynamic json) {
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      return Rating(
        rate: (map['rate'] as num?)?.toDouble() ?? 0.0,
        count: (map['count'] as num?)?.toInt() ?? 0,
      );
    }
    return const Rating(rate: 0.0, count: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(dynamic json) {
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      return Product(
        id: (map['id'] as num?)?.toInt() ?? 0,
        title: map['title'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        description: map['description'] as String? ?? '',
        category: map['category'] as String? ?? '',
        image: map['image'] as String? ?? '',
        rating: map['rating'] != null ? Rating.fromJson(map['rating']) : const Rating(rate: 0.0, count: 0),
      );
    }
    return const Product(
      id: 0,
      title: '',
      price: 0.0,
      description: '',
      category: '',
      image: '',
      rating: Rating(rate: 0.0, count: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }
}
