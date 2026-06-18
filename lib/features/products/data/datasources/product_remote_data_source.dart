import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/core/network/dio_client.dart';
import 'package:flutter_application_1/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int skip = 0, int limit = 20});
  Future<ProductModel> getProductDetails(int id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts({int skip = 0, int limit = 20}) async {
    try {
      final response = await client.get(
        ApiConstants.products,
        queryParameters: {'skip': skip, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final List<dynamic> productsData = response.data['products'];
        return productsData.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    try {
      final response = await client.get('${ApiConstants.products}/$id');
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await client.get(
        ApiConstants.searchProducts,
        queryParameters: {'q': query},
      );
      if (response.statusCode == 200) {
        final List<dynamic> productsData = response.data['products'];
        return productsData.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await client.get(
        '${ApiConstants.productsByCategory}/${category.toLowerCase()}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> productsData = response.data['products'];
        return productsData.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
