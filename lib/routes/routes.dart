import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login.dart';
import '../features/auth/presentation/screens/signin.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => Login()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(path: '/signin', builder: (context, state) => SignIn()),
  ],
);
