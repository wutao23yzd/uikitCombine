// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $LibGen {
  const $LibGen();

  /// Directory path: lib/assets
  $LibAssetsGen get assets => const $LibAssetsGen();
}

class $LibAssetsGen {
  const $LibAssetsGen();

  /// Directory path: lib/assets/icons
  $LibAssetsIconsGen get icons => const $LibAssetsIconsGen();

  /// Directory path: lib/assets/images
  $LibAssetsImagesGen get images => const $LibAssetsImagesGen();
}

class $LibAssetsIconsGen {
  const $LibAssetsIconsGen();

  /// File path: lib/assets/icons/add-button.svg
  SvgGenImage get addButton =>
      const SvgGenImage('lib/assets/icons/add-button.svg');

  /// File path: lib/assets/icons/chat_circle.svg
  SvgGenImage get chatCircle =>
      const SvgGenImage('lib/assets/icons/chat_circle.svg');

  /// File path: lib/assets/icons/check.svg
  SvgGenImage get check => const SvgGenImage('lib/assets/icons/check.svg');

  /// File path: lib/assets/icons/github.svg
  SvgGenImage get github => const SvgGenImage('lib/assets/icons/github.svg');

  /// File path: lib/assets/icons/google.svg
  SvgGenImage get google => const SvgGenImage('lib/assets/icons/google.svg');

  /// File path: lib/assets/icons/instagram-reel.svg
  SvgGenImage get instagramReel =>
      const SvgGenImage('lib/assets/icons/instagram-reel.svg');

  /// File path: lib/assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('lib/assets/icons/search.svg');

  /// File path: lib/assets/icons/setting.svg
  SvgGenImage get setting => const SvgGenImage('lib/assets/icons/setting.svg');

  /// File path: lib/assets/icons/trash.svg
  SvgGenImage get trash => const SvgGenImage('lib/assets/icons/trash.svg');

  /// File path: lib/assets/icons/user.svg
  SvgGenImage get user => const SvgGenImage('lib/assets/icons/user.svg');

  /// File path: lib/assets/icons/verified_user.svg
  SvgGenImage get verifiedUser =>
      const SvgGenImage('lib/assets/icons/verified_user.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    addButton,
    chatCircle,
    check,
    github,
    google,
    instagramReel,
    search,
    setting,
    trash,
    user,
    verifiedUser,
  ];
}

class $LibAssetsImagesGen {
  const $LibAssetsImagesGen();

  /// File path: lib/assets/images/chat-background_light_mask.png
  AssetGenImage get chatBackgroundLightMask =>
      const AssetGenImage('lib/assets/images/chat-background_light_mask.png');

  /// File path: lib/assets/images/chat_background_dark_mask.jpeg
  AssetGenImage get chatBackgroundDarkMask =>
      const AssetGenImage('lib/assets/images/chat_background_dark_mask.jpeg');

  /// File path: lib/assets/images/chat_background_light_overlay.png
  AssetGenImage get chatBackgroundLightOverlay => const AssetGenImage(
    'lib/assets/images/chat_background_light_overlay.png',
  );

  /// File path: lib/assets/images/image1.jpg
  AssetGenImage get image1 =>
      const AssetGenImage('lib/assets/images/image1.jpg');

  /// File path: lib/assets/images/image2.jpg
  AssetGenImage get image2 =>
      const AssetGenImage('lib/assets/images/image2.jpg');

  /// File path: lib/assets/images/image3.jpg
  AssetGenImage get image3 =>
      const AssetGenImage('lib/assets/images/image3.jpg');

  /// File path: lib/assets/images/image4.jpg
  AssetGenImage get image4 =>
      const AssetGenImage('lib/assets/images/image4.jpg');

  /// File path: lib/assets/images/image5.jpg
  AssetGenImage get image5 =>
      const AssetGenImage('lib/assets/images/image5.jpg');

  /// File path: lib/assets/images/image6.jpeg
  AssetGenImage get image6 =>
      const AssetGenImage('lib/assets/images/image6.jpeg');

  /// File path: lib/assets/images/image7.jpeg
  AssetGenImage get image7 =>
      const AssetGenImage('lib/assets/images/image7.jpeg');

  /// File path: lib/assets/images/instagram_text_logo.svg
  SvgGenImage get instagramTextLogo =>
      const SvgGenImage('lib/assets/images/instagram_text_logo.svg');

  /// File path: lib/assets/images/placeholder.png
  AssetGenImage get placeholder =>
      const AssetGenImage('lib/assets/images/placeholder.png');

  /// File path: lib/assets/images/profile_photo.png
  AssetGenImage get profilePhoto =>
      const AssetGenImage('lib/assets/images/profile_photo.png');

  /// File path: lib/assets/images/tony.jpeg
  AssetGenImage get tony => const AssetGenImage('lib/assets/images/tony.jpeg');

  /// List of all assets
  List<dynamic> get values => [
    chatBackgroundLightMask,
    chatBackgroundDarkMask,
    chatBackgroundLightOverlay,
    image1,
    image2,
    image3,
    image4,
    image5,
    image6,
    image7,
    instagramTextLogo,
    placeholder,
    profilePhoto,
    tony,
  ];
}

class Assets {
  const Assets._();

  static const $LibGen lib = $LibGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
