import 'dart:async';
import 'package:dartz/dartz.dart';

class RetryHelper {
  static Future<T> withRetry<T>(
    Future<T> Function() function, {
    int maxRetries = 3,
    Duration delay = const Duration(milliseconds: 500),
    bool Function(Exception)? shouldRetry,
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      try {
        return await function();
      } on Exception catch (e) {
        lastException = e;
        attempts++;

        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }

        if (attempts < maxRetries) {
          await Future.delayed(delay * attempts);
        }
      }
    }

    throw lastException!;
  }
}

extension EitherExtension<L, R> on Either<L, R> {
  R getOrThrow() {
    return fold(
      (l) => throw l is Exception ? l : Exception(l.toString()),
      (r) => r,
    );
  }

  R? getOrNull() {
    return fold((_) => null, (r) => r);
  }

  R getOrElse(R Function(L l) fallback) {
    return fold(fallback, (r) => r);
  }
}

// Result wrapper for handling success/failure
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({this.data, this.error, required this.isSuccess});

  factory Result.success(T data) => Result._(data: data, isSuccess: true);
  factory Result.failure(String error) =>
      Result._(error: error, isSuccess: false);

  bool get isFailure => !isSuccess;

  T? getDataOrNull() => data;
  String? getErrorOrNull() => error;

  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    }
    return failure(error as String);
  }
}

// Extension for easier Result usage
extension ResultExtension<T> on Future<T> {
  Future<Result<T>> asResult() async {
    try {
      final data = await this;
      return Result.success(data);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
