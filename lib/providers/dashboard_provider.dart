import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/models/crew.dart';
import 'package:spark/utils/parse_crew_data.dart';

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(),
);


class DashboardState {
  final List<CrewGroup> crewGroups;
  final CrewMember? selectedMember;

  DashboardState({
    required this.crewGroups,
    this.selectedMember,
  });

  DashboardState copyWith({
    final List<CrewGroup>? crewGroups,
    final CrewMember? selectedMember,
  }) {
    return DashboardState(
      crewGroups: crewGroups ?? this.crewGroups,
      selectedMember: selectedMember,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier()
      : super(
          DashboardState(
            crewGroups: parseCrewData(crews),
            selectedMember: null,
          ),
        );

  void addItem(String groupName, CrewMember newMember) {
    final updatedCrewGroups = [...state.crewGroups];

    final groupIndex = updatedCrewGroups.indexWhere((group) => group.name == groupName);

    if (groupIndex != -1) {
      updatedCrewGroups[groupIndex].members.add(newMember);
    } else {
      updatedCrewGroups.add(CrewGroup(name: groupName, members: [newMember]));
    }

    state = state.copyWith(crewGroups: updatedCrewGroups);
  }

  void removeItem(String groupName, CrewMember flaggedMember) {
    final updatedCrewGroups = [...state.crewGroups];

    final groupIndex = updatedCrewGroups.indexWhere((group) => group.name == groupName);
    if (groupIndex == -1) return;

    updatedCrewGroups[groupIndex].members.removeWhere((member) => member.id == flaggedMember.id);
    state = state.copyWith(crewGroups: updatedCrewGroups);
  }

  void updateItem(String groupName, CrewMember originalMember, CrewMember updatedMember) {
    final updatedCrewGroups = [...state.crewGroups];

    final groupIndex = updatedCrewGroups.indexWhere((group) => group.name == groupName);
    if (groupIndex == -1) return;

    final memberIndex = updatedCrewGroups[groupIndex].members.indexWhere((member) => member.id == originalMember.id);
    if (memberIndex == -1) return;

    updatedCrewGroups[groupIndex].members[memberIndex] = updatedMember;
    state = state.copyWith(crewGroups: updatedCrewGroups);
  }

  void selectItem(CrewMember? member) {
    state = state.copyWith(selectedMember: member);
  }

  void clearSelection() {
    state = state.copyWith(selectedMember: null);
  }
}
