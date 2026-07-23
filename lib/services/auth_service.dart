import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool get isAuthenticated => true; // Ajuste conforme sua lógica de login
  
  Future<void> init() async {
    // Inicialização do auth
  }
}