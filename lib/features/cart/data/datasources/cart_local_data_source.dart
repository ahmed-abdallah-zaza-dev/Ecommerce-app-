import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/products/data/models/product_model.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';

abstract class CartLocalDataSource {
  Future<void> saveCart(List<CartItem> items);
  Future<List<CartItem>> getCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cartKey = 'CART_ITEMS';

  CartLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveCart(List<CartItem> items) async {
    final List<Map<String, dynamic>> jsonList = items.map((item) {
      final productModel = item.product is ProductModel
          ? item.product as ProductModel
          : ProductModel.fromEntity(item.product);
      return {
        'product': productModel.toJson(),
        'quantity': item.quantity,
      };
    }).toList();
    await sharedPreferences.setString(_cartKey, json.encode(jsonList));
  }

  @override
  Future<List<CartItem>> getCart() async {
    final String? jsonString = sharedPreferences.getString(_cartKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((itemJson) {
        return CartItem(
          product: ProductModel.fromJson(itemJson['product']),
          quantity: itemJson['quantity'],
        );
      }).toList();
    }
    return [];
  }
}
