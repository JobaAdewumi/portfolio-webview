import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_webview/ui/screens/home/home.dart';
import 'package:portfolio_webview/ui/screens/onboarding/onboarding.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static String onboarding = '/';
  static String home = '/home';
}

final appRouter = GoRouter(
    // redirect: _handleRedirect,
    routes: [
      AppRoute(ScreenPaths.onboarding, (s) => const OnboardingScreen()),
      AppRoute(ScreenPaths.home, (s) => const HomeScreen()),
    ]);

class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}
