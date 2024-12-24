import 'package:flutter/material.dart';

class MouseEffectsContainer extends StatefulWidget {
  const MouseEffectsContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.duration = const Duration(milliseconds: 100),
    this.opacity = 0.1,
    this.opacityAdd = 0.05,
    this.opacitySubtract = 0.02,
    this.borderRadius,
    this.color = Colors.white,
    required this.onPressed,
  });

  final Widget? child;
  final double? height;
  final double? width;
  final Duration duration;
  final double opacity;
  final double opacityAdd;
  final double opacitySubtract;
  final BorderRadiusGeometry? borderRadius;
  final Color color;
  final VoidCallback onPressed;

  @override
  State<MouseEffectsContainer> createState() => _MouseEffectsContainerState();
}

class _MouseEffectsContainerState extends State<MouseEffectsContainer> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
            widget.onPressed();
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: AnimatedContainer(
          height: widget.height,
          width: widget.width,
          duration: widget.duration,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(
              _isPressed
                  ? (widget.opacity - widget.opacitySubtract)
                  : _isHovered
                      ? (widget.opacity + widget.opacityAdd)
                      : widget.opacity,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
