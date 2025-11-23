import 'package:flutter/material.dart';
import 'package:painting/models/PaintingModel.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class Sketcher extends CustomPainter {
  final List<PaintingModel> lines;

  Sketcher({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    final layer = canvas.saveLayer(Offset.zero & size, Paint());

    Paint paint = Paint();
    List<Offset> outlinePoints = [];

    for (int i = 0; i < lines.length; ++i) {
      if (lines[i].isEraser) {
        paint = Paint()
          ..color = Colors.transparent
          ..blendMode = BlendMode.clear;
      } else {
        paint = Paint()
          ..color = lines[i].lineColor
          ..blendMode = BlendMode.srcOver;
      }

      StrokeOptions options = StrokeOptions(
        size: lines[i].size,
        thinning: 1,
        smoothing: 1,
        streamline: 1,
        simulatePressure: true,
        isComplete: lines[i].isComplete,
        start: StrokeEndOptions.start(cap: true),
        end: StrokeEndOptions.end(cap: true)
      );

      outlinePoints = getStroke(lines[i].points,options: options);

      final path = Path();

      if (outlinePoints.isEmpty == true) {
        return;
      } else if (outlinePoints.length  < 2) {

        path.addOval(Rect.fromCircle(
            center: Offset(outlinePoints[0].dx, outlinePoints[0].dy), radius: 1));
      } else {

        path.moveTo(outlinePoints[0].dx, outlinePoints[0].dy);

        for (int i = 1; i < outlinePoints.length - 1; ++i) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(
              p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        }
      }

      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}