import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../common/segmented_control.dart';

class MetricOxygenModuleWidget extends StatefulWidget {
  const MetricOxygenModuleWidget({super.key});

  @override
  State<MetricOxygenModuleWidget> createState() =>
      _MetricOxygenModuleWidgetState();
}

class _MetricOxygenModuleWidgetState extends State<MetricOxygenModuleWidget>
    with AutomaticKeepAliveClientMixin {
  late final List<_PointData> placeholderData;

  @override
  void initState() {
    super.initState();
    placeholderData = _generatePlaceholderData(count: 100);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const SizedBox(height: 5),
          const Row(
            children: [
              SegmentedControl(options: [
                "Max",
                "7 days",
                "3 days",
                "24 hours",
                "12 hours",
                "3 hours"
              ]),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelPlacement: LabelPlacement.onTicks,
                labelStyle: GoogleFonts.asap(
                  color: themeDarkSecondaryText,
                ),
                majorGridLines: MajorGridLines(
                  color: themeDarkAccentColourFaded.withOpacity(0.35),
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum:
                    placeholderData.map((p) => p.value).reduce(min).floor() -
                        1,
                maximum:
                    placeholderData.map((p) => p.value).reduce(max).ceil() +
                        1,
                interval: 2,
                labelStyle: GoogleFonts.asap(
                  color: themeDarkSecondaryText,
                ),
                majorGridLines: MajorGridLines(
                  color: themeDarkAccentColourFaded.withOpacity(0.35),
                ),
              ),
              /*tooltipBehavior: TooltipBehavior(
                    enable: true, shouldAlwaysShow: true, animationDuration: 0),*/
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                lineColor: themeDarkPrimaryText,
                lineWidth: 2,
                shouldAlwaysShow: true,
                tooltipSettings:
                    const InteractiveTooltip(enable: true, format: 'point.y'),
              ),
              legend: Legend(
                isVisible: false,
                position: LegendPosition.bottom,
                textStyle: GoogleFonts.asap(
                  color: themeDarkSecondaryText,
                ),
              ),
              enableAxisAnimation: true,
              series: <CartesianSeries<_PointData, String>>[
                AreaSeries<_PointData, String>(
                  dataSource: placeholderData,
                  xValueMapper: (_PointData data, _) => data.timestamp,
                  yValueMapper: (_PointData data, _) => data.value,
                  color: themeDarkAccentColourMain.withOpacity(0.15),
                  borderColor: Colors.transparent,
                  markerSettings: const MarkerSettings(
                    height: 5,
                    width: 5,
                    isVisible: true,
                    color: Colors.white,
                  ),
                  legendIconType: LegendIconType.circle,
                  animationDuration: 0,
                  trendlines: [
                    Trendline(
                      type: TrendlineType.movingAverage,
                      color: themeDarkComplementaryColourMain,
                      animationDuration: 0,
                      period: 5,
                      legendIconType: LegendIconType.horizontalLine,
                      enableTooltip: true,
                      backwardForecast: 5,
                    ),
                  ],
                  name: "Raw Data",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_PointData> _generatePlaceholderData({
    required int count,
    double startingValue = 20.0,
    double minChange = -0.5,
    double maxChange = 0.5,
    double outlierProbability = 0.01,
    double outlierMultiplier = 2.0,
    double minValue = 20.0,
    double maxValue = 30.0,
  }) {
    /*final random = Random();
    List<_PointData> data = [];
    double currentValue = startingValue;*/

    List<_PointData> data = [];
    for (int i = 0; i < count; i++) {
      double rand = Random().nextDouble().clamp(0, 2);
      /*double change = random.nextDouble() * (maxChange - minChange) + minChange;

      if (random.nextDouble() < outlierProbability) {
        change *= (random.nextBool() ? outlierMultiplier : -outlierMultiplier);
      }

      currentValue = (currentValue + change).clamp(minValue, maxValue);

      currentValue = currentValue.clamp(0.0, 100.0);

      double roundedValue = double.parse(currentValue.toStringAsFixed(5));*/
      data.add(_PointData(_formatTimeLabel(i.toDouble()), sin(i/8)));
    }

    return data;
  }

  ///Chart styling and configuration
  String _formatTimeLabel(double value) {
    final baseTime = DateTime(2024, 1, 1);
    final intervalSeconds = value.toInt() * 180;
    final displayTime = baseTime.add(Duration(seconds: intervalSeconds));

    return "${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}:${displayTime.second.toString().padLeft(2, '0')}";
  }

  @override
  bool get wantKeepAlive => true;
}

class _PointData {
  _PointData(this.timestamp, this.value);

  final String timestamp;
  final double value;
}

/// Extension for Colour Blending
extension ColorBlending on Color {
  Color blendColours(Color secondaryColour, double blendAmount) {
    blendAmount = blendAmount.clamp(0.0, 1.0);

    int r =
        ((1 - blendAmount) * red + blendAmount * secondaryColour.red).round();
    int g = ((1 - blendAmount) * green + blendAmount * secondaryColour.green)
        .round();
    int b =
        ((1 - blendAmount) * blue + blendAmount * secondaryColour.blue).round();

    return Color.fromARGB(255, r, g, b);
  }
}
