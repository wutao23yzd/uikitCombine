import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_views/l10n/l10n.dart';
import 'package:reel_views/packages/app_ui/app_theme.dart';
import 'package:reel_views/reels/bloc/reel_bloc.dart';
import 'package:reel_views/reels/model/posts_repository.dart';
import 'package:reel_views/reels/view/reels_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostsRepository(),
      child: MaterialApp(
        theme: const AppDarkTheme().theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (context) => ReelBloc(
            postsRepository: context.read<PostsRepository>()
          ),
          child: const ReelsView(),
        ),
      ),
    );
  }
}
