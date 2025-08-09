
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppTheme {

  const AppTheme();

  Brightness get brightness => Brightness.light;

  Color get backgroundColor => Colors.white;

  Color get primary => Colors.black;

  ThemeData get theme => FlexThemeData.light(
      scheme: FlexScheme.custom,
      colors: FlexSchemeColor.from(
        brightness: brightness,
        primary: primary,
        swapOnMaterial3: true
      ),
      useMaterial3: true,
      useMaterial3ErrorColors: true
    ).copyWith(
      textTheme: const TextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
        decorationColor: Colors.black
      ),
      iconTheme: const IconThemeData(
        color: Colors.black
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white
      )
  );
}

extension SystemNavigationBarTheme on Widget {
  Widget withSystemNavigationBarTheme() => 
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUIOverlayTheme.iOSLightSystemBarTheme,
      child: this,
  );
}


class SystemUIOverlayTheme {
  const SystemUIOverlayTheme();

  static const SystemUiOverlayStyle iOSLightSystemBarTheme = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light
  );
}

extension TextStyleExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;
}