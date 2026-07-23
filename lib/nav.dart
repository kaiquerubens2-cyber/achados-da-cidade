import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:achados_da_cidade/services/auth_service.dart';

class AppRouter {
  static GoRouter createRouter(AuthService authService) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Bem-vindo ao Achados da Cidade')),
          ),
        ),
      ],
    );
  }
}