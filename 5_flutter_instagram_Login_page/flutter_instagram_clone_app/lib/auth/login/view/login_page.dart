
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone_app/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone_app/auth/login/view/widgets/Sign_in_button.dart';
import 'package:flutter_instagram_clone_app/auth/login/view/widgets/app_logo.dart';
import 'package:flutter_instagram_clone_app/auth/login/view/widgets/auth_provider_sign_in_button.dart';
import 'package:flutter_instagram_clone_app/auth/login/view/widgets/loginForm.dart';
import 'package:flutter_instagram_clone_app/auth/login/view/widgets/sign_up_new_account_button.dart';
import 'package:flutter_instagram_clone_app/l10n/l10n.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/colors/app_colors.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/spacing/app_spacing.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/widgets/app_constrained_scroll_view.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/widgets/app_divider.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/widgets/app_scaffold.dart';
import 'package:flutter_instagram_clone_app/packages/authRepository/auth_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const LoginView(),
    );
  }
}


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxxlg * 2),
            const AppLogo(fit: BoxFit.fill, width: double.infinity),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoginForm(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {

                        }, 
                        child: Text(context.l10n.forgotText)),
                    ),
                  ),
                  const Align(
                    child: SignInButton(),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: AppDivider(
                          endIndent: AppSpacing.sm,
                          indent: AppSpacing.md,
                          color: AppColors.white,
                          height: 36,
                        )
                      ),
                      Text(
                        '或'
                      ),
                      Expanded(
                        child: AppDivider(
                          color: AppColors.white,
                          indent: AppSpacing.sm,
                          endIndent: AppSpacing.md,
                          height: 36,
                        )
                      )
                    ],
                  ),

                  const Align(
                    child: AuthProviderSignInButton(
                      provider: AuthProvider.google,
                    ),
                  ),

                  const Align(
                    child: AuthProviderSignInButton(
                      provider: AuthProvider.github,
                    ),
                  ),
                ],
              )
              ),
              const SignUpNewAccountButton()
          ],
        ),
      ),
    );
  }
}