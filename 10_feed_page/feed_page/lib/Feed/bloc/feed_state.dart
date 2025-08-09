part of 'feed_bloc.dart';

enum FeedStatus {
  initial,
  loading,
  populated,
  failure,
}

@immutable
class FeedState extends Equatable {
  const FeedState._({
    required this.status,
    required this.blocks
  });

  const FeedState.initial()
      : this._(
        status: FeedStatus.initial, 
        blocks: const []
      );

  final List<PostBlock> blocks;
  final FeedStatus status;

  FeedState loading() => copyWith(status: FeedStatus.loading);
  FeedState populated({List<PostBlock>? blocks}) =>
   copyWith(status: FeedStatus.populated, blocks: blocks);

  FeedState copyWith({
    List<PostBlock>? blocks,
    FeedStatus? status
  }) {
    return FeedState._(
      status: status ?? this.status, 
      blocks: blocks ?? this.blocks
    );
  }

  @override
  List<Object?> get props => [blocks, status];
}
