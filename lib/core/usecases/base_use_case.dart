import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';

abstract class BaseUseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}

class SingleParam<T> {
  final T value;
  const SingleParam(this.value);
}

class PaginationParams {
  final int skip;
  final int limit;
  const PaginationParams({this.skip = 0, this.limit = 20});
}
