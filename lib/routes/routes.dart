import 'package:campusmarket/features/articles_details/presentation/screens/article_detail_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login.dart';
import '../features/auth/presentation/screens/signin.dart';

final router = GoRouter(
  initialLocation: "/article/0wSTO8cZyb3JjiuubeQa",
  routes: [
    GoRoute(path: '/', builder: (context, state) => Login()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(path: '/signin', builder: (context, state) => SignIn()),
    GoRoute(
      path: '/article/:id',
      builder: (context, state) {
        final articleId = state.pathParameters['id']!;
        return ArticleDetailScreen(id: "1McTD2yfzE4k1kP3Ks96");
      },
    ),
  ],
);
