import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:painting/models/PaintingModel.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

part 'painting_event.dart';
part 'painting_state.dart';

class PaintingBloc extends Bloc<PaintingEvent, PaintingState> {
  List<Color> colorList = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  static const int maxUndoStackSize = 30;

  PaintingBloc() : super(PaintingState(lines: [], lineColorIndex: 0, lineWidth: 10)) {
    on<PanStartEvent>((event, emit) {
      final newLine = PaintingModel(
          [event.point],
          state.lineWidth,
          1,
          1,
          false,
          colorList[state.lineColorIndex],
          1,
          true,
          state.isEraserMode
      );

      emit(state.copyWith(currentLine: newLine));
    });

    on<PanUpdateEvent>((event, emit) {
      if (state.currentLine == null) return;

      final updatedLine = state.currentLine!.copyWith(
        points: [...state.currentLine!.points, event.point]
      );

      emit(state.copyWith(currentLine: updatedLine));
    });

    on<PanEndEvent>((event, emit) {
      if (state.currentLine == null) return;

      final completedLine = state.currentLine!;

      emit(state.copyWith(
        lines: [...state.lines, completedLine],
        currentLine: null
      ));
    });

    on<UpdateLineColorIndexEvent>((event, emit) {
      if (event.lineColorIndex != state.lineColorIndex) {
        emit(state.copyWith(
            lineColorIndex: event.lineColorIndex
        ));
      }
    });

    on<RemoveLastLineEvent>((event, emit) {
      if (state.lines.isNotEmpty) {
        final List<PaintingModel> newLines = List.from(state.lines);
        final removed = newLines.removeLast();

        final List<PaintingModel> newUndoStack = List.from(state.undoStack);
        newUndoStack.add(removed);

        if (newUndoStack.length > PaintingBloc.maxUndoStackSize) {
          newUndoStack.removeAt(0);
        }

        emit(state.copyWith(
            lines: newLines,
            undoStack: newUndoStack
        ));
      }
    });

    on<ToggleEraserModeEvent>((event, emit) {
      emit(state.copyWith(isEraserMode: !state.isEraserMode));
    });

    on<RedoLastLineEvent>((event, emit) {
      if (state.undoStack.isNotEmpty) {
        final List<PaintingModel> newLines = List.from(state.lines);
        final List<PaintingModel> newUndoStack = List.from(state.undoStack);

        final redoLine = newUndoStack.removeLast();
        newLines.add(redoLine);

        emit(state.copyWith(
            lines: newLines,
            undoStack: newUndoStack
        ));
      }
    });

    on<UpdateLineWidthEvent>((event, emit) {
      emit(state.copyWith(lineWidth: event.lineWidth));
    });

    on<ClearAllEvent>((event, emit) {
      emit(state.copyWith(
        lines: [],
        undoStack: [],
        currentLine: null,
      ));
    });
  }
}
