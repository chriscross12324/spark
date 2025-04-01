import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark/models/sensor_data_model.dart';

class SensorDataNotifier extends StateNotifier<Map<String, List<SensorData>>> {
  SensorDataNotifier()
      : super({
          'carbon_monoxide_ppm': [],
          'temperature_celsius': [],
          'pm1_ug_m3': [],
          'pm2_5_ug_m3': [],
          'pm4_ug_m3': [],
          'pm10_ug_m3': [],
        });

  void updateData(Map<String, dynamic> newData) {
    final List<SensorData> parsedData = parseSensorData(newData);

    final updatedState = {...state};

    for (var data in parsedData) {
      updatedState[data.type] = [...updatedState[data.type]!, data];
    }

    state = updatedState;
  }

  void purgeData() {
    state = {
      'carbon_monoxide_ppm': [],
      'temperature_celsius': [],
      'pm1_ug_m3': [],
      'pm2_5_ug_m3': [],
      'pm4_ug_m3': [],
      'pm10_ug_m3': [],
    };
  }

  List<SensorData> parseSensorData(Map<String, dynamic> data) {
    List<SensorData> result = [];

    for (var entry in data['data']) {
      DateTime timestamp = DateTime.parse(entry['recorded_at']);
      result.add(SensorData(type: 'carbon_monoxide_ppm', value: (entry['carbon_monoxide_ppm'] as num).toDouble(), timestamp: timestamp));
      result.add(SensorData(type: 'temperature_celsius', value: (entry['temperature_celsius'] as num).toDouble(), timestamp: timestamp));
      result.add(SensorData(type: 'pm1_ug_m3', value: (entry['pm1_ug_m3'] as num).toDouble(), timestamp: timestamp));
      result.add(SensorData(type: 'pm2_5_ug_m3', value: (entry['pm2_5_ug_m3'] as num).toDouble(), timestamp: timestamp));
      result.add(SensorData(type: 'pm4_ug_m3', value: (entry['pm4_ug_m3'] as num).toDouble(), timestamp: timestamp));
      result.add(SensorData(type: 'pm10_ug_m3', value: (entry['pm10_ug_m3'] as num).toDouble(), timestamp: timestamp));
    }

    return result;
  }
}

final sensorDataProvider =
    StateNotifierProvider<SensorDataNotifier, Map<String, List<SensorData>>>(
        (ref) {
  return SensorDataNotifier();
});
