import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login.dart';
import '../features/auth/presentation/screens/signup.dart';
import '../features/auth/presentation/screens/testconnect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/route_auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(routerAuthNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final bool isConnected = authNotifier.isConnected;
      final bool logginPage = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (!isConnected && !logginPage) {
        return '/login';
      }

      if (isConnected && logginPage) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => TestConnect()),
      GoRoute(path: '/login', builder: (context, state) => Login()),
      GoRoute(path: '/signin', builder: (context, state) => SignIn()),
    ],
  );
});
