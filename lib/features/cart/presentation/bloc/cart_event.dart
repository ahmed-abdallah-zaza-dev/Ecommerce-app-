import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartRequested extends CartEvent {}

class AddProductToCartRequested extends CartEvent {
  final Product product;

  const AddProductToCartRequested(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveProductFromCartRequested extends CartEvent {
  final int productId;

  const RemoveProductFromCartRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantityRequested extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateQuantityRequested(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCartRequested extends CartEvent {
  const ClearCartRequested();
}
