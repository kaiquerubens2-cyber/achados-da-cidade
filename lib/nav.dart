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
          builder: (context, state) => WelcomeScreen(authService: authService),
        ),
      ],
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final AuthService authService;

  const WelcomeScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo ao Achados da Cidade',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar a navegação para a home ou dashboard do app
              },
              child: const Text('Entrar no App'),
            ),
          ],
        ),
      ),
    );
  }
}
