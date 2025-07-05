
import 'package:flutter/widgets.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/extensions/build_context_extension.dart';
import 'package:flutter_instagram_clone_app/src/generated/generated.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    required this.fit,
    super.key,
    this.width,
    this.height,
    this.color,
    });

  final double? width;

  final double? height;

  final BoxFit fit;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Assets.images.instagramTextLogo.svg(
      height: height ?? 50,
      width: width ?? 200,
      fit: fit,
      colorFilter: ColorFilter.mode(
        color ?? context.adaptiveColor, 
        BlendMode.srcIn)
    );
  }
}