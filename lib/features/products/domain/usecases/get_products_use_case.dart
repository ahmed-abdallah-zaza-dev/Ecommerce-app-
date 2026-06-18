import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase extends BaseUseCase<List<Product>, PaginationParams> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(PaginationParams params) async {
    return await repository.getProducts(skip: params.skip, limit: params.limit);
  }
}
