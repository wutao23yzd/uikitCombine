import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/comment.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(const CommentsState.initial()) {
    on<CommentsListRequested>(_commentsListRequested);
  }

  Future<void> _commentsListRequested(
    CommentsListRequested event,
    Emitter<CommentsState> emit
  ) async {
    final commentList = Comment.commentList;
    emit(state.copyWith(comments: commentList));
  }
}
