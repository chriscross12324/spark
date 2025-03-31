class SensorData {
  SensorData(
      {required this.type, required this.value, required this.timestamp});

  final String type;
  final double value;
  final DateTime timestamp;

  @override
  String toString() {
    return 'SensorData(type: $type, value: $value, timestamp: ${timestamp.toIso8601String()})';
  }
}
