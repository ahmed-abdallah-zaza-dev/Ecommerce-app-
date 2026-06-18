import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlistRequested extends WishlistEvent {}

class AddToWishlistRequested extends WishlistEvent {
  final Product product;

  const AddToWishlistRequested(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromWishlistRequested extends WishlistEvent {
  final int productId;

  const RemoveFromWishlistRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}
