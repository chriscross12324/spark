import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../common/segmented_control.dart';

class MetricHistoryModule extends StatefulWidget {
  const MetricHistoryModule({super.key, required this.metricTitle});

  final String metricTitle;

  @override
  State<MetricHistoryModule> createState() => _MetricHistoryModuleState();
}

class _MetricHistoryModuleState extends State<MetricHistoryModule>
    with AutomaticKeepAliveClientMixin {
  late final List<_PointData> placeholderData;

  @override
  void initState() {
    super.initState();
    placeholderData = _generatePlaceholderData(count: 400);
  }

  List<_PointData> _generatePlaceholderData({required int count}) {
    List<_PointData> data = [];

    for (int i = 0; i < count; i++) {
      data.add(_PointData(_formatTimeLabel(i.toDouble()), sin(i / 8)));
    }

    return data;
  }

  String _formatTimeLabel(double value) {
    final baseTime = DateTime(2024, 1, 1);
    final intervalSeconds = value.toInt() * 180;
    final displayTime = baseTime.add(Duration(seconds: intervalSeconds));

    return "${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}:${displayTime.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Common styles and colours
    final labelStyle = GoogleFonts.asap(
      color: themeDarkSecondaryText,
    );
    final gridLineStyle =
        MajorGridLines(color: themeDarkAccentColourFaded.withOpacity(0.35));

    // Calculate Y-axis range
    final double yMin =
        placeholderData.map((p) => p.value).reduce(min).floor() - 1;
    final double yMax =
        placeholderData.map((p) => p.value).reduce(max).ceil() + 1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.metricTitle,
            style: GoogleFonts.asap(
              color: themeDarkPrimaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SegmentedControl(
                options: [
                  "Max",
                  "7 days",
                  "3 days",
                  "24 hours",
                  "12 hours",
                  "3 hours",
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: SfCartesianChart(
              // X-Axis Configuration
              primaryXAxis: CategoryAxis(
                labelPlacement: LabelPlacement.betweenTicks,
                labelStyle: labelStyle,
                majorGridLines: gridLineStyle,
              ),

              // Y-Axis Configuration
              primaryYAxis: NumericAxis(
                minimum: yMin,
                maximum: yMax,
                interval: 2,
                labelStyle: labelStyle,
                majorGridLines: gridLineStyle,
              ),

              // Trackball Behaviour
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                lineColor: themeDarkPrimaryText,
                lineWidth: 2,
                shouldAlwaysShow: true,
                tooltipSettings: const InteractiveTooltip(
                  enable: true,
                  format: 'point.y',
                ),
              ),

              // Data Series
              series: <CartesianSeries<_PointData, String>>[
                AreaSeries(
                  dataSource: placeholderData,
                  xValueMapper: (_PointData data, _) => data.timestamp,
                  yValueMapper: (_PointData data, _) => data.value,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      themeDarkAccentColourMain.withOpacity(0.15),
                      themeDarkAccentColourMain.withOpacity(0.0),
                    ],
                  ),
                  color: Colors.white,
                  borderColor: Colors.transparent,
                  markerSettings: const MarkerSettings(
                    height: 4,
                    width: 4,
                    isVisible: true,
                    color: Colors.white,
                  ),
                  animationDuration: 0,

                  // Average Trend-line
                  /*trendlines: [
                    Trendline(
                      type: TrendlineType.movingAverage,
                      color: themeDarkComplementaryColourMain,
                      animationDuration: 0,
                      period: 2,
                      enableTooltip: true,
                      backwardForecast: 5,
                    ),
                  ],*/
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PointData {
  _PointData(this.timestamp, this.value);

  final String timestamp;
  final double value;
}
