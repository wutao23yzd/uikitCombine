part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

final class CommentsListRequested extends CommentsEvent {
  const CommentsListRequested();
}
