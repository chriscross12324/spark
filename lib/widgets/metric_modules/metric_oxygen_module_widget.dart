import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/widgets/universal/icon_button_widget.dart';
import 'package:spark/widgets/universal/zoomable_chart_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricOxygenModuleWidget extends StatefulWidget {
  const MetricOxygenModuleWidget({super.key});

  @override
  State<MetricOxygenModuleWidget> createState() => _MetricOxygenModuleWidgetState();
}

class _MetricOxygenModuleWidgetState extends State<MetricOxygenModuleWidget>
    with AutomaticKeepAliveClientMixin {
  late final List<_PointData> placeholderData;
  double zoomFactor = 1.0;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    placeholderData = _generatePlaceholderData(count: 1080);

    _zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        enableSelectionZooming: true,
        selectionRectColor: themeDarkComplementaryColourFaded,
        selectionRectBorderColor: themeDarkComplementaryColourMain,
        zoomMode: ZoomMode.x);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelPlacement: LabelPlacement.onTicks,
                    labelStyle: const TextStyle(
                      color: themeDarkSecondaryText,
                    ),
                    majorGridLines: MajorGridLines(
                      color: themeDarkAccentColourFaded.withOpacity(0.35),
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: placeholderData.map((p) => p.value).reduce(min).floor() - 1,
                    maximum: placeholderData.map((p) => p.value).reduce(max).ceil() + 1,
                    interval: 2,
                    labelStyle: const TextStyle(
                      color: themeDarkSecondaryText,
                    ),
                    majorGridLines: MajorGridLines(
                      color: themeDarkAccentColourFaded.withOpacity(0.35),
                    ),
                  ),
                  zoomPanBehavior: _zoomPanBehavior,
                  /*tooltipBehavior: TooltipBehavior(
                      enable: true, shouldAlwaysShow: true, animationDuration: 0),*/
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    lineColor: themeDarkPrimaryText,
                    lineWidth: 2,
                    shouldAlwaysShow: true,
                    tooltipSettings: InteractiveTooltip(
                      enable: true,
                      format: 'point.y'
                    ),
                  ),
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    textStyle: TextStyle(
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
                      borderColor: themeDarkAccentColourMain,
                      markerSettings: const MarkerSettings(
                          isVisible: true, color: themeDarkAccentColourMain),
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
                            backwardForecast: 5)
                      ],
                      name: "Raw Data",
                    )
                  ],
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                buttonFunction: () {
                  _zoomPanBehavior.panToDirection("left");
                },
                canHold: true,
              ),
              const SizedBox(width: 5),
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedArrowRight01,
                buttonFunction: () {
                  _zoomPanBehavior.panToDirection("right");
                },
                canHold: true,
              ),
              const SizedBox(width: 5),
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedSearchAdd,
                buttonFunction: () {
                  _zoomPanBehavior.zoomIn();
                },
                canHold: true,
              ),
              const SizedBox(width: 5),
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedSearchMinus,
                buttonFunction: () {
                  _zoomPanBehavior.zoomOut();
                },
                canHold: true,
              ),
              const SizedBox(width: 5),
              IconButtonWidget(
                icon: HugeIcons.strokeRoundedArrowTurnBackward,
                buttonFunction: () {
                  _zoomPanBehavior.reset();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_PointData> _generatePlaceholderData({required int count}) {
    final random = Random();
    List<_PointData> data = [];
    double baseValue = 20;

    for (int i = 0; i < count; i++) {
      double change = random.nextBool() ? 1.0 : -1.0;
      if (random.nextDouble() < 0.1) {
        change = (random.nextDouble() * 10 - 5);
      }

      baseValue += change;
      double roundedValue = double.parse(baseValue.toDouble().toStringAsFixed(2));
      data.add(_PointData(_formatTimeLabel(i.toDouble()), roundedValue));
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

    int r = ((1 - blendAmount) * red + blendAmount * secondaryColour.red).round();
    int g = ((1 - blendAmount) * green + blendAmount * secondaryColour.green).round();
    int b = ((1 - blendAmount) * blue + blendAmount * secondaryColour.blue).round();

    return Color.fromARGB(255, r, g, b);
  }
}
