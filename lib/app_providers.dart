import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark/app_provider_classes.dart';

import 'app_constants.dart';
import 'models/device.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final settingAPIEndpoint =
    StateNotifierProvider<TypedProvider<String>, String>((ref) {
  return TypedProvider<String>(ref
      .read(sharedPreferencesProvider)
      .tryGetValue("settingAPIEndpoint", ""));
});

final settingDisplayAverage =
    StateNotifierProvider<TypedProvider<bool>, bool>((ref) {
  return TypedProvider<bool>(ref
      .read(sharedPreferencesProvider)
      .tryGetValue("settingDisplayAverage", false));
});

final settingDisplayDeviceStatus =
    StateNotifierProvider<TypedProvider<bool>, bool>((ref) {
  return TypedProvider<bool>(ref
      .read(sharedPreferencesProvider)
      .tryGetValue("settingDisplayDeviceStatus", false));
});

final groupProvider = AsyncNotifierProvider<GroupNotifier, List<Group>>(() {
  return GroupNotifier();
});

final selectedDeviceProvider = StateNotifierProvider<SelectedDeviceNotifier, Device?>((ref) {
  return SelectedDeviceNotifier();
});

class SelectedDeviceNotifier extends StateNotifier<Device?> {
  SelectedDeviceNotifier() : super(null);

  void selectDevice(Device device) {
    state = device;
  }

  void clearSelection() {
    state = null;
  }
}

class GroupNotifier extends AsyncNotifier<List<Group>> {
  Device? selectedDevice;

  @override
  Future<List<Group>> build() async {
    return await loadGroups();
  }

  Future<List<Group>> loadGroups() async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final storedData =
        sharedPreferences.tryGetValue<String>('deviceGroups', defaultDeviceGroups);
    print("Stored Data: $storedData");
    try {
      final List<dynamic> decoded = jsonDecode(storedData);
      print("Decoded: $decoded");
      return decoded.map((group) => Group.fromJson(group)).toList();
    } catch (e) {
      print("Error parsing stored groups: $e");
      return [];
    }
  }

  Future<void> saveGroups(List<Group> groups) async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.setString(
        'deviceGroups', jsonEncode(groups.map((g) => g.toJson()).toList()));
    state = AsyncData(groups);
    print(jsonEncode(groups.map((g) => g.toJson()).toList()));
  }

  void addGroup(String groupName) {
    print("Adding Group...");
    final updatedGroups = [
      ...state.value ?? [],
      Group(
        groupID: DateTime.now().millisecondsSinceEpoch.toString(),
        groupName: groupName,
        groupDevices: [],
      ),
    ];
    saveGroups(updatedGroups.cast<Group>());
    print("Added Group");
  }

  void removeGroup(String groupID) {
    final updatedGroups =
        (state.value ?? []).where((group) => group.groupID != groupID).toList();
    saveGroups(updatedGroups);
  }

  void addDevice(String groupID, String deviceID, String deviceUserName) {
    final updatedGroups = (state.value ?? []).map((group) {
      if (group.groupID == groupID) {
        return Group(
          groupID: groupID,
          groupName: group.groupName,
          groupDevices: [
            ...group.groupDevices,
            Device(
                deviceID: deviceID,
                deviceUserName: deviceUserName,
                deviceStatus: 'Online'),
          ],
        );
      }
      return group;
    }).toList();
    saveGroups(updatedGroups);
  }

  void removeDevice(String groupID, String deviceID) {
    final updatedGroups = (state.value ?? []).map((group) {
      if (group.groupID == groupID) {
        return Group(
          groupID: group.groupID,
          groupName: group.groupName,
          groupDevices: group.groupDevices
              .where((device) => device.deviceID != deviceID)
              .toList(),
        );
      }
      return group;
    }).toList();
    saveGroups(updatedGroups);
  }

  void updateDevice(String groupID, String deviceID) {
    final updatedGroups = (state.value ?? []).map((group) {
      if (group.groupID == groupID) {
        return Group(
          groupID: group.groupID,
          groupName: group.groupName,
          groupDevices: group.groupDevices.map((device) {
            if (device.deviceID == deviceID) {
              return Device(
                deviceID: device.deviceID,
                deviceUserName: device.deviceUserName,
                deviceStatus: 'Online',
              );
            }
            return device;
          }).toList(),
        );
      }
      return group;
    }).toList();
    saveGroups(updatedGroups);
  }

  void selectDevice(Device device) {
    selectedDevice = device;
    state = AsyncData(state.value ?? []);
  }

  void clearSelection() {
    selectedDevice = null;
    state = AsyncData(state.value ?? []);
  }
}

List<Map<String, dynamic>> filterConfiguration = [
  {
    'filterModuleID': 1,
    'filterModuleType': 'Region',
    'filterModuleValue': 'Alpha',
    'filterModuleChildren': [
      {
        'filterModuleID': 11,
        'filterModuleType': 'Region',
        'filterModuleValue': 'Alpha',
        'filterModuleChildren': []
      }
    ]
  },
  {
    'filterModuleID': 2,
    'filterModuleType': 'Region',
    'filterModuleValue': 'Alpha',
    'filterModuleChildren': [
      {
        'filterModuleID': 21,
        'filterModuleType': 'Region',
        'filterModuleValue': 'Alpha',
        'filterModuleChildren': []
      }
    ]
  }
];

extension on SharedPreferences {
  T tryGetValue<T>(String value, T defaultValue) {
    T? result;

    try {
      if (defaultValue is int) {
        result = getInt(value) as T?;
      } else if (defaultValue is String) {
        result = getString(value) as T?;
      } else if (defaultValue is bool) {
        result = getBool(value) as T?;
      } else {
        throw UnsupportedError('Unsupported type: ${defaultValue.runtimeType}');
      }
    } catch (e, stackTrace) {
      List<String> stackTraceLines = stackTrace.toString().split('\n');

      print("Failed to load from Shared Preferences\n"
          "\t-> Key: $value\n"
          "\t-> File: ${stackTraceLines[0]}\n"
          "\t-> Function: ${stackTraceLines[1]}\n"
          "\t-> Line: ${stackTraceLines[2]}\n\n"
          "Returning 'defaultValue': ${defaultValue.toString()}");
    }

    print(value);
    print(defaultValue);
    print(result);

    return result ?? defaultValue;
  }
}
