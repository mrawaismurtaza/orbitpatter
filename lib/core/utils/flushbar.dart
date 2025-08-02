import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class OrbitFlushbar {
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    Duration duration = const Duration(seconds: 2),
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    Flushbar(
      message: message,
      icon: icon != null
          ? Icon(icon, size: 20.0, color: colorScheme.onPrimary)
          : null,
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: backgroundColor ?? colorScheme.primary,
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
  }

  static void success(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    show(
      context: context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: colorScheme.primary, // or tertiary
    );
  }

  static void error(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    show(
      context: context,
      message: message,
      icon: Icons.error,
      backgroundColor: colorScheme.error,
    );
  }

  static void info(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    show(
      context: context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: colorScheme.surfaceVariant,
    );
  }
}
