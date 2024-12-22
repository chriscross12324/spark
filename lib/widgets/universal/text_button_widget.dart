import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';

/// A custom TextButton widget
class TextButtonWidget extends StatefulWidget {
  const TextButtonWidget(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isPrimary = false,
      this.isButtonClear = false,
      this.containsPadding = true});

  // Button Properties
  final String text;
  final Function onPressed;
  final bool isPrimary;
  final bool isButtonClear;
  final bool containsPadding;

  @override
  State<TextButtonWidget> createState() => _TextButtonWidgetState();
}

class _TextButtonWidgetState extends State<TextButtonWidget> {
  bool _isButtonHovered = false;
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isButtonPressed = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _isButtonPressed = false;
          widget.onPressed();
        });
      },
      onPointerCancel: (_) {
        setState(() {
          _isButtonPressed = false;
        });
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isButtonHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isButtonHovered = false;
          });
        },
        child: AnimatedContainer(
          height: 40,
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (const Color(0xFF0080FF).withOpacity((_isButtonPressed
                    ? 0.1
                    : _isButtonHovered
                        ? 0.45
                        : widget.isButtonClear
                            ? 0
                            : 0.25)))
                : (themeDarkPrimaryText.withOpacity(
                    (_isButtonPressed
                        ? 0.05
                        : _isButtonHovered
                            ? 0.25
                            : widget.isButtonClear
                                ? 0
                                : 0.1),
                  )),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.containsPadding ? 38.0 : 10),
            child: Center(
              child: Text(
                widget.text,
                style: GoogleFonts.asap(
                  fontWeight: widget.isPrimary ? FontWeight.w900 : FontWeight.w500,
                  color: widget.isPrimary
                      ? const Color(0xFF0095FF)
                      : themeDarkPrimaryText,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
