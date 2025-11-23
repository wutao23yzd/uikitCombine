part of 'painting_bloc.dart';

sealed class PaintingEvent extends Equatable {
  const PaintingEvent();

  @override
  List<Object> get props => [];
}

class PanStartEvent extends PaintingEvent {
  final PointVector point;
  const PanStartEvent(this.point);

  @override
  List<Object> get props => [point];
}

class PanUpdateEvent extends PaintingEvent {
  final PointVector point;
  const PanUpdateEvent(this.point);

  @override
  List<Object> get props => [point];
}

class PanEndEvent extends PaintingEvent {}

class UpdateLineColorIndexEvent extends PaintingEvent {
  final int lineColorIndex;

  const UpdateLineColorIndexEvent(this.lineColorIndex);
}

class RemoveLastLineEvent extends PaintingEvent {
  const RemoveLastLineEvent();
}

class ToggleEraserModeEvent extends PaintingEvent {
  const ToggleEraserModeEvent();
}

class RedoLastLineEvent extends PaintingEvent {
  const RedoLastLineEvent();
}

class UpdateLineWidthEvent extends PaintingEvent {
  final double lineWidth;
  const UpdateLineWidthEvent(this.lineWidth);

  @override
  List<Object> get props => [lineWidth];
}

class ClearAllEvent extends PaintingEvent {
  const ClearAllEvent();
}