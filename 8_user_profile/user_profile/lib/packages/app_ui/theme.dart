import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:user_profile/packages/app_ui/app_colors.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppDarkTheme  {
  const AppDarkTheme();


  Brightness get brightness => Brightness.dark;


  Color get backgroundColor => AppColors.black;


  Color get primary => AppColors.white;


  TextTheme get textTheme {
    return const TextTheme().apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
      decorationColor: AppColors.white,
    );
  }


  ThemeData get theme => FlexThemeData.dark(
        scheme: FlexScheme.custom,
        darkIsTrueBlack: true,
        colors: FlexSchemeColor.from(
          brightness: brightness,
          primary: primary,
          appBarColor: AppColors.transparent,
          swapOnMaterial3: true,
        ),
        useMaterial3: true,
        useMaterial3ErrorColors: true,
      ).copyWith(
        textTheme: const AppDarkTheme().textTheme,
        iconTheme: const IconThemeData(color: AppColors.white),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.black,
          surfaceTintColor: AppColors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          surfaceTintColor: AppColors.background,
          backgroundColor: AppColors.background,
          modalBackgroundColor: AppColors.background,
        ),
      );
}