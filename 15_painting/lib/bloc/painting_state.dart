part of 'painting_bloc.dart';

final class PaintingState extends Equatable {
  const PaintingState({
    required this.lines,
    this.currentLine,
    required this.lineColorIndex,
    this.isEraserMode = false,
    this.undoStack = const [],
    required this.lineWidth
  });

  final List<PaintingModel> lines;
  final List<PaintingModel> undoStack;
  final PaintingModel? currentLine;
  final int lineColorIndex;
  final bool isEraserMode;
  final double lineWidth;

  @override
  List<Object?> get props => [
    lines,
    currentLine,
    lineColorIndex,
    isEraserMode,
    undoStack,
    lineWidth
  ];

  PaintingState copyWith({
    List<PaintingModel>? lines,
    PaintingModel? currentLine,
    Color? color,
    int? lineColorIndex,
    bool? isEraserMode,
    List<PaintingModel>? undoStack,
    double? lineWidth
  }) => PaintingState(
      lines: lines ?? this.lines,
      currentLine: currentLine,
      lineColorIndex: lineColorIndex ?? this.lineColorIndex,
      isEraserMode: isEraserMode ?? this.isEraserMode,
      undoStack: undoStack ?? this.undoStack,
      lineWidth: lineWidth ?? this.lineWidth
  );
}
