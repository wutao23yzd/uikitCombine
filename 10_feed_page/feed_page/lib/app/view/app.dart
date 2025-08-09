import 'package:feed_page/Feed/bloc/feed_bloc.dart';
import 'package:feed_page/Feed/model/posts_repository.dart';
import 'package:feed_page/Feed/view/feed_page.dart';
import 'package:feed_page/l10n/l10n.dart';
import 'package:feed_page/packages/app_ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostsRepository(),
      child: MaterialApp(
        theme: const AppTheme().theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (context) => FeedBloc(
            postsRepository: context.read<PostsRepository>()
          ),
          child: const FeedPage(),
        ),
      ),
    );
  }
}
