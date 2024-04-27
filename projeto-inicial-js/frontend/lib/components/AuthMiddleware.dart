import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;

  const AuthMiddleware({required this.child});

  @override
  Widget build(BuildContext context) {
    // Verifica se o usuário está autenticado
    SharedPreferences.getInstance().then((prefs) {
      final String? token = prefs.getString('token');
      if (token == null) {
        // Se o token não estiver presente, redireciona para a tela de login
        Navigator.pushReplacementNamed(context, '/');
      }
    });
    return child;
  }
}
