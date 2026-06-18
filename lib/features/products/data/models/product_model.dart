import 'package:flutter_application_1/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.thumbnail,
    required super.images,
    required super.rating,
    required super.discountPercentage,
    super.brand,
    required super.stock,
    required super.reviews,
  });

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      thumbnail: product.thumbnail,
      images: product.images,
      rating: product.rating,
      discountPercentage: product.discountPercentage,
      brand: product.brand,
      stock: product.stock,
      reviews: product.reviews.map((r) {
        return r is ReviewModel ? r : ReviewModel(
          rating: r.rating,
          comment: r.comment,
          date: r.date,
          reviewerName: r.reviewerName,
          reviewerEmail: r.reviewerEmail,
        );
      }).toList(),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
      rating: (json['rating'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      brand: json['brand'],
      stock: json['stock'],
      reviews: (json['reviews'] as List)
          .map((review) => ReviewModel.fromJson(review))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
      'rating': rating,
      'discountPercentage': discountPercentage,
      'brand': brand,
      'stock': stock,
      'reviews': reviews
          .map((review) => (review as ReviewModel).toJson())
          .toList(),
    };
  }
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.rating,
    required super.comment,
    required super.date,
    required super.reviewerName,
    required super.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}
