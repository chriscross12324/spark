import 'dart:math';

import 'package:flutter/material.dart';

class ZoomableChartWidget extends StatefulWidget {
  ZoomableChartWidget({super.key, required this.maxX, required this.builder});

  double maxX;
  Widget Function(double, double) builder;

  @override
  State<ZoomableChartWidget> createState() => ZoomableChartWidgetState();
}

class ZoomableChartWidgetState extends State<ZoomableChartWidget> {
  late double minX;
  late double maxX;

  final double minRange = 2.0;
  final double maxRange = 100.0;

  @override
  void initState() {
    super.initState();
    minX = 0;
    maxX = widget.maxX;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(minX, maxX);
  }

  void zoomIn() {
    setState(() {
      double range = maxX - minX;
      if (range > minRange * 2) {
        minX += range * 0.1;
        maxX -= range * 0.1;
      }
    });
  }

  void zoomOut() {
    setState(() {
      double range = maxX - minX;
      if (range < maxRange) {
        minX -= range * 0.1;
        maxX += range * 0.1;

        if (maxX > widget.maxX) {
          maxX = widget.maxX;
        }

        if (minX < 0) {
          minX = 0;
        }
      }
    });
  }

  void scrollLeft() {
    setState(() {
      double range = maxX - minX;
      minX = max(0, minX - range * 0.1);
      maxX = min(widget.maxX, minX + range);
    });
  }

  void scrollRight() {
    setState(() {
      double range = maxX - minX;
      maxX = min(widget.maxX, maxX + range * 0.1);
      minX = max(0, maxX - range);
    });
  }

  void adjustZoomAndScroll({double? newMinX, double? newMaxX}) {
    if (newMinX != null) {
      minX = newMinX;
    }
    if (newMaxX != null) {
      maxX = newMaxX;
    }
  }
}
