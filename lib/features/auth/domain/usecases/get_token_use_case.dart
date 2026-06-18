import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/utils/retry_helper.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class GetTokenUseCase extends BaseUseCase<String?, NoParams> {
  final AuthRepository repository;

  GetTokenUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await RetryHelper.withRetry(() => repository.getToken());
  }
}
