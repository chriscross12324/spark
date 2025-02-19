import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

class TypedProvider<T> extends StateNotifier<T> {
  TypedProvider(super.state);

  void updateState(T newState) {
    state = newState;
  }

  void saveState(T newState, String sharedPreferencesKey, WidgetRef ref) {
    try {
      final sharedPreferences = ref.read(sharedPreferencesProvider);

      if (newState is int) {
        sharedPreferences.setInt(sharedPreferencesKey, newState);
      } else if (newState is double) {
        sharedPreferences.setDouble(sharedPreferencesKey, newState);
      } else if (newState is bool) {
        sharedPreferences.setBool(sharedPreferencesKey, newState);
      } else if (newState is String) {
        sharedPreferences.setString(sharedPreferencesKey, newState);
      } else if (newState is List<String>) {
        sharedPreferences.setStringList(sharedPreferencesKey, newState);
      } else if (newState is Map<String, dynamic>) {
        sharedPreferences.setString(sharedPreferencesKey, jsonEncode(newState));
      } else {
        throw Exception("WARNING: Unsupported type (${newState.runtimeType}) "
            "for SharedPreferences");
      }

      updateState(newState);
    } catch (e) {
      debugPrint(
          "ERROR | File: app_provider_classes.dart | Class: TypedProvider | "
          "Function: saveState() | MSG: ${e.toString()}");
    }
  }

  T getValue() {
    return state;
  }
}
