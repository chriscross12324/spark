import 'package:flutter/material.dart';
import 'package:spark/app_constants.dart';

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) pageBuilder,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: pageBuilder,
    barrierColor: themeDarkDeepBackground.withValues(alpha: 0.35),
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
