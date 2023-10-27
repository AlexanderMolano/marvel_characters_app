import 'package:go_router/go_router.dart';
import 'package:marvel_characters_app/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: HomeScreen.routeName,
    ),
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),
  ],
);
