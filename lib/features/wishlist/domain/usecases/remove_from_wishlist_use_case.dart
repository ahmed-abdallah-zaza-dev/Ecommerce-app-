import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/wishlist/domain/repositories/wishlist_repository.dart';

class RemoveFromWishlistUseCase extends BaseUseCase<void, SingleParam<int>> {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SingleParam<int> params) async {
    return await repository.removeFromWishlist(params.value);
  }
}
