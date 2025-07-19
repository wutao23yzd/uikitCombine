import 'package:flutter/material.dart';
import 'package:follow_page/app_scaffold.dart';
import 'package:follow_page/follow/view/Tappable.dart';

class UserProfileButton extends StatelessWidget {
  const UserProfileButton({
    this.label,
    super.key,
    this.child,
    this.textStyle,
    this.padding,
    this.fadeStrength = FadeStrength.sm,
    this.color,
    this.onTap
  });

  final String? label;
  final Widget? child;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final FadeStrength fadeStrength;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Color.fromARGB(255, 224, 224, 224);
    final effectiveTextStyle = textStyle ?? context.theme.textTheme.labelLarge;
    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    return DefaultTextStyle(
      style: effectiveTextStyle!, 
      child: Tappable.faded(
        onTap: onTap,
        fadeStrength: fadeStrength,
        borderRadius: BorderRadius.circular(6),
        backgroundColor: effectiveColor,
        child: Padding(
          padding: effectivePadding,
          child: Align(
            child: child ?? 
            Text(
              label!,
              style: effectiveTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ));
  }
}
