import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class PaintingModel {

  List<PointVector> points;

  double size = 10;

  double thinning = 1;

  double smoothing = 1;

  bool isComplete = false;

  Color lineColor = Colors.black;

  double streamline;

  final bool simulatePressure;

  bool isEraser = false;

  PaintingModel(
      this.points,
      this.size,
      this.thinning,
      this.smoothing,
      this.isComplete,
      this.lineColor,
      this.streamline,
      this.simulatePressure,
      this.isEraser
  );

  PaintingModel copyWith({
    List<PointVector>? points,
    double? size,
    double? thinning,
    double? smoothing,
    bool? isComplete,
    Color? lineColor,
    double? streamline,
    bool? simulatePressure,
    bool? isEraser
  }) {
    return PaintingModel(
        points ?? this.points,
        size ?? this.size,
        thinning ?? this.thinning,
        smoothing ?? this.smoothing,
        isComplete ?? this.isComplete,
        lineColor ?? this.lineColor,
        streamline ?? this.streamline,
        simulatePressure ?? this.simulatePressure,
        isEraser ?? this.isEraser
    );
  }
}