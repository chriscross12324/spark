class CrewMember {
  final String id;
  final String lastName;
  final String status;

  CrewMember({
    required this.id,
    required this.lastName,
    required this.status,
  });
}

class CrewGroup {
  final String name;
  final List<CrewMember> members;

  CrewGroup({
    required this.name,
    required this.members,
  });
}