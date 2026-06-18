import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static Future<bool?> showSuccess(
    String message, {
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<bool?> showError(
    String message, {
    Toast length = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: Colors.red.shade700,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<bool?> showWarning(
    String message, {
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: Colors.orange.shade700,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<bool?> showInfo(
    String message, {
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: Colors.blue.shade700,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void cancelAll() {
    Fluttertoast.cancel();
  }
}
