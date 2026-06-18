import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded(this.items);

  double get totalPrice => items.fold(
    0,
    (total, item) => total + (item.product.price * item.quantity),
  );

  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
