
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone_app/app/view/app.dart';
import 'package:flutter_instagram_clone_app/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone_app/l10n/l10n.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/colors/app_colors.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/extensions/build_context_extension.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/spacing/app_spacing.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/widgets/app_snackbar.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  late TextEditingController _emailController;
  late FocusNode _emailFocusNode;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();

    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final showPassword = context.select((LoginCubit cubit) => cubit.state.showPassword);

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title: '出问题了',
              description:
                  loginSubmissionStatusMessage[state.status]!,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (p, c) => p.status != c.status,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.start,
              hintText: context.l10n.emailText,
              filled: true,
              fillColor: context.customReversedAdaptiveColor(
                dark: AppColors.darkGrey,
                light: AppColors.brightGrey,
              ),

            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<LoginCubit>().onEmailChanged(value);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.start,
              hintText: context.l10n.passwordText,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: context.customAdaptiveColor(light: AppColors.grey),
                ),
                onPressed: () {
                  context.read<LoginCubit>().changePasswordVisibility();
                },
              ),
              filled: true,
              fillColor: context.customReversedAdaptiveColor(
                dark: AppColors.darkGrey,
                light: AppColors.brightGrey,
              ),

            ),
            obscureText: !showPassword,

            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              context.read<LoginCubit>().onPasswordChanged(value);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}