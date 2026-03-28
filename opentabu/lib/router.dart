import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'model/game_settings.dart';
import 'view/analytics_page.dart';
import 'view/game_page.dart';
import 'view/home_page.dart';
import 'view/rules_page.dart';
import 'view/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: GamePage(settings: state.extra! as GameSettings),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        final openPayment = state.extra as bool? ?? false;
        return CustomTransitionPage(
          child: SettingsPage(openPaymentDialog: openPayment),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: '/rules',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const RulesPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/analytics',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AnalyticsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
    ),
  ],
);
