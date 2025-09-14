import 'package:comments_page/app_ui/app_theme.dart';
import 'package:comments_page/comments/bloc/comments_bloc.dart';
import 'package:comments_page/comments/view/comment_view.dart';
import 'package:comments_page/comments/widgets/comment_input_controller.dart';
import 'package:comments_page/comments/widgets/comment_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({
    required this.scrollController,
    required this.draggableScrollableController,
    required this.snapLock,
    super.key
  });

  final ScrollController scrollController;
  final DraggableScrollableController draggableScrollableController;
  final ValueNotifier<bool>? snapLock;

  static CommentInheritedWidget of(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<CommentInheritedWidget>();
    return provider!;
  }

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late TextEditingController _commentTextController;
  late FocusNode _commentFocusNode;

  late CommentInputController _commentInputController;

  @override
  void initState() {
    super.initState();
    _commentTextController = TextEditingController();
    _commentFocusNode = FocusNode()..addListener(_commentFocusNodeListener);

    _commentInputController = CommentInputController()
      ..init(
          commentFocusNode: _commentFocusNode,
          commentTextController: _commentTextController
      );
  }

  void _commentFocusNodeListener() {
    if (_commentFocusNode.hasFocus) {
      if (!widget.draggableScrollableController.isAttached) return;
      if (widget.draggableScrollableController.size == 1) return;
      widget.draggableScrollableController.animateTo(1, duration: Duration(milliseconds: 250), curve: Curves.ease);
    }
  }

  @override
  void dispose() {
    _commentInputController..commentFocusNode..removeListener(_commentFocusNodeListener)..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isReplying = _commentInputController.isReplying;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final needLockFull = isKeyboardVisible && isReplying;
      if (widget.snapLock?.value != needLockFull) {
        widget.snapLock?.value = needLockFull;
      }
    });

    return BlocProvider(
      create: (context) => CommentsBloc()..add(const CommentsListRequested()),
      child: CommentInheritedWidget(
          commentInputController: _commentInputController,
          child: CommentsView(
            scrollController: widget.scrollController,
            scrollableSheetController: widget.draggableScrollableController,
          )),
    );
  }
}

class CommentsView extends StatelessWidget {
  const CommentsView({
    required this.scrollController,
    required this.scrollableSheetController,
    super.key
  });

  final ScrollController scrollController;
  final DraggableScrollableController scrollableSheetController;
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 24,
          title: Text(
             "评论",
            style: context.textTheme.titleLarge?.apply(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromRadius(12),
              child: SizedBox.shrink()),
        ),
        body: CommentsListView(scrollController: scrollController),
        bottomNavigationBar: CommentTextField(controller: scrollableSheetController),
      ),
    );
  }
}

class CommentsListView extends StatelessWidget {
  const CommentsListView({
    required this.scrollController,
    super.key
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final comments = context.select((CommentsBloc bloc) => bloc.state.comments);

    return CustomScrollView(
      cacheExtent: 2760,
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CommentView(comment: comment, isReplied: false);
            }
        )
      ],
    );
  }
}


