import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/features/wishlist/domain/repositories/wishlist_repository.dart';

class AddToWishlistUseCase extends BaseUseCase<void, SingleParam<Product>> {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SingleParam<Product> params) async {
    return await repository.addToWishlist(params.value);
  }
}
