import 'package:comments_page/app_ui/app_theme.dart';
import 'package:flutter/material.dart';

import 'comments/view/comments_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: const AppTheme().theme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
            onPressed: () {
              showCommentList(context);
            },
            child: Text('评论')),
      ),
    );
  }

  void showCommentList(BuildContext context) {

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16)
          )
        ),
        showDragHandle: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isDismissible: true,
        useSafeArea: true,
        enableDrag: true,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (ctx) {
          final controller = DraggableScrollableController();
          final snapLock = ValueNotifier<bool>(false); // true 时只允许 1.0

          return ValueListenableBuilder<bool>(
            valueListenable: snapLock,
            builder: (context, locked, _) {
              return DraggableScrollableSheet(
                  controller: controller,
                  expand: false,
                  snap: true,
                  snapSizes: locked ? const [1.0] : const [0.6, 1.0],
                  initialChildSize: 1,
                  minChildSize:locked ? 1 : .4,
                  builder: (context, scrollController) {
                    return CommentsPage(
                      scrollController: scrollController,
                      draggableScrollableController: controller,
                      snapLock: snapLock,
                    );
                  }
              );
            },
          );
        }
    );
  }
}
