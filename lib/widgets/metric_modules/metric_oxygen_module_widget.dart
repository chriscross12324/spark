import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/widgets/universal/icon_button_widget.dart';
import 'package:spark/widgets/universal/zoomable_chart_widget.dart';

class MetricOxygenModuleWidget extends StatefulWidget {
  const MetricOxygenModuleWidget({super.key});

  @override
  State<MetricOxygenModuleWidget> createState() => _MetricOxygenModuleWidgetState();
}

class _MetricOxygenModuleWidgetState extends State<MetricOxygenModuleWidget> with AutomaticKeepAliveClientMixin {
  late final List<FlSpot> placeholderData;
  late final List<FlSpot> averageData;
  double zoomFactor = 1.0;

  @override
  void initState() {
    super.initState();
    placeholderData = _generatePlaceholderData(count: 1080);
    averageData = _calculateMovingAverage(placeholderData, windowSize: 5);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final zoomableChartGlobalKey = GlobalKey<ZoomableChartWidgetState>();
    double minY = placeholderData.map((p) => p.y).reduce(min);
    double maxY = placeholderData.map((p) => p.y).reduce(max);
    double minX = placeholderData.map((p) => p.x).reduce(min);
    double maxX = placeholderData.map((p) => p.x).reduce(max);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: ZoomableChartWidget(
                key: zoomableChartGlobalKey,
                maxX: maxX,
                builder: (currentMinX, currentMaxX) {
                  return ClipRRect(
                    child: LineChart(
                      LineChartData(
                        minX: currentMinX,
                        maxX: currentMaxX,
                        minY: minY - 1,
                        maxY: maxY + 1,
                        gridData: _buildGridData(),
                        titlesData: _buildTitlesData(minY: minY, maxY: maxY),
                        borderData: _buildBorderData(),
                        lineBarsData: _buildLineBarsData(),
                        lineTouchData: _buildLineTouchData(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                buttonFunction: () {
                  zoomableChartGlobalKey.currentState?.scrollLeft();
                },
                canHold: true,
              ),
              const SizedBox(width: 5),
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedArrowRight01,
                buttonFunction: () {
                  zoomableChartGlobalKey.currentState?.scrollRight();
                },
                canHold: true,
              ),
              const SizedBox(width: 5),
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedSearchAdd,
                buttonFunction: () {
                  zoomableChartGlobalKey.currentState?.zoomIn();
                },
                canHold: true,
              ),
              const SizedBox(width: 5),
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedSearchMinus,
                buttonFunction: () {
                  zoomableChartGlobalKey.currentState?.zoomOut();
                },
                canHold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generatePlaceholderData({required int count}) {
    final random = Random();
    List<FlSpot> data = [];
    double baseValue = 20;

    for (int i = 0; i < count; i++) {
      double change = random.nextBool() ? 1.0 : -1.0;
      if (random.nextDouble() < 0.1) {
        change = (random.nextDouble() * 10 - 5);
      }

      baseValue += change;
      double roundedValue = double.parse(baseValue.toDouble().toStringAsFixed(2));
      data.add(FlSpot(i.toDouble(), roundedValue));
    }

    return data;
  }

  List<FlSpot> _calculateMovingAverage(List<FlSpot> data, {int windowSize = 5}) {
    List<FlSpot> smoothedData = [];

    for (int i = 0; i < data.length; i++) {
      int start = max(0, i - windowSize + 1);
      double average =
          data.sublist(start, i + 1).map((e) => e.y).reduce((a, b) => a + b) /
              (i + 1 - start);
      smoothedData.add(FlSpot(data[i].x, double.parse(average.toStringAsFixed(2))));
    }

    return smoothedData;
  }

  ///Chart styling and configuration
  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
      getDrawingHorizontalLine: (_) => _getFlLine(),
      getDrawingVerticalLine: (value) => _getFlLine(),
    );
  }

  FlTitlesData _buildTitlesData({required double minY, required double maxY}) {
    return FlTitlesData(
        leftTitles: _buildAxisTitles(minY: minY, maxY: maxY, isLeftAxis: true),
        bottomTitles: _buildAxisTitles(isLeftAxis: false),
        rightTitles: _buildHiddenAxisTitles(),
        topTitles: _buildHiddenAxisTitles());
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(color: themeDarkAccentColourFaded),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) =>
            themeDarkForeground.blendColours(themeDarkAccentColourMain, 0.25),
      ),
    );
  }

  List<LineChartBarData> _buildLineBarsData() {
    return [
      LineChartBarData(
        spots: averageData,
        isCurved: true,
        dotData: const FlDotData(show: false),
        color: themeDarkComplementaryColourMain,
      ),
      LineChartBarData(
        spots: placeholderData,
        isCurved: false,
        dotData: const FlDotData(show: true),
        color: themeDarkAccentColourMain,
        belowBarData: BarAreaData(
          show: true,
          color: themeDarkAccentColourFaded.withOpacity(0.15),
        ),
      ),
    ];
  }

  AxisTitles _buildAxisTitles(
      {double minY = 0, double maxY = 0, required bool isLeftAxis, int maxLabels = 10}) {
    double interval;
    if (isLeftAxis) {
      final range = maxY - minY;
      interval = (range / maxLabels).ceilToDouble();
    } else {
      interval = 5;
    }

    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: interval,
        reservedSize: isLeftAxis ? 48 : 20,
        getTitlesWidget: (value, _) {
          final labelText = isLeftAxis ? '${value.round()} -' : _formatTimeLabel(value);
          return Text(
            labelText,
            style: const TextStyle(color: themeDarkSecondaryText),
            textAlign: TextAlign.end,
          );
        },
      ),
    );
  }

  String _formatTimeLabel(double value) {
    final baseTime = DateTime(2024, 1, 1);
    final intervalSeconds = value.toInt() * 180;
    final displayTime = baseTime.add(Duration(seconds: intervalSeconds));

    return "${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}:${displayTime.second.toString().padLeft(2, '0')}";
  }

  AxisTitles _buildHiddenAxisTitles() {
    return const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    );
  }

  FlLine _getFlLine() {
    return FlLine(
      color: themeDarkAccentColourFaded.withOpacity(0.15),
      strokeWidth: 1,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Extension for Colour Blending
extension ColorBlending on Color {
  Color blendColours(Color secondaryColour, double blendAmount) {
    blendAmount = blendAmount.clamp(0.0, 1.0);

    int r = ((1 - blendAmount) * red + blendAmount * secondaryColour.red).round();
    int g = ((1 - blendAmount) * green + blendAmount * secondaryColour.green).round();
    int b = ((1 - blendAmount) * blue + blendAmount * secondaryColour.blue).round();

    return Color.fromARGB(255, r, g, b);
  }
}
