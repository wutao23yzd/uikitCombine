import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone_app/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone_app/l10n/l10n.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/extensions/build_context_extension.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    ),
  );

  final isLoading = context.select((LoginCubit bloc) => bloc.state.status.isLoading);

  Widget _buildLoadingButton() {
    final effectiveIcon = Transform.scale(
      scale: 0.5,
      child: const CircularProgressIndicator(),
    );
    return ElevatedButton.icon(
      onPressed: () {}, 
      icon: effectiveIcon,
      style: style,
      label: Text(''));
  }

  Widget _buildAuthButton(BuildContext context) {
   return OutlinedButton(
      style: style,
      onPressed: () => context.read<LoginCubit>().submit(),
      child: DefaultTextStyle.merge(
        overflow: TextOverflow.ellipsis,
        child: Text(context.l10n.login, maxLines: 1),
      ),
    );
  }

  final child = switch (isLoading) {
    true => _buildLoadingButton(),
    false => _buildAuthButton(context),
  };

  return ConstrainedBox(  
    constraints: BoxConstraints(
      minWidth: switch (context.screenWidth) {
        > 600 => context.screenWidth * 0.6,
        _ => context.screenWidth,
      },
    ),
    child: child,
    );
  }
}