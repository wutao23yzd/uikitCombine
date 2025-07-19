// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppScaffold extends StatelessWidget {
  /// {@macro app_scaffold}
  const AppScaffold({
    required this.body,
    super.key,
    this.onPopInvokedWithResult,
    this.canPop,
    this.safeArea = true,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.releaseFocus = false,
    this.resizeToAvoidBottomInset = false,
    this.extendBody = false,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.bottomSheet,
    this.extendBodyBehindAppBar = false,
  });

  /// If true, will wrap the [body] with [SafeArea].
  final bool safeArea;

  /// If true, will enable top padding in safe area.
  final bool top;

  /// If true, will enable bottom padding in safe area.
  final bool bottom;

  ///  If true, will enable right padding in safe area.
  final bool right;

  /// If true, will enable left padding in safe area.
  final bool left;

  /// If true, will release the focus when the user taps outside of the
  /// text field.
  final bool releaseFocus;

  /// If true, will resize the body when the keyboard is shown.
  final bool resizeToAvoidBottomInset;

  /// The body of the scaffold.
  final Widget body;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// The floating action button of the scaffold.
  final Widget? floatingActionButton;

  /// The location of the floating action button of the scaffold.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// The bottom navigation bar of the scaffold.
  final Widget? bottomNavigationBar;

  /// The app bar of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The drawer of the scaffold.
  final Widget? drawer;

  /// The bottom sheet of the scaffold.
  final Widget? bottomSheet;

  /// Will pop callback. If null, will pop the navigator.
  final void Function(bool, dynamic)? onPopInvokedWithResult;

  /// If true, will pop the navigator.
  final bool? canPop;

  /// Wether to extend the body behind the bottom navigation bar.
  final bool extendBody;

  /// Wether to extend the body behind the app bar.
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    if (releaseFocus) {
      return GestureDetector(
        onTap: () => _releaseFocus(context),
        child: _MaterialScaffold(
          top: top,
          bottom: bottom,
          right: right,
          left: left,
          body: body,
          withSafeArea: safeArea,
          backgroundColor: backgroundColor,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
          appBar: appBar,
          drawer: drawer,
          bottomSheet: bottomSheet,
          onPopInvokedWithResult: onPopInvokedWithResult,
          canPop: canPop,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
        ),
      );
    }
    return _MaterialScaffold(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      body: body,
      withSafeArea: safeArea,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
      drawer: drawer,
      bottomSheet: bottomSheet,
      onPopInvokedWithResult: onPopInvokedWithResult,
      canPop: canPop,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class _MaterialScaffold extends StatelessWidget {
  const _MaterialScaffold({
    required this.top,
    required this.bottom,
    required this.right,
    required this.left,
    required this.body,
    required this.withSafeArea,
    required this.extendBody,
    required this.extendBodyBehindAppBar,
    this.canPop,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.appBar,
    this.drawer,
    this.bottomSheet,
    this.onPopInvokedWithResult,
  });

  final bool top;
  final bool bottom;
  final bool right;
  final bool left;
  final Widget body;
  final bool withSafeArea;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomSheet;
  final void Function(bool, dynamic)? onPopInvokedWithResult;
  final bool? canPop;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: withSafeArea
          ? SafeArea(
              top: top,
              bottom: bottom,
              right: right,
              left: left,
              child: body,
            )
          : body,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
      drawer: drawer,
      bottomSheet: bottomSheet,
    )
        .withPopScope(onPopInvokedWithResult, canPop: canPop)
        .withAdaptiveSystemTheme(context);
  }
}

/// Pop scope extension that wraps widget with [PopScope].
extension PopScopeX on Widget {
  /// Wraps widget with [PopScope].
  Widget withPopScope(
    void Function(bool, dynamic)? onPopInvokedWithResult, {
    bool? canPop,
  }) =>
      onPopInvokedWithResult == null && canPop == null
          ? this
          : PopScope(
              onPopInvokedWithResult: onPopInvokedWithResult,
              canPop: canPop ?? true,
              child: this,
            );
}


extension SystemNavigationBarTheme on Widget {
 
  Widget withAdaptiveSystemTheme(BuildContext context) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.theme.platform == TargetPlatform.android
            ? context.isLight
                ? SystemUiOverlayTheme.androidLightSystemBarTheme
                : SystemUiOverlayTheme.androidDarkSystemBarTheme
            : context.isLight
                ? SystemUiOverlayTheme.iOSDarkSystemBarTheme
                : SystemUiOverlayTheme.iOSLightSystemBarTheme,
        child: this,
      );
}

extension TextStyleExtension on BuildContext {
   ThemeData get theme => Theme.of(this);
}
extension BuildContextX on BuildContext {
  Brightness get brightness => theme.brightness;

  bool get isLight => brightness == Brightness.light;

   bool get isDark => !isLight;

  Color get adaptiveColor => isDark ? Color(0xFFFFFFFF) : Color(0xFF000000);
}

class SystemUiOverlayTheme {

  const SystemUiOverlayTheme();

  static const SystemUiOverlayStyle iOSLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle iOSDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static const SystemUiOverlayStyle androidLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Color(0xFFFFFFFF),
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle androidDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Color(0xFF000000),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static void setPortraitOrientation() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
  }

}