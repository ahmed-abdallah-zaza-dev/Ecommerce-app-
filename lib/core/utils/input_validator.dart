import 'package:flutter_application_1/l10n/app_localizations.dart';

class InputValidator {
  static String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(value)) {
      return l10n.emailInvalid;
    }

    return null;
  }

  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }

    if (value.length < 6) {
      return l10n.passwordTooShort;
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }

    if (value != password) {
      return l10n.passwordsDontMatch;
    }

    return null;
  }

  static String? validatePhone(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.phoneRequired;
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\s'), ''))) {
      return l10n.phoneInvalid;
    }

    return null;
  }

  static String? validateName(
    String? value,
    String fieldName,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired(fieldName);
    }

    if (value.length < 2) {
      return l10n.fieldTooShort(fieldName, 2);
    }

    return null;
  }

  static String? validateNotEmpty(
    String? value,
    String fieldName,
    AppLocalizations l10n,
  ) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldRequired(fieldName);
    }
    return null;
  }
}

class ValidationResult {
  final bool isValid;
  final String? error;

  ValidationResult({required this.isValid, this.error});

  static ValidationResult success() => ValidationResult(isValid: true);

  static ValidationResult failure(String error) =>
      ValidationResult(isValid: false, error: error);
}

class FormValidator {
  final Map<String, String?> _errors = {};

  String? getError(String field) => _errors[field];

  bool validateField(
    String field,
    String? value,
    String? Function(String?) validator,
  ) {
    _errors[field] = validator(value);
    return _errors[field] == null;
  }

  bool validateAll(
    Map<String, String?> values,
    Map<String, String? Function(String?)> validators,
  ) {
    _errors.clear();
    for (final entry in validators.entries) {
      _errors[entry.key] = entry.value(values[entry.key]);
    }
    return !_errors.values.any((e) => e != null);
  }

  Map<String, String?> get errors => Map.unmodifiable(_errors);

  bool get isValid => !_errors.values.any((e) => e != null);
}
