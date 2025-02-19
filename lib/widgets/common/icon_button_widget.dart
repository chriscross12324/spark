import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'mouse_effects.dart';

/// A custom IconButton widget that supports various interactions (press and hold)
class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    super.key,
    this.height = 50,
    this.width = 40,
    this.isIdleClear = false,
    this.borderRadius,
    this.colour = Colors.white,
    required this.icon,
    this.iconColour = Colors.white,
    this.iconSize = 24,
    required this.onPressed,
  });

  // Button Properties
  final double height;
  final double width;
  final bool isIdleClear;
  final BorderRadiusGeometry? borderRadius;
  final Color colour;
  final IconData icon;
  final Color iconColour;
  final double iconSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: MouseEffectsContainer(
        height: height,
        width: width,
        color: colour,
        opacity: isIdleClear ? 0.0 : 0.1,
        opacityAdd: isIdleClear ? 0.2 : 0.1,
        opacitySubtract: isIdleClear ? -0.05 : 0.05,
        spotlightRadius: 35,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        onPressed: onPressed,
        child: Center(
          child: HugeIcon(
            icon: icon,
            color: iconColour,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
