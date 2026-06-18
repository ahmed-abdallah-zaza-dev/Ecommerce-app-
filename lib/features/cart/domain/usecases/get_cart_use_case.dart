import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/utils/retry_helper.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase extends BaseUseCase<List<CartItem>, NoParams> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) async {
    return await RetryHelper.withRetry(() => repository.getCart());
  }
}
