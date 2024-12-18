import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';

class TextButtonWidget extends StatefulWidget {
  const TextButtonWidget(
      {super.key,
      required this.text,
      required this.buttonFunction,
      this.isPrimary = false});

  final String text;
  final Function buttonFunction;
  final bool isPrimary;

  @override
  State<TextButtonWidget> createState() => _TextButtonWidgetState();
}

class _TextButtonWidgetState extends State<TextButtonWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _isPressed = false;
          widget.buttonFunction();
        });
      },
      onPointerCancel: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: AnimatedContainer(
          height: 40,
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (const Color(0xFF0080FF).withOpacity((_isPressed
                    ? 0.1
                    : _isHovered
                        ? 0.45
                        : 0.25)))
                : (themeDarkPrimaryText.withOpacity((_isPressed
                    ? 0.05
                    : _isHovered
                        ? 0.25
                        : 0.1))),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38.0),
            child: Center(
              child: Text(
                widget.text,
                style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.w900,
                  color: widget.isPrimary ? const Color(0xFF0095FF) : themeDarkPrimaryText,
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
