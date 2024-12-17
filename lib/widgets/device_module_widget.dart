import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_constants.dart';

class DeviceCrewHeader extends StatelessWidget {
  const DeviceCrewHeader({super.key, required this.crew});

  final MapEntry<String, dynamic> crew;

  @override
  Widget build(BuildContext context) {
    String crewInitials = crew.key.split(' ').map((word) => word[0]).join();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool expandedView = constraints.maxWidth >= 300;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: expandedView
              ? Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: themeDarkAccentColourMain,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      crew.key,
                      style: GoogleFonts.varelaRound(
                        fontWeight: FontWeight.bold,
                        color: themeDarkPrimaryText,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: themeDarkAccentColourMain,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        crewInitials,
                        style: GoogleFonts.varelaRound(
                          fontWeight: FontWeight.bold,
                          color: themeDarkSecondaryText,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class DeviceMemberModule extends StatefulWidget {
  const DeviceMemberModule({super.key, required this.member});

  final MapEntry<String, dynamic> member;

  @override
  State<DeviceMemberModule> createState() => _DeviceMemberModuleState();
}

class _DeviceMemberModuleState extends State<DeviceMemberModule> {
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
          //widget.buttonFunction();
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
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity((_isPressed
                ? 0.08
                : _isHovered
                    ? 0.15
                    : 0.1)),
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(milliseconds: 100),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: AnimatedContainer(
                    height: 55,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity((_isPressed
                          ? 0.08
                          : _isHovered
                              ? 0.15
                              : 0.1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: Text(
                        widget.member.key,
                        style: GoogleFonts.varelaRound(
                          fontWeight: FontWeight.w900,
                          color: themeDarkDimText,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.member.value['lastName']}",
                          style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.bold,
                            color: themeDarkDimText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
