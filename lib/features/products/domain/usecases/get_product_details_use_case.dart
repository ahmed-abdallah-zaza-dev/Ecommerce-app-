import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/utils/retry_helper.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/features/products/domain/repositories/product_repository.dart';

class GetProductDetailsUseCase extends BaseUseCase<Product, SingleParam<int>> {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(SingleParam<int> params) async {
    return await RetryHelper.withRetry(
      () => repository.getProductDetails(params.value),
    );
  }
}
