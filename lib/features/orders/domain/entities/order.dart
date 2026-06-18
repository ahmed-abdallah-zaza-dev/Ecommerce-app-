import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
  });

  @override
  List<Object?> get props => [id, items, totalAmount, date];
}
