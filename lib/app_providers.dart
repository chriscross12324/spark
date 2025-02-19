import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
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