part of 'comments_bloc.dart';

class CommentsState extends Equatable {
  const CommentsState({ required this.comments });

  const CommentsState.initial()
      : this(comments: const []);

  final List<Comment> comments;

  @override
  List<Object> get props => [comments];

  CommentsState copyWith({
    List<Comment>? comments
  }) {
    return CommentsState(comments: comments ?? this.comments);
  }
}
