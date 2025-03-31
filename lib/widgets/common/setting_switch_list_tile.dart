import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_provider_classes.dart';

import 'package:spark/app_constants.dart';

class CustomSwitchListTile extends ConsumerWidget {
  const CustomSwitchListTile({
    super.key,
    required this.title,
    required this.description,
    required this.boolProvider,
    this.sharedPreferencesKey,
    this.disabled = false,
  });

  final String title;
  final String description;
  final StateNotifierProvider<TypedProvider<bool>, bool> boolProvider;
  final String? sharedPreferencesKey;
  final bool disabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boolWatcher = ref.watch(boolProvider);
    final boolReader = ref.watch(boolProvider.notifier);

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: AbsorbPointer(
        absorbing: disabled,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: GoogleFonts.asap(
                      color: themeDarkSecondaryText,
                      fontSize: 16,
                      height: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.asap(
                      color: themeDarkDimText,
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 35,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (sharedPreferencesKey != null) {
                          ///Save Setting
                          boolReader.saveState(
                              false, sharedPreferencesKey!, ref);
                        } else {
                          ///Update Setting
                          boolReader.updateState(false);
                        }
                      },
                      child: AnimatedContainer(
                        height: double.infinity,
                        width: !boolWatcher ? 38 : 30,
                        decoration: BoxDecoration(
                          color: boolWatcher ? Colors.red.withValues(alpha: 0.25) : Colors.red,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(6),
                            right: Radius.circular(3),
                          ),
                        ),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.fastOutSlowIn,
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCancel01,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        if (sharedPreferencesKey != null) {
                          ///Save Setting
                          boolReader.saveState(
                              true, sharedPreferencesKey!, ref);
                        } else {
                          ///Update Setting
                          boolReader.updateState(true);
                        }
                      },
                      child: AnimatedContainer(
                        height: double.infinity,
                        width: boolWatcher ? 38 : 30,
                        decoration: BoxDecoration(
                          color: boolWatcher ? Colors.green : Colors.green.withValues(alpha: 0.25),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(3),
                            right: Radius.circular(6),
                          ),
                        ),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.fastOutSlowIn,
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedTick02,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
