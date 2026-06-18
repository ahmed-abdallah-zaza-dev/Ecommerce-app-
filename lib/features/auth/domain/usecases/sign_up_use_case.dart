import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/core/utils/retry_helper.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/user.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase extends BaseUseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await RetryHelper.withRetry(
      () => repository.signUp(params.email, params.password),
    );
  }
}

class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});
}
