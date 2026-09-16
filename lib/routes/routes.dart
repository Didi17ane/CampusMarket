import 'package:flutter/material.dart';
import '../core/navigation/main_shell.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login.dart';
import '../features/auth/presentation/screens/signup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/route_auth_provider.dart';
import '../features/auth/presentation/screens/profil_screen.dart';
import '../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';
import '../features/annonces/presentation/screens/publier_annonce_screen.dart';
import '../features/auth/presentation/screens/user_picture.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(routerAuthNotifierProvider);

  return GoRouter(
    initialLocation: '/', // L'application démarre bien sur l'accueil
    refreshListenable: authNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final bool isConnected = authNotifier.isConnected;
      final String currentLocation = state.matchedLocation;

      // Liste des pages privées qui nécessitent obligatoirement d'être connecté
      final bool isPrivateRoute =
          currentLocation == '/profil' ||
          currentLocation == '/publier' ||
          currentLocation == '/mes-annonces';

      // Si l'utilisateur n'est pas connecté et tente d'aller sur une page privée -> redirection Login
      if (!isConnected && isPrivateRoute) {
        return '/login';
      }

      // 3. Si l'utilisateur est connecté et tente d'aller sur Login/Signup -> redirection Accueil
      final bool isAuthRoute =
          currentLocation == '/login' || currentLocation == '/signup';
      if (isConnected && isAuthRoute) {
        return '/';
      }

      return null; // Pas de redirection pour le reste (ex: l'accueil '/')
    },
    routes: [
      // L'accueil principale accessible par tout le monde
      GoRoute(path: '/', builder: (context, state) => const MainShell()),

      // Authentification
      GoRoute(path: '/login', builder: (context, state) => const Login()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUp()),
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
