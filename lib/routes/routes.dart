import 'package:campusmarket/features/articles_details/presentation/screens/article_detail_screen.dart';
<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import '../core/navigation/main_shell.dart';
=======
import 'package:campusmarket/features/articles_details/presentation/widgets/star_rating.dart';
>>>>>>> Stashed changes
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login.dart';
import '../features/auth/presentation/screens/signup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/route_auth_provider.dart';
import '../features/auth/presentation/screens/profil_screen.dart';
import '../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';
import '../features/annonces/presentation/screens/publier_annonce_screen.dart';

<<<<<<< Updated upstream
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

      //  Si l'utilisateur est connecté et tente d'aller sur Login/Signu p -> redirection Accueil
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
=======
final router = GoRouter(
  // ⚠️ TEMPORAIRE : redirige direct vers /home pour tester Profil/Mes
  // annonces sans passer par le login. Remettre '/' une fois que l'auth
  // de N'Guessan sera fonctionnelle (pas juste l'UI).
  initialLocation: '/article/1McTD2yfzE4k1kP3Ks96/vendeur_etudiant_id_999',
  // initialLocation: '/star',

  routes: [
    GoRoute(path: '/', builder: (context, state) => Login()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(path: '/signin', builder: (context, state) => SignIn()),
    GoRoute(path: '/home', builder: (context, state) => const MainShell()),
    GoRoute(path: '/profil', builder: (context, state) => const ProfilScreen()),
    GoRoute(
      path: '/mes-annonces',
      builder: (context, state) => const MesAnnoncesScreen(),
    ),
    GoRoute(
      path: '/publier',
      builder: (context, state) => const PublierAnnonceScreen(),
    ),
    GoRoute(
      path: '/publier',
      builder: (context, state) => const PublierAnnonceScreen(),
    ),
    GoRoute(
      path: '/article/:articleId/:vendeurId',
      builder: (context, state) {
        final articleId = state.pathParameters['articleId']!;
        final vendeurId = state.pathParameters['vendeurId']!;
        return ArticleDetailScreen(
          articleId: '1McTD2yfzE4k1kP3Ks96',
          vendeurId: 'vendeur_etudiant_id_999',
        );
      },
    ),
  ],
);
>>>>>>> Stashed changes
