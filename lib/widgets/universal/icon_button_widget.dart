import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';

class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget({super.key, required this.icon});
  final IconData icon;

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
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
          height: 50,
          width: 40,
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: themeDarkPrimaryText.withOpacity((_isPressed ? 0.05 : _isHovered ? 0.25 : 0.1)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: HugeIcon(icon: widget.icon, color: themeDarkSecondaryText),
          ),
        ),
      ),
    );
  }
}
