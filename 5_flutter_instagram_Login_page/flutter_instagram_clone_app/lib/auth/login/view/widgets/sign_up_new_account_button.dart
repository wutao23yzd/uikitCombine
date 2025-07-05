
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone_app/l10n/l10n.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/colors/app_colors.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/extensions/text_style_extension.dart';

class SignUpNewAccountButton extends StatelessWidget {
  const SignUpNewAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
   
    return TextButton(
      onPressed: () {}, 
      child: Text.rich(
        overflow: TextOverflow.visible,
        style: context.bodyMedium,
        TextSpan(
          children: [
            TextSpan(text: '${context.l10n.noAccountText} '),
            TextSpan(
              text: context.l10n.signUpText,
              style: context.bodyMedium?.copyWith(color: AppColors.blue),
            ),
          ],
        ),
      ),
      );
  }
}