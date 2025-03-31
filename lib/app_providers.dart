import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark/app_provider_classes.dart';

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
