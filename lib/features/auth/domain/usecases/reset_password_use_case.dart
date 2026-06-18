import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/utils/retry_helper.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase extends BaseUseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await RetryHelper.withRetry(
      () => repository.resetPassword(params.email),
    );
  }
}

class ResetPasswordParams {
  final String email;
  const ResetPasswordParams({required this.email});
}
