import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<Product>>> getWishlist();
  Future<Either<Failure, void>> addToWishlist(Product product);
  Future<Either<Failure, void>> removeFromWishlist(int productId);
}
