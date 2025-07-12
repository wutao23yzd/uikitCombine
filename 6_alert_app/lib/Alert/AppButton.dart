import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.isDialogButton = false,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final bool isDialogButton;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isDialogButton) {
      if (isIOS) {
        return CupertinoDialogAction(
          onPressed: onPressed,
          isDefaultAction: isDefaultAction,
          isDestructiveAction: isDestructiveAction,
          child: Text(text, style: textStyle),
        );
      } else {
        return TextButton(
          onPressed: onPressed,
          child: Text(text, style: textStyle),
        );
      }
    }

    // For non-dialog usage, fallback to TextButton
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: textStyle),
    );
  }
}
