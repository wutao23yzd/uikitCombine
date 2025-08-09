part of 'feed_bloc.dart';


sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

final class FeedRecommendedPostsPageRequested extends FeedEvent {
  const FeedRecommendedPostsPageRequested();
}