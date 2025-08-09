import 'package:flutter/material.dart';
import 'package:user_profile/l10n/l10n.dart';
import 'package:user_profile/packages/app_ui/app_colors.dart' show AppColors;
import 'package:user_profile/packages/app_ui/theme.dart';
import 'package:user_profile/user_profile/view/user_profile_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppDarkTheme().theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: UserProfilePage(),
    );
  }
}
