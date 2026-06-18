import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/utils/retry_helper.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase
    extends BaseUseCase<List<Product>, SingleParam<String>> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
    SingleParam<String> params,
  ) async {
    return await RetryHelper.withRetry(
      () => repository.searchProducts(params.value),
    );
  }
}
