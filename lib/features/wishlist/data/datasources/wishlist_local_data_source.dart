import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/products/data/models/product_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<ProductModel>> getWishlist();
  Future<void> addToWishlist(ProductModel product);
  Future<void> removeFromWishlist(int productId);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _wishlistKey = 'CACHED_WISHLIST';

  WishlistLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ProductModel>> getWishlist() async {
    final jsonString = sharedPreferences.getString(_wishlistKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addToWishlist(ProductModel product) async {
    final wishlist = await getWishlist();
    if (!wishlist.any((e) => e.id == product.id)) {
      wishlist.add(product);
      await _saveWishlist(wishlist);
    }
  }

  @override
  Future<void> removeFromWishlist(int productId) async {
    final wishlist = await getWishlist();
    wishlist.removeWhere((e) => e.id == productId);
    await _saveWishlist(wishlist);
  }

  Future<void> _saveWishlist(List<ProductModel> wishlist) async {
    final jsonString = json.encode(wishlist.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_wishlistKey, jsonString);
  }
}
