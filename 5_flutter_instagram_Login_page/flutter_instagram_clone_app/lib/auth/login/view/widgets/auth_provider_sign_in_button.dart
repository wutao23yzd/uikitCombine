import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_instagram_clone_app/l10n/l10n.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/extensions/build_context_extension.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/extensions/text_style_extension.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/spacing/app_spacing.dart';
import 'package:flutter_instagram_clone_app/src/generated/assets.gen.dart';

enum AuthProvider {
  github('Github'),
  google('Google');

  const AuthProvider(this.value);

  final String value;
}

class AuthProviderSignInButton extends StatelessWidget {
  const AuthProviderSignInButton({
    required this.provider,
    super.key
  });

  final AuthProvider provider;

  @override
  Widget build(BuildContext context) {

    final effectiveIcon = switch (provider) {
      AuthProvider.github => Assets.icons.github.svg(),
      AuthProvider.google => Assets.icons.google.svg(),
    };

    final icon = SizedBox.square(
      dimension: 20,
      child: effectiveIcon,
    );

    return Container(
      constraints: BoxConstraints(
        minWidth: switch (context.screenWidth) {
          > 600 => context.screenWidth * 0.6,
          _ => context.screenWidth,
        },
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.focusColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        onPressed: () {
        
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: icon),
              const SizedBox(width: AppSpacing.sm), 
              Flexible(
                child: Text(
                  context.l10n.signInWithText(provider.value),
                  style: context.labelLarge?.copyWith(
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ),
            ]
          ),
      ),
      ),
    );
  }
}