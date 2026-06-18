import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_application_1/features/cart/data/datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CartItem>>> getCart() async {
    try {
      final items = await localDataSource.getCart();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCart(List<CartItem> items) async {
    try {
      await localDataSource.saveCart(items);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
