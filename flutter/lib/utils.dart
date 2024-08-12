import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class Utils {
  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
  }) {
    _showSnackBar(
      context,
      message: message,
      color: Theme.of(context).primaryColor,
    );
  }

  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
  }) {
    _showSnackBar(
      context,
      message: message,
      color: Theme.of(context).colorScheme.error,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }

  static void setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('MyDemoThemeName', theme);
  }

  static Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('MyDemoThemeName') ?? 'light';
  }
}
