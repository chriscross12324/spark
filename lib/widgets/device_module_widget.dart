import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_constants.dart';
import 'common/mouse_effects.dart';

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

class DeviceMemberModule extends StatelessWidget {
  const DeviceMemberModule({
    super.key,
    required this.member,
  });

  final MapEntry<String, dynamic> member;

  @override
  Widget build(BuildContext context) {
    return MouseEffectsContainer(
      height: 60,
      onPressed: () {  },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 75,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  member.key,
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
                    "${member.value['lastName']}",
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
                  color: member.value['status'] == 'Online'
                      ? Colors.green
                      : member.value['status'] == 'Offline'
                          ? Colors.white.withOpacity(0.35)
                          : Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
