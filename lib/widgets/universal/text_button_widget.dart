import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/widgets/universal/mouse_effects.dart';

/// A custom TextButton widget
class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.isButtonClear = false,
    this.containsPadding = true,
  });

  // Button Properties
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isButtonClear;
  final bool containsPadding;

  @override
  Widget build(BuildContext context) {
    return MouseEffectsContainer(
      height: 40,
      opacity: isButtonClear
          ? 0.0
          : isPrimary
              ? 0.25
              : 0.1,
      opacityAdd: 0.15,
      opacitySubtract: isButtonClear
          ? 0.0
          : isPrimary
              ? 0.15
              : 0.05,
      color: isPrimary ? const Color(0xFF0080FF) : Colors.white,
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: containsPadding ? 38.0 : 10),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.asap(
              fontWeight: isPrimary ? FontWeight.w900 : FontWeight.w500,
              color: isPrimary ? const Color(0xFF0095FF) : themeDarkPrimaryText,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}