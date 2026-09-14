import 'package:flutter/material.dart';
import '../core/navigation/main_shell.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login.dart';
import '../features/auth/presentation/screens/signup.dart';
import '../features/auth/presentation/screens/testconnect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/route_auth_provider.dart';
import '../features/auth/presentation/screens/profil_screen.dart';
import '../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';
import '../features/annonces/presentation/screens/publier_annonce_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(routerAuthNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final bool isConnected = authNotifier.isConnected;
      final bool logginPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isConnected && !logginPage) {
        return '/login';
      }

      if (isConnected && logginPage) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => TestConnect()),
      GoRoute(path: '/login', builder: (context, state) => const Login()),

      GoRoute(path: '/signup', builder: (context, state) => const SignIn()),
      GoRoute(path: '/home', builder: (context, state) => const MainShell()),
      GoRoute(
        path: '/profil',
        builder: (context, state) => const ProfilScreen(),
      ),
      GoRoute(
        path: '/mes-annonces',
        builder: (context, state) => const MesAnnoncesScreen(),
      ),
      GoRoute(
        path: '/publier',
        builder: (context, state) => const PublierAnnonceScreen(),
      ),
    ],
  );
});
