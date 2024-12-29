import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';

import 'mouse_effects.dart';

class SegmentedControl extends StatefulWidget {
  const SegmentedControl({super.key, required this.options});

  final List<String> options;

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: List.generate(widget.options.length, (index) {
            final isSelected = index == selectedIndex;

            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: MouseEffectsContainer(
                height: 36,
                opacity: 0.0,
                opacityAdd: 0.1,
                opacitySubtract: -0.05,
                borderRadius: BorderRadius.circular(6),
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  height: 36,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color:
                    isSelected ? themeDarkForeground : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      width: 2,
                      color:
                      isSelected ? themeDarkDimText : Colors.transparent,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      style: GoogleFonts.asap(
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? themeDarkPrimaryText
                            : themeDarkDimText,
                        fontSize: 14,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: Text(widget.options[index]),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}