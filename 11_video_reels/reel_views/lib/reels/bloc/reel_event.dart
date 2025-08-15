part of 'reel_bloc.dart';

@immutable
sealed class ReelEvent extends Equatable {
  const ReelEvent();

  @override
  List<Object?> get props => [];
}

final class ReelRecommendedPostsPageRequested extends ReelEvent {
  const ReelRecommendedPostsPageRequested();
}