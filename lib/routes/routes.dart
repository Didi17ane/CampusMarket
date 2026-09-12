import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login.dart';
import '../features/auth/presentation/screens/signin.dart';
import '../core/navigation/main_shell.dart';
import '../features/auth/presentation/screens/profil_screen.dart';
import '../features/mes_annonces/presentation/screens/mes_annonces_screen.dart';

final router = GoRouter(
  // ⚠️ TEMPORAIRE : redirige direct vers /home pour tester Profil/Mes
  // annonces sans passer par le login. Remettre '/' une fois que l'auth
  // de N'Guessan sera fonctionnelle (pas juste l'UI).
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Login()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(path: '/signin', builder: (context, state) => SignIn()),
    GoRoute(path: '/home', builder: (context, state) => const MainShell()),
    GoRoute(path: '/profil', builder: (context, state) => const ProfilScreen()),
    GoRoute(path: '/mes-annonces', builder: (context, state) => const MesAnnoncesScreen()),
  ],
);