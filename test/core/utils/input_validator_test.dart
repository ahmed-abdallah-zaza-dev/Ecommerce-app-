import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/utils/input_validator.dart';
import 'package:flutter_application_1/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('InputValidator - Email Validation', () {
    test('should return error if email is empty', () {
      final result = InputValidator.validateEmail('', l10n);
      expect(result, equals(l10n.emailRequired));
    });

    test('should return error if email is invalid', () {
      final result = InputValidator.validateEmail('invalid_email', l10n);
      expect(result, equals(l10n.emailInvalid));
    });

    test('should return null if email is valid', () {
      final result = InputValidator.validateEmail('test@example.com', l10n);
      expect(result, isNull);
    });
  });

  group('InputValidator - Password Validation', () {
    test('should return error if password is empty', () {
      final result = InputValidator.validatePassword('', l10n);
      expect(result, equals(l10n.passwordRequired));
    });

    test('should return error if password is too short', () {
      final result = InputValidator.validatePassword('12345', l10n);
      expect(result, equals(l10n.passwordTooShort));
    });

    test('should return null if password is valid', () {
      final result = InputValidator.validatePassword('123456', l10n);
      expect(result, isNull);
    });
  });

  group('InputValidator - Confirm Password Validation', () {
    test('should return error if confirm password is empty', () {
      final result = InputValidator.validateConfirmPassword('', 'password', l10n);
      expect(result, equals(l10n.confirmPasswordRequired));
    });

    test('should return error if passwords do not match', () {
      final result = InputValidator.validateConfirmPassword('pass1', 'pass2', l10n);
      expect(result, equals(l10n.passwordsDontMatch));
    });

    test('should return null if passwords match', () {
      final result = InputValidator.validateConfirmPassword('password', 'password', l10n);
      expect(result, isNull);
    });
  });

  group('InputValidator - Phone Validation', () {
    test('should return error if phone is empty', () {
      final result = InputValidator.validatePhone('', l10n);
      expect(result, equals(l10n.phoneRequired));
    });

    test('should return error if phone format is invalid', () {
      final result = InputValidator.validatePhone('1234', l10n);
      expect(result, equals(l10n.phoneInvalid));
    });

    test('should return null if phone is valid', () {
      final result = InputValidator.validatePhone('+12345678901', l10n);
      expect(result, isNull);
    });
  });
}
