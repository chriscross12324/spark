import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';

/// A custom IconButton widget that supports various interactions (press and hold)
class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget(
      {super.key,
      required this.iconData,
      this.iconSize = 24,
      this.iconColour = themeDarkSecondaryText,
      required this.onPressed,
      this.isHoldEnabled = false,
      this.isButtonClear = false,
      this.height = 50,
      this.width = 40,
      this.borderRadius = 10,
      this.backgroundColour = themeDarkPrimaryText});

  // Button Properties
  final IconData iconData;
  final double iconSize;
  final Color iconColour;
  final Function onPressed;
  final bool isHoldEnabled;
  final bool isButtonClear;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColour;

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  bool _isButtonHovered = false;
  bool _isButtonPressed = false;

  Timer? _holdTimer;
  final int _holdInterval = 150;

  // Clean up the hold timer when the widget is disposed
  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  // Start holding functionality
  void _startHolding() {
    if (!widget.isHoldEnabled) return;

    _holdTimer = Timer.periodic(Duration(milliseconds: _holdInterval), (_) {
      widget.onPressed();
    });
  }

  // Stop holding functionality
  void _stopHolding() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  // Main widget building logic
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isButtonPressed = true;
        });
        _startHolding();
      },
      onPointerUp: (_) {
        setState(() {
          _isButtonPressed = false;
          widget.onPressed();
        });
        _stopHolding();
      },
      onPointerCancel: (_) {
        setState(() {
          _isButtonPressed = false;
        });
        _stopHolding();
      },
      child: MouseRegion(
        onEnter: (_) => _setButtonHovered(true),
        onExit: (_) => _setButtonHovered(false),
        child: _IconButtonBackground(
          isPressed: _isButtonPressed,
          isHovered: _isButtonHovered,
          isButtonClear: widget.isButtonClear,
          height: widget.height,
          width: widget.width,
          borderRadius: widget.borderRadius,
          backgroundColor: widget.backgroundColour,
          icon: widget.iconData,
          iconColour: widget.iconColour,
          iconSize: widget.iconSize,
        ),
      ),
    );
  }

  void _setButtonHovered(bool isHovered) {
    setState(() {
      _isButtonHovered = isHovered;
    });
  }
}

/// A separate widget for managing the background and icon display
class _IconButtonBackground extends StatelessWidget {
  const _IconButtonBackground(
      {required this.isPressed,
      required this.isHovered,
      required this.isButtonClear,
      required this.height,
      required this.width,
      required this.borderRadius,
      required this.backgroundColor,
      required this.icon,
      required this.iconColour,
      required this.iconSize});

  final bool isPressed;
  final bool isHovered;
  final bool isButtonClear;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColour;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      width: width,
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(
          isPressed
              ? 0.05
              : isHovered
                  ? 0.25
                  : isButtonClear
                      ? 0
                      : 0.1,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: HugeIcon(
          icon: icon,
          color: iconColour,
          size: iconSize,
        ),
      ),
    );
  }
}
