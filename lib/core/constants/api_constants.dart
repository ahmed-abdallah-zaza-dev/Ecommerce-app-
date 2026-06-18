import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://dummyjson.com';

  // Products endpoints
  static const String products = '/products';
  static const String productDetails = '/products';
  static const String searchProducts = '/products/search';
  static const String categories = '/products/categories';
  static const String productsByCategory = '/products/category';

  // User endpoints
  static const String users = '/users';
}
