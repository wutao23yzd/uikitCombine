import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reel_views/reels/model/post_reel_block.dart';
import 'package:reel_views/reels/model/posts_repository.dart';

part 'reel_event.dart';
part 'reel_state.dart';

class ReelBloc extends Bloc<ReelEvent, ReelState> {
  ReelBloc({
    required PostsRepository postsRepository
  }) : _postsRepository = postsRepository,
      super(const ReelState.initial()) {
    on<ReelEvent>((event, emit) {
    
    });
    on<ReelRecommendedPostsPageRequested>(_onReelRecommendedPostsPageRequested);
  }

  final PostsRepository _postsRepository;


  Future<void> _onReelRecommendedPostsPageRequested(
    ReelRecommendedPostsPageRequested event,
    Emitter<ReelState> emit,
  ) async {
    emit(state.loading());
    final recommendedBlocks = [...PostsRepository.recommendedReels..shuffle()];
    emit(state.populated(blocks: recommendedBlocks));
  }
}
