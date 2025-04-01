import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/pages/dashboard/widgets/metric_module.dart';
import 'package:spark/providers/sensor_data_provider.dart';
import 'package:spark/utils/web_socket_manager.dart';

class DeviceDetailsPanel extends ConsumerWidget {
  const DeviceDetailsPanel({super.key});

  static const Map<String, String> metricsMap = {
    'Temperature (°C)': 'temperature_celsius',
    'Carbon Monoxide (ppm)': 'carbon_monoxide_ppm',
    'PM1 (µg/m³)': 'pm1_ug_m3',
    'PM2.5 (µg/m³)': 'pm2_5_ug_m3',
    'PM4 (µg/m³)': 'pm4_ug_m3',
    'PM10 (µg/m³)': 'pm10_ug_m3',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(webSocketManagerProvider);
    final sensorDataMap = ref.watch(sensorDataProvider);

    final connectionStateWidget = _buildWebSocketStatusWidget(wsState);
    if (connectionStateWidget != null) return connectionStateWidget;

    final List<Widget> items = metricsMap.keys.map((title) {
        final key = metricsMap[title] ?? '';
        final sensorData = sensorDataMap[key] ?? [];
        return MetricModule(title, sensorData);
      }).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(15),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => items[index],
      separatorBuilder: (context, index) => _buildSeparator(),
      itemCount: items.length,
    );
  }

  Widget? _buildWebSocketStatusWidget(WebSocketState wsState) {
    if (wsState.errorMessage != null) {
      return _templateStatusWidget(
          HugeIcons.strokeRoundedAlert02, 'Error', wsState.errorMessage.toString());
    } else if (wsState.isConnecting) {
      return _templateStatusWidget(
          null, 'Connecting', 'Establishing a connection to the device.');
    } else if (!wsState.isConnected) {
      return _templateStatusWidget(HugeIcons.strokeRoundedArrowLeft04, 'Select',
          'Select a device from the left panel.');
    }

    return null;
  }

  Widget _templateStatusWidget(
      IconData? icon, String title, String description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon == null
              ? Column(
                  children: [
                    Transform.scale(
                      scale: 2,
                      child: const CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        color: themeDarkPrimaryText,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                )
              : HugeIcon(icon: icon, size: 128, color: themeDarkPrimaryText),
          Text(
            title,
            style: GoogleFonts.asap(
                fontSize: 26,
                color: themeDarkPrimaryText,
                fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: GoogleFonts.asap(
              fontSize: 14,
              color: themeDarkSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: themeDarkDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
