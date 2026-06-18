import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnail;
  final List<String> images;
  final double rating;
  final double discountPercentage;
  final String? brand;
  final int stock;
  final List<Review> reviews;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.rating,
    required this.discountPercentage,
    this.brand,
    required this.stock,
    required this.reviews,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    thumbnail,
    images,
    rating,
    discountPercentage,
    brand,
    stock,
    reviews,
  ];
}

class Review extends Equatable {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  const Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  @override
  List<Object?> get props => [
    rating,
    comment,
    date,
    reviewerName,
    reviewerEmail,
  ];
}
