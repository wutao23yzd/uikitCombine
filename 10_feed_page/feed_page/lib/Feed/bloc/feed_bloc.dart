import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_page/Feed/model/PostBlock.dart';
import 'package:feed_page/Feed/model/posts_repository.dart';
import 'package:meta/meta.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({
    required PostsRepository postsRepository
  }) :  _postsRepository = postsRepository,
       super(const FeedState.initial())  {

    on<FeedRecommendedPostsPageRequested>(_onFeedRecommendedPostsPageRequested);

  }

  final PostsRepository _postsRepository;

  Future<void> _onFeedRecommendedPostsPageRequested(
    FeedRecommendedPostsPageRequested event,
     Emitter<FeedState> emit,
  ) async {
    emit(state.loading());
    final recommendedBlocks = [...PostsRepository.recommendedPosts..shuffle()];
    emit(state.populated(blocks: recommendedBlocks));
  }
}
