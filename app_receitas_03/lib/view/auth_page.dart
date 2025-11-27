// view/auth_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';
import 'login_page.dart';
import 'home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          // Usuário logado
          if (snapshot.hasData) {
            return HomePage();
          }
          // Usuário não logado
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
