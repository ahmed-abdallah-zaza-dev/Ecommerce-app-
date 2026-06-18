import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_application_1/features/products/data/datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final remoteProducts = await remoteDataSource.getProducts(
        skip: skip,
        limit: limit,
      );
      return Right(remoteProducts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch products'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(int id) async {
    try {
      final product = await remoteDataSource.getProductDetails(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to fetch product details'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to search products'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(category);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch products by category'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
