import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone_app/app/bloc/app_bloc.dart';
import 'package:flutter_instagram_clone_app/app/view/app_view.dart';
import 'package:flutter_instagram_clone_app/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone_app/auth/login/model/User.dart';
import 'package:flutter_instagram_clone_app/counter/counter.dart';
import 'package:flutter_instagram_clone_app/l10n/arb/app_localizations.dart';
import 'package:flutter_instagram_clone_app/packages/app_ui/widgets/app_snackbar.dart';
import 'package:flutter_instagram_clone_app/packages/authRepository/auth_repository.dart';

final snackbarKey = GlobalKey<AppSnackbarState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // 全局唯一的数据层
      create: (_) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AppBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        child: const AppView(),
      ),
    );
  }
}

void openSnackbar(
  SnackbarMessage message, {
  bool clearIfQueue = false,
  bool undismissable = false,
}) {
  snackbarKey.currentState
      ?.post(message, clearIfQueue: clearIfQueue, undismissable: undismissable);
}

void closeSnackbars() => snackbarKey.currentState?.closeAll();
