import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDarkTheme {

  const AppDarkTheme();

  Brightness get brightness => Brightness.dark;

  Color get backgroundColor =>const Color(0xFF000000);

  Color get primary => const Color(0xFFFFFFFF);

  TextTheme get textTheme {
    return const TextTheme().apply(
      bodyColor: const Color(0xFFFFFFFF),
      displayColor: const Color(0xFFFFFFFF),
      decorationColor:  const Color(0xFFFFFFFF),
    );
  }

  ThemeData get theme => FlexThemeData.dark(
    scheme: FlexScheme.custom,
    darkIsTrueBlack: true,
    colors: FlexSchemeColor.from(
      brightness: brightness,
      primary: primary,
      appBarColor: const Color(0x00000000),
      swapOnMaterial3: true
    )
  ).copyWith(
    textTheme: const AppDarkTheme().textTheme,
    iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF000000),
      surfaceTintColor: Color(0xFF000000)
    )
  );
}

extension TextStyleExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;
}


class SystemUiOverlayTheme {

  const SystemUiOverlayTheme();

  static const SystemUiOverlayStyle iOSDarkSystemBarTheme = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light
  );

  static const SystemUiOverlayStyle androidDarkSystemBarTheme = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Color(0xFF000000),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light
  );
}

extension SystemNavigationBarTheme on Widget {
  Widget withAdaptiveSystemTheme(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: context.theme.platform == TargetPlatform.android 
    ? SystemUiOverlayTheme.androidDarkSystemBarTheme 
    : SystemUiOverlayTheme.iOSDarkSystemBarTheme,
    child: this,
  );
}