import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class TextMessageWidget extends SingleChildRenderObjectWidget {
  const TextMessageWidget({
    required this.text,
    required super.child,
    super.key,
    this.textStyle,
    this.spacing
  });

  final String text;
  final TextStyle? textStyle;
  final double? spacing;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTextMessageWidget(text, textStyle, spacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTextMessageWidget renderObject
  ) {
    renderObject
      ..text = text
      ..textStyle = textStyle
      ..spacing = spacing;
  }
}

class RenderTextMessageWidget extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderTextMessageWidget(
    String text,
    TextStyle? textStyle,
    double? spacing
  ) : _text = text,
      _textStyle = textStyle,
      _spacing = spacing;
  String _text;
  TextStyle? _textStyle;
  double? _spacing;

  static const double _kOffset = 1.5;
  static const double _kFactor = .5;

  String get text => _text;
  set text(String value) {
    if (_text == value) return;
    _text = value;
    markNeedsLayout();
  }

  TextStyle? get textStyle => _textStyle;
  set textStyle(TextStyle? value) {
    if (_textStyle == value) return;
    _textStyle = value;
    markNeedsLayout();
  }

  double? get spacing => _spacing;
  set spacing(double? value) {
    if(_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  TextPainter textPainter = TextPainter();

  @override
  void performLayout() {
    size = _performLayout(constraints: constraints, dry: false);

    (child!.parentData! as BoxParentData).offset = Offset(
        size.width - child!.size.width,
        size.height - child!.size.height / _kOffset
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _performLayout(constraints: constraints, dry: true);
  }

  Size _performLayout({
    required BoxConstraints constraints,
    required bool dry
  }) {
    textPainter = TextPainter(
      text: TextSpan(text: _text, style: _textStyle),
      textDirection: ui.TextDirection.ltr
    );

    late final double spacing;
    if (_spacing == null) {
      spacing = constraints.maxWidth * 0.03;
    } else {
      spacing = _spacing!;
    }

    textPainter.layout(maxWidth: constraints.maxWidth);

    var height = textPainter.height;
    var width = textPainter.width;

    final lines = textPainter.computeLineMetrics();

    final lastLineWidth = lines.last.width;

    if (child != null) {
      late final Size childSize;

      if (!dry) {
        child!.layout(
          BoxConstraints(maxWidth: constraints.maxWidth),
          parentUsesSize: true
        );
        childSize = child!.size;
      } else {
        childSize = child!.getDryLayout(BoxConstraints(maxWidth: constraints.maxWidth));
      }

      if (lastLineWidth + spacing > constraints.maxWidth - child!.size.width) {
        height += childSize.height * _kFactor;
      } else if (lines.length == 1) {
        width += childSize.width + spacing;
      }
    }

    return Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    textPainter.paint(context.canvas, offset);
    final parentData = child!.parentData! as BoxParentData;
    context.paintChild(child!, offset + parentData.offset);
  }

}