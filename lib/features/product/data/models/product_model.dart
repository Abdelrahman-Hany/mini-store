import 'package:mini_store/core/common/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,

      rating: RatingModel.fromMap(map['rating'] as Map<String, dynamic>),
    );
  }
}

class RatingModel extends Rating {
  RatingModel({required super.rate, required super.count});

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      rate: (map['rate'] as num).toDouble(),
      count: map['count'] as int,
    );
  }
}