import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/utils/retry_helper.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class SaveCartUseCase extends BaseUseCase<void, SingleParam<List<CartItem>>> {
  final CartRepository repository;

  SaveCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SingleParam<List<CartItem>> params) async {
    return await RetryHelper.withRetry(() => repository.saveCart(params.value));
  }
}
