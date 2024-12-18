import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';

class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget(
      {super.key,
      required this.icon,
      this.iconSize = 24,
      required this.buttonFunction,
        this.canHold = false,
      this.isClear = false,
      this.height = 50,
      this.width = 40,
      this.borderRadius = 5,
      this.iconColour = themeDarkSecondaryText,
      this.backgroundTint = themeDarkPrimaryText});

  final IconData icon;
  final double iconSize;
  final Color iconColour;
  final Function buttonFunction;
  final bool canHold;
  final bool isClear;

  final double height;
  final double width;
  final double borderRadius;
  final Color backgroundTint;

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isHolding = false;

  Timer? _holdTimer = null;
  int _holdDuration = 150;

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isPressed = true;
        });
        _startHolding();
      },
      onPointerUp: (_) {
        setState(() {
          _isPressed = false;
          widget.buttonFunction();
        });
        _stopHolding();
      },
      onPointerCancel: (_) {
        setState(() {
          _isPressed = false;
        });
        _stopHolding();
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
          height: widget.height,
          width: widget.width,
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: widget.backgroundTint.withOpacity((_isPressed
                ? 0.05
                : _isHovered
                    ? 0.25
                    : widget.isClear ? 0 : 0.1)),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Center(
            child: HugeIcon(
              icon: widget.icon,
              color: widget.iconColour,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }

  void _startHolding() {
    if (!widget.canHold) return;

    _isHolding = true;
    //widget.buttonFunction();
    _holdTimer = Timer.periodic(Duration(milliseconds: _holdDuration), (timer) {
      widget.buttonFunction();
    });
  }

  void _stopHolding() {
    if (!widget.canHold) return;

    _isHolding = false;
    _holdTimer!.cancel();
    setState(() {
      _holdDuration = 150;
    });
  }
}
