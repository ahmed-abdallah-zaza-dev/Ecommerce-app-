import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/entities/user.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/get_token_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/get_current_user_use_case.dart';

class FakeAuthRepository implements AuthRepository {
  String? cachedToken = 'cached_token_123';
  User? currentUser = const User(
    id: 'uid_123',
    email: 'test@example.com',
    username: 'testuser',
    token: 'token_123',
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (email == 'test@example.com' && password == 'password123') {
      return Right(currentUser!);
    } else {
      return const Left(ServerFailure('Invalid credentials'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password) async {
    return Right(currentUser!);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    cachedToken = null;
    currentUser = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    return Right(cachedToken);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return Right(currentUser);
  }
}

void main() {
  late FakeAuthRepository fakeRepository;
  late LoginUseCase loginUseCase;
  late GetTokenUseCase getTokenUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;

  setUp(() {
    fakeRepository = FakeAuthRepository();
    loginUseCase = LoginUseCase(fakeRepository);
    getTokenUseCase = GetTokenUseCase(fakeRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(fakeRepository);
  });

  group('Auth UseCases Tests', () {
    test('LoginUseCase should return User on valid credentials', () async {
      final result = await loginUseCase(
        const LoginParams(email: 'test@example.com', password: 'password123'),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('should succeed'),
        (user) {
          expect(user.id, equals('uid_123'));
          expect(user.email, equals('test@example.com'));
        },
      );
    });

    test('LoginUseCase should return Failure on invalid credentials', () async {
      final result = await loginUseCase(
        const LoginParams(email: 'wrong@example.com', password: 'wrongpassword'),
      );

      expect(result.isLeft(), isTrue);
    });

    test('GetTokenUseCase should return cached token', () async {
      final result = await getTokenUseCase(const NoParams());

      expect(result, equals(const Right('cached_token_123')));
    });

    test('GetCurrentUserUseCase should return currentUser info', () async {
      final result = await getCurrentUserUseCase(const NoParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('should succeed'),
        (user) {
          expect(user, isNotNull);
          expect(user!.username, equals('testuser'));
        },
      );
    });
  });
}
