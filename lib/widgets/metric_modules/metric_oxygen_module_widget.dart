import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spark/app_constants.dart';

class MetricOxygenModuleWidget extends StatefulWidget {
  const MetricOxygenModuleWidget({super.key});

  @override
  State<MetricOxygenModuleWidget> createState() => _MetricOxygenModuleWidgetState();
}

List<FlSpot> placeholderTempData = [
  const FlSpot(0, 18),
  const FlSpot(1, -2),
  const FlSpot(2, 28),
  const FlSpot(3, 6),
  const FlSpot(4, 20),
  const FlSpot(5, -5),
  const FlSpot(6, 21),
  const FlSpot(7, 11),
  const FlSpot(8, -1),
  const FlSpot(9, 19),
  const FlSpot(10, 8),
  const FlSpot(11, 22),
  const FlSpot(12, 27),
  const FlSpot(13, 6),
  const FlSpot(14, 5),
  const FlSpot(15, -4),
  const FlSpot(16, 0),
  const FlSpot(17, -3),
  const FlSpot(18, -1),
  const FlSpot(19, 26),
  const FlSpot(20, 7),
  const FlSpot(21, 24),
  const FlSpot(22, 6),
  const FlSpot(23, -1),
  const FlSpot(24, -10),
  const FlSpot(25, -6),
  const FlSpot(26, 22),
  const FlSpot(27, 30),
  const FlSpot(28, -7),
  const FlSpot(29, 26),
];

class _MetricOxygenModuleWidgetState extends State<MetricOxygenModuleWidget> {
  double zoomFactor = 1.1;

  @override
  Widget build(BuildContext context) {
    double minX = 0.0;
    double maxX = placeholderTempData.length.toDouble();
    double minY = placeholderTempData.map((p) => p.y).reduce((a, b) => a < b ? a : b) * zoomFactor;
    double maxY = placeholderTempData.map((p) => p.y).reduce((a, b) => a > b ? a : b) * zoomFactor;

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
                  interval: 10,
                  getTitlesWidget: (value, __) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(color: themeDarkSecondaryText),
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
                  );
                },
                interval: 5,
              ),
            ),
            rightTitles: buildHiddenAxisTitles(),
            topTitles: buildHiddenAxisTitles(),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xffb98474))),
          lineBarsData: [
            LineChartBarData(
                spots: placeholderTempData,
                isCurved: false,
                dotData: const FlDotData(show: true),
                color: const Color(0xfff7744f)),
          ],
          lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(getTooltipColor: (_) {
            return themeDarkForeground.blendColours(const Color(0xfff7744f), 0.25);
          })),
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
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

    int r = ((1 - blendAmount) * red + blendAmount * secondaryColour.red).round();
    int g = ((1 - blendAmount) * green + blendAmount * secondaryColour.green).round();
    int b = ((1 - blendAmount) * blue + blendAmount * secondaryColour.blue).round();

    return Color.fromARGB(255, r, g, b);
  }
}
