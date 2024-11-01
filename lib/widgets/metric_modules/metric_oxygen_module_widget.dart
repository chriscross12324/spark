import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spark/app_constants.dart';

class MetricOxygenModuleWidget extends StatefulWidget {
  const MetricOxygenModuleWidget({super.key});

  @override
  State<MetricOxygenModuleWidget> createState() =>
      _MetricOxygenModuleWidgetState();
}

class _MetricOxygenModuleWidgetState extends State<MetricOxygenModuleWidget> {
  double zoomFactor = 1.0;

  // Generate placeholder temperature data
  List<FlSpot> generatePlaceholderData(int count) {
    final random = Random();
    List<FlSpot> data = [];
    double currentY = 20; // Start at a base value, e.g., 20 degrees

    for (int i = 0; i < count; i++) {
      // Decide the change in temperature
      double change = random.nextBool() ? 1.0 : -1.0; // Small change of ±1 degree
      if (random.nextDouble() < 0.1) { // 10% chance of a larger change
        change = (random.nextDouble() * 10 - 5); // Larger deviation between -5 and +5 degrees
      }

      // Update currentY with the change, and add it to the list
      currentY += change;
      double roundedValue = double.parse(currentY.toDouble().toStringAsFixed(2));
      data.add(FlSpot(i.toDouble(), roundedValue));
    }

    return data;
  }

  late final placeholderTempData;
  List<FlSpot> averageTempData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    placeholderTempData = generatePlaceholderData(100);
    averageTempData = calculateMovingAverage(placeholderTempData, windowSize: 5);
  }

  @override
  Widget build(BuildContext context) {
    double minY = placeholderTempData.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    double maxY = placeholderTempData.map((p) => p.y).reduce((a, b) => a > b ? a : b);
    double minX = placeholderTempData.map((p) => p.x).reduce((a, b) => a < b ? a : b);
    double maxX = placeholderTempData.map((p) => p.x).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 12,
        right: 18,
        bottom: 12,
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return getFlLine();
            },
            getDrawingVerticalLine: (value) {
              return getFlLine();
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  reservedSize: 48,
                  getTitlesWidget: (value, __) {
                    return Text(
                      value.round().toString() + " -",
                      style: const TextStyle(color: themeDarkSecondaryText),
                      textAlign: TextAlign.end,
                    );
                  }),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final interval = 30;
                  return Text(
                    (value * interval).toStringAsFixed(0) + " s",
                    style: const TextStyle(color: themeDarkSecondaryText),
                    textAlign: TextAlign.end,
                  );
                },
                interval: 5,
                reservedSize: 68,
              ),
            ),
            rightTitles: buildHiddenAxisTitles(),
            topTitles: buildHiddenAxisTitles(),
          ),
          borderData: FlBorderData(
              show: true, border: Border.all(color: const Color(0xffb98474))),
          lineBarsData: [
            LineChartBarData(
                spots: averageTempData,
                isCurved: true,
                dotData: const FlDotData(show: false),
                color: const Color(0xff4fa3f7)
            ),
            LineChartBarData(
              spots: placeholderTempData,
              isCurved: false,
              dotData: const FlDotData(show: true),
              color: const Color(0xfff7744f),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xffb98474).withOpacity(0.15),
              )
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) {
                return themeDarkForeground.blendColours(
                    const Color(0xfff7744f), 0.25);
              },
            ),
          ),
          minX: minX,
          maxX: maxX,
          minY: minY - 1,
          maxY: maxY + 1,
        ),
      ),
    );
  }

  AxisTitles buildHiddenAxisTitles() {
    return const AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    );
  }

  FlLine getFlLine() {
    return FlLine(
      color: const Color(0xffb98474).withOpacity(0.15),
      strokeWidth: 1,
    );
  }
}

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

// Calculates a moving average for smoothing
List<FlSpot> calculateMovingAverage(List<FlSpot> data, {int windowSize = 5}) {
  List<FlSpot> smoothedData = [];

  for (int i = 0; i < data.length; i++) {
    int start = max(0, i - windowSize + 1);
    int end = i + 1;
    double average = data.sublist(start, end).map((e) => e.y).reduce((a, b) => a + b) / (end - start);
    smoothedData.add(FlSpot(data[i].x, double.parse(average.toStringAsFixed(2))));
  }

  return smoothedData;
}