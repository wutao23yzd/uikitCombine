import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_profile/packages/app_ui/app_colors.dart';

extension TextStyleExtension on BuildContext {

  ThemeData get theme => Theme.of(this);

   TextTheme get textTheme => theme.textTheme;

  TextStyle? get titleLarge => textTheme.titleLarge;

  TextStyle? get bodyLarge => textTheme.bodyLarge;

  TextStyle? get titleMedium => textTheme.titleMedium;

  TextStyle? get labelLarge => textTheme.labelLarge;

  TextStyle? get headlineSmall => textTheme.headlineSmall;

}


extension BuildContextX on BuildContext {

  Brightness get brightness => theme.brightness;

  bool get isLight => brightness == Brightness.light;

  bool get isDark => !isLight;

  Color customAdaptiveColor({Color? light, Color? dark}) =>
      isDark ? (light ?? AppColors.white) : (dark ?? AppColors.black);

  Color customReversedAdaptiveColor({Color? light, Color? dark}) =>
      isDark ? (dark ?? AppColors.black) : (light ?? AppColors.white);

  Color get adaptiveColor => isDark ? AppColors.white : AppColors.black;
}

class SystemUiOverlayTheme {

  const SystemUiOverlayTheme();

  static const SystemUiOverlayStyle iOSLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle iOSDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static const SystemUiOverlayStyle androidLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: AppColors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle androidDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: AppColors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

}