import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/features/wishlist/domain/repositories/wishlist_repository.dart';

class GetWishlistUseCase extends BaseUseCase<List<Product>, NoParams> {
  final WishlistRepository repository;

  GetWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getWishlist();
  }
}
