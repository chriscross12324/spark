import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_constants.dart';

class DeviceCrewHeader extends StatelessWidget {
  const DeviceCrewHeader({super.key, required this.crew});

  final MapEntry<String, dynamic> crew;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          crew.key,
          style: GoogleFonts.asap(
            fontWeight: FontWeight.bold,
            color: themeDarkPrimaryText,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              children: [
                AnimatedContainer(
                  height: 55,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity((_isPressed
                        ? 0.08
                        : _isHovered
                            ? 0.15
                            : 0.1)),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  duration: const Duration(milliseconds: 100),
                  child: Center(
                    child: Text(
                      widget.member.key,
                      style: GoogleFonts.asap(
                        fontWeight: FontWeight.w900,
                        color: themeDarkDimText,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.member.value['lastName']}",
                        style: GoogleFonts.asap(
                          fontWeight: FontWeight.bold,
                          color: themeDarkDimText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: widget.member.value['status'] == 'Online' ? Colors.green : widget.member.value['status'] == 'Offline' ? Colors.white.withOpacity(0.35) : Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
