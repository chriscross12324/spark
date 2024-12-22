import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';

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
          border: Border.all(width: 2, color: Colors.white.withOpacity(0.15))),
      child: Row(
        children: List.generate(widget.options.length, (index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: SegmentedControlButton(
              isSelected: isSelected,
              widget: widget,
              buttonText: widget.options[index],
            ),
          );
        }),
      ),
    );
  }
}

class SegmentedControlButton extends StatefulWidget {
  const SegmentedControlButton({
    super.key,
    required this.isSelected,
    required this.widget,
    required this.buttonText,
  });

  final bool isSelected;
  final SegmentedControl widget;
  final String buttonText;

  @override
  State<SegmentedControlButton> createState() => _SegmentedControlButtonState();
}

class _SegmentedControlButtonState extends State<SegmentedControlButton> {
  bool _isHovered = false;

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
      child: AnimatedContainer(
        height: 36,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? themeDarkForeground
              : _isHovered
                  ? themeDarkForeground.withOpacity(0.25)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
            color: widget.isSelected
                ? themeDarkDimText
                : Colors.transparent,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: AnimatedDefaultTextStyle(
            style: GoogleFonts.asap(
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  widget.isSelected ? themeDarkPrimaryText : themeDarkDimText,
              fontSize: 14,
            ),
            duration: const Duration(milliseconds: 200),
            child: Text(widget.buttonText),
          ),
        ),
      ),
    );
  }
}
