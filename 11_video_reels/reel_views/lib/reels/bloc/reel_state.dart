part of 'reel_bloc.dart';

enum ReelStatus {
  initial,
  loading,
  populated,
  failure
}

@immutable
class ReelState extends Equatable {
  const ReelState._({
    required this.status,
    required this.blocks
  });

  const ReelState.initial()
      : this._(
        status: ReelStatus.initial,
        blocks: const []
      );

  final List<PostReelBlock> blocks;
  final ReelStatus status;

  ReelState loading() => copyWith(status: ReelStatus.loading);
  ReelState populated({List<PostReelBlock>? blocks}) => 
    copyWith(status: ReelStatus.populated, blocks: blocks);
  ReelState failure() => copyWith(status: ReelStatus.failure);

  ReelState copyWith({
     List<PostReelBlock>? blocks,
     ReelStatus? status
  }) {
    return ReelState._(
      status: status ?? this.status,
      blocks: blocks ?? this.blocks
    );
  }

  @override
  List<Object> get props => [blocks, status];
}

