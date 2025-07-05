import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone_app/app/bloc/app_bloc.dart';
import 'package:flutter_instagram_clone_app/app/routes/app_router.dart';
import 'package:flutter_instagram_clone_app/app/view/app.dart';
import 'package:flutter_instagram_clone_app/l10n/arb/app_localizations.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/theme/app_theme.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/widgets/app_snackbar.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = AppRouter(context.read<AppBloc>()).router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: routerConfig,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            AppSnackbar(key: snackbarKey),
          ],
        );
      },
    );
  }
}