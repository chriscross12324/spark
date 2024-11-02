import 'dart:math';

import 'package:flutter/material.dart';

import '../app_constants.dart';

class DeviceCrewHeader extends StatelessWidget {
  const DeviceCrewHeader({super.key, required this.crew, required this.expanded});

  final MapEntry<String, dynamic> crew;
  final bool expanded;

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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeDarkPrimaryText,
                  fontSize: 24,
                ),
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
                  style: const TextStyle(
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

class DeviceMemberModule extends StatelessWidget {
  const DeviceMemberModule({super.key, required this.member, required this.expanded});

  final MapEntry<String, dynamic> member;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool expandedView = constraints.maxWidth >= 300;

        return Container(
          height: 65,
          decoration: BoxDecoration(
            color: themeDarkBackground,
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    height: 55,
                    width: 65,
                    decoration: BoxDecoration(
                      color: themeDarkForeground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: themeDarkDimText,
                          fontSize: 28,
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
                          member.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeDarkPrimaryText,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${member.value['lastName']}",
                          style: const TextStyle(
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
        );
      },
    );
  }
}
