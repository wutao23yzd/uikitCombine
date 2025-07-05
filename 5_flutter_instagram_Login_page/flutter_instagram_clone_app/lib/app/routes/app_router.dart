import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_instagram_clone_app/app/bloc/app_bloc.dart';
import 'package:flutter_instagram_clone_app/app/routes/app_routes.dart';
import 'package:flutter_instagram_clone_app/auth/view/auth_page.dart';
import 'package:flutter_instagram_clone_app/home/home_page.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  const AppRouter(this.appBloc);

  final AppBloc appBloc;

  GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoutes.home.path,
        routes: [
          GoRoute(
            path: AppRoutes.auth.route,
            name: AppRoutes.auth.name,
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const AuthPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(
                    curve: Curves.easeInOut).animate(animation),
                  child: child,
                  );
              },
            ),
          ),
          GoRoute(
            path: AppRoutes.home.route,
            name: AppRoutes.home.name,
            builder: (context, state) {
              return const HomePage();
            }
          )
        ],
      redirect: (context, state) {
          final authenticated = appBloc.state.status == AppStatus.authenticated;
          final authenticating = state.matchedLocation == AppRoutes.auth.route;

          if (!authenticated) return AppRoutes.auth.route;
          if (authenticating && authenticated) return AppRoutes.home.route;

          return null;
        },
        refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
  );

}

class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((appState) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}