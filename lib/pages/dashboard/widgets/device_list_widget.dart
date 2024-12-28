import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/models/crew.dart';
import 'package:spark/providers/dashboard_provider.dart';
import 'package:spark/widgets/common/mouse_effects.dart';

class DeviceListWidget extends ConsumerWidget {
  const DeviceListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(dashboardProvider);
    final stateNotifier = ref.read(dashboardProvider.notifier);

    return ListView.builder(
      itemCount: listState.crewGroups
          .fold<int>(0, (count, group) => count + group.members.length + 2),
      itemBuilder: (context, index) {
        int currentCount = 0;

        for (final group in listState.crewGroups) {
          if (index == currentCount) {
            return CrewHeaderItem(crew: group);
          }
          currentCount++;

          for (int i = 0; i < group.members.length; i++) {
            if (index == currentCount) {
              return MemberItem(crew: group, member: group.members[i]);
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
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
    );
  }
}

class DeviceListItem extends StatelessWidget {
  const DeviceListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CrewHeaderItem extends StatelessWidget {
  const CrewHeaderItem({super.key, required this.crew});

  final CrewGroup crew;

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
          crew.name,
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

class MemberItem extends StatelessWidget {
  const MemberItem({
    super.key,
    required this.crew,
    required this.member,
  });

  final CrewGroup crew;
  final CrewMember member;

  @override
  Widget build(BuildContext context) {
    final isLastMember = crew.members.last == member;

    return Column(
      children: [
        MouseEffectsContainer(
          height: 60,
          onPressed: () {},
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
                      member.id,
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
                        member.lastName,
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
                      color: member.status == 'Online'
                          ? Colors.green
                          : member.status == 'Offline'
                              ? Colors.white.withOpacity(0.35)
                              : Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
              ],
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