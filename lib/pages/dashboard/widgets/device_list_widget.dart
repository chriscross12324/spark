import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/app_providers.dart';
import 'package:spark/models/crew.dart';
import 'package:spark/providers/dashboard_provider.dart';
import 'package:spark/utils/web_socket_manager.dart';
import 'package:spark/widgets/common/mouse_effects.dart';

import '../../../models/device.dart';

class DeviceListWidget extends ConsumerWidget {
  const DeviceListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDeviceGroups = ref.watch(groupProvider).value ?? [];
    if (asyncDeviceGroups.isEmpty) {
      return Center(
        child: Text('No groups available. Add a group to get started!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: asyncDeviceGroups.fold<int>(0, (count, group) => count + group.groupDevices.length + 2),
      itemBuilder: (context, index) {
        int currentCount = 0;

        for (final group in asyncDeviceGroups) {
          if (index == currentCount) {
            return CrewHeaderItem(crew: group);
          }
          currentCount++;

          for (int i = 0; i < group.groupDevices.length; i++) {
            if (index == currentCount) {
              return MemberItem(crew: group, member: group.groupDevices[i]);
            }
            currentCount++;
          }

          if (index == currentCount) {
            return const SectionDividerItem();
          }
          currentCount++;
        }

        return const SizedBox.shrink();
      },
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
    );
  }
}

class CrewHeaderItem extends StatelessWidget {
  const CrewHeaderItem({super.key, required this.crew});

  final Group crew;

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
          crew.groupName,
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

class MemberItem extends ConsumerWidget {
  const MemberItem({
    super.key,
    required this.crew,
    required this.member,
  });

  final Group crew;
  final Device member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDeviceWatcher = ref.watch(selectedDeviceProvider);
    final selectedDeviceReader = ref.read(selectedDeviceProvider.notifier);
    final wsManager = ref.read(webSocketManagerProvider.notifier);
    final displayDeviceStatus = ref.watch(settingDisplayDeviceStatus);

    final isLastMember = crew.groupDevices.last == member;

    print("Selected Device: $selectedDeviceWatcher");

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: MouseEffectsContainer(
            height: 60,
            onPressed: () {
              if (member == selectedDeviceWatcher) {
                wsManager.disconnect();
                selectedDeviceReader.clearSelection();
              } else {
                wsManager.connect(member.deviceID);
                selectedDeviceReader.selectDevice(member);
              }
            },
            border: selectedDeviceWatcher == member
                ? Border.all(color: Colors.white, width: 2)
                : null,
            opacity: selectedDeviceWatcher == member ? 0.15 : 0.1,
            spotlightRadius: 200,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        selectedDeviceWatcher == member ? 5 : 7,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        member.deviceID,
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
                          member.deviceUserName,
                          style: GoogleFonts.asap(
                            fontWeight: selectedDeviceWatcher == member
                                ? FontWeight.w900
                                : FontWeight.bold,
                            color: selectedDeviceWatcher == member
                                ? themeDarkSecondaryText
                                : themeDarkDimText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (displayDeviceStatus)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: member.deviceStatus == 'Online'
                              ? Colors.green
                              : member.deviceStatus == 'Offline'
                                  ? Colors.white.withOpacity(0.35)
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!isLastMember) const SizedBox(height: 5),
      ],
    );
  }
}

class SectionDividerItem extends StatelessWidget {
  const SectionDividerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: themeDarkDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
