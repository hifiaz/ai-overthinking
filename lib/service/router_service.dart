import 'package:ai_overthinking/page/ask_page.dart';
import 'package:ai_overthinking/page/home_page.dart';
import 'package:ai_overthinking/page/login_page.dart';
import 'package:ai_overthinking/page/register_page.dart';
import 'package:ai_overthinking/page/setting_page.dart';
import 'package:ai_overthinking/service/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

final router = GoRouter(
  refreshListenable: auth.isLoggedIn.toValueListenable(),
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        if (auth.currentUser.value.value == null) return '/login';
        return null;
      },
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingPage(),
        ),
        GoRoute(
          path: 'ask',
          builder: (context, state) => const AskPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);
