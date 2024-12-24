import 'package:spark/models/crew.dart';

List<CrewGroup> parseCrewData(
    Map<String, Map<String, Map<String, String>>> data) {
  return data.entries.map((groupEntry) {
    final members = groupEntry.value.entries.map((memberEntry) {
      final details = memberEntry.value;
      return CrewMember(
        id: memberEntry.key,
        lastName: details['lastName'] ?? '',
        status: details['status'] ?? '',
      );
    }).toList();

    return CrewGroup(
      name: groupEntry.key,
      members: members,
    );
  }).toList();
}
