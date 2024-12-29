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
    this.border,
    this.color = Colors.white,
    this.spotlightColor = Colors.white,
    this.spotlightOpacity = 0.1,
    this.spotlightRadius = 50,
    required this.onPressed,
    this.ignoreInput = false,
  });

  final Widget? child;
  final double? height;
  final double? width;
  final Duration duration;
  final double opacity;
  final double opacityAdd;
  final double opacitySubtract;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Color color;
  final Color spotlightColor;
  final double spotlightOpacity;
  final double spotlightRadius;
  final VoidCallback onPressed;
  final bool ignoreInput;

  @override
  State<MouseEffectsContainer> createState() => _MouseEffectsContainerState();
}

class _MouseEffectsContainerState extends State<MouseEffectsContainer> {
  bool _isHovered = false;
  bool _isPressed = false;
  Offset _cursorPosition = const Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          _isHovered = true;
        });
      },
      onHover: (event) {
        setState(() {
          _cursorPosition = event.localPosition;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: IgnorePointer(
        ignoring: widget.ignoreInput,
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
              border: widget.border,
            ),
            child: ClipRRect(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: CustomPaint(
                        painter: SpotlightPainter(
                          cursorPosition: _cursorPosition,
                          radius: widget.spotlightRadius,
                          colour: widget.spotlightColor,
                          opacity: widget.spotlightOpacity,
                        ),
                      ),
                    ),
                  ),
                  widget.child!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SpotlightPainter extends CustomPainter {
  final Offset cursorPosition;
  final double radius;
  final Color colour;
  final double opacity;

  SpotlightPainter({
    required this.cursorPosition,
    required this.radius,
    required this.colour,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = RadialGradient(colors: [
      colour.withOpacity(opacity),
      colour.withOpacity(0.0),
    ], stops: const [
      0.15,
      1.0
    ]);

    final rect = Rect.fromCircle(center: cursorPosition, radius: radius);
    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawCircle(cursorPosition, radius, paint);
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) {
    return oldDelegate.cursorPosition != cursorPosition ||
        oldDelegate.radius != radius ||
        oldDelegate.colour != colour ||
        oldDelegate.opacity != opacity;
  }
}
