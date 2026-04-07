import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/providers/auth_provider.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/signup_screen.dart';
import '../expenses/screens/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadeRoute(const LoginScreen(), state),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) =>
            _fadeRoute(const SignupScreen(), state),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _fadeRoute(const HomeScreen(), state),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Page not found: ${state.error}')),
      ),
    ),
  );
});

CustomTransitionPage<T> _fadeRoute<T>(Widget child, GoRouterState state) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
