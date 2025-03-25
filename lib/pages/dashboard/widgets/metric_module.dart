import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark/app_constants.dart';
import 'package:spark/models/sensor_data_model.dart';
import 'package:spark/widgets/common/segmented_control.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricModule extends ConsumerStatefulWidget {
  const MetricModule(this.metricTitle, this.data, {super.key});

  final String metricTitle;
  final List<SensorData> data;

  @override
  ConsumerState<MetricModule> createState() => _MetricModuleState();
}

class _MetricModuleState extends ConsumerState<MetricModule>
    with AutomaticKeepAliveClientMixin {
  //late List<SensorData> filteredData;
  CutoffRange selectedRange = CutoffRange.max;

  final Map<CutoffRange, String> cutoffRangeMap = {
    CutoffRange.max: "Max",
    CutoffRange.sevenDays: "7 days",
    CutoffRange.threeDays: "3 days",
    CutoffRange.twentyFourHours: "24 hours",
    CutoffRange.twelveHours: "12 hours",
    CutoffRange.threeHours: "3 hours",
  };

  @override
  void initState() {
    super.initState();
    //filteredData = widget.data;
  }

  /*void _updateFilter(CutoffRange range) {
    setState(() {
      selectedRange = range;
      final now = DateTime.now();
      DateTime cutoff;

      switch (range) {
        case CutoffRange.max:
          filteredData = widget.data;
          return;
        case CutoffRange.sevenDays:
          cutoff = now.subtract(const Duration(days: 7));
          break;
        case CutoffRange.threeDays:
          cutoff = now.subtract(const Duration(days: 3));
          break;
        case CutoffRange.twentyFourHours:
          cutoff = now.subtract(const Duration(days: 1));
          break;
        case CutoffRange.twelveHours:
          cutoff = now.subtract(const Duration(hours: 12));
          break;
        case CutoffRange.threeHours:
          cutoff = now.subtract(const Duration(hours: 3));
          break;
        case CutoffRange.fiveMinutes:
          cutoff = now.subtract(const Duration(minutes: 5));
          break;
        case CutoffRange.oneMinute:
          cutoff = now.subtract(const Duration(minutes: 1));
          break;
      }

      //print("Updated: ${widget.data.}");
      filteredData = widget.data
          .where((point) => point.timestamp.isAfter(cutoff))
          .toList();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Rebuilding...");
    DateTime cutoff = DateTime.fromMillisecondsSinceEpoch(0);

    if (widget.data.isNotEmpty) {
      final now = widget.data.elementAt(widget.data.length - 1).timestamp;

      switch (selectedRange) {
        case CutoffRange.max:
          cutoff = DateTime.fromMillisecondsSinceEpoch(0);
          break;
        case CutoffRange.sevenDays:
          cutoff = now.subtract(const Duration(days: 7));
          break;
        case CutoffRange.threeDays:
          cutoff = now.subtract(const Duration(days: 3));
          break;
        case CutoffRange.twentyFourHours:
          cutoff = now.subtract(const Duration(days: 1));
          break;
        case CutoffRange.twelveHours:
          cutoff = now.subtract(const Duration(hours: 12));
          break;
        case CutoffRange.threeHours:
          cutoff = now.subtract(const Duration(hours: 3));
          break;
        case CutoffRange.fiveMinutes:
          cutoff = now.subtract(const Duration(minutes: 5));
          break;
        case CutoffRange.oneMinute:
          cutoff = now.subtract(const Duration(minutes: 1));
          break;
      }

      print(cutoff);
    }



    //print("Updated: ${widget.data.}");
    var filteredData = widget.data
        .where((point) => point.timestamp.isAfter(cutoff))
        .toList();


    final labelStyle = GoogleFonts.asap(color: themeDarkSecondaryText);
    final gridLineStyle = MajorGridLines(
        color: themeDarkAccentColourFaded.withValues(alpha: 0.35));

    // Calculate Y-axis range
    double yMin = 0;
    double yMax = 0;
    if (filteredData.isNotEmpty) {
      yMin = filteredData.map((p) => p.value).reduce(min).floor() - 1;
      yMax = filteredData.map((p) => p.value).reduce(max).ceil() + 1;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            widget.metricTitle,
            style: GoogleFonts.asap(
              color: themeDarkPrimaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              SegmentedControl(
                options: cutoffRangeMap,
                selectedValue: selectedRange,
                onChanged: (CutoffRange value) {
                  setState(() {
                    selectedRange = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: filteredData.isEmpty
                ? Center(child: Text("No data available", style: TextStyle(color: Colors.white,),))
                : SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                      labelStyle: labelStyle,
                      majorGridLines: gridLineStyle,
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: yMin,
                      maximum: yMax,
                      interval: 2,
                      labelStyle: labelStyle,
                      majorGridLines: gridLineStyle,
                    ),
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
                    series: <CartesianSeries<SensorData, DateTime>>[
                      AreaSeries(
                        dataSource: filteredData,
                        xValueMapper: (SensorData data, _) => data.timestamp,
                        yValueMapper: (SensorData data, _) => data.value,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            themeDarkAccentColourMain.withValues(alpha: 0.25),
                            themeDarkAccentColourMain.withValues(alpha: 0.05),
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
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum CutoffRange {
  max,
  sevenDays,
  threeDays,
  twentyFourHours,
  twelveHours,
  threeHours,
  fiveMinutes,
  oneMinute,
}
