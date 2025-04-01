class Device {
  Device(
      {required this.deviceID,
      required this.deviceUserName,
      required this.deviceStatus});

  String deviceID;
  String deviceUserName;
  String deviceStatus;

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceID: json['deviceID'],
      deviceUserName: json['deviceUserName'],
      deviceStatus: json['deviceStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
        'deviceID': deviceID,
        'deviceUserName': deviceUserName,
        'deviceStatus': deviceStatus,
      };
}

class Group {
  Group(
      {required this.groupID,
      required this.groupName,
      required this.groupDevices});

  String groupID;
  String groupName;
  List<Device> groupDevices;

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupID: json['groupID'],
      groupName: json['groupName'],
      groupDevices: (json['groupDevices'] as List)
          .map((deviceJson) => Device.fromJson(deviceJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'groupID': groupID,
        'groupName': groupName,
        'groupDevices': groupDevices.map((device) => device.toJson()).toList(),
      };
}
