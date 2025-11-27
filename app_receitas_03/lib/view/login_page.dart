// view/login_page.dart

import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../service/auth_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      },
    );

    // Tentar fazer login
    final result = await _authService.signIn(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    Navigator.pop(context);

    if (!result['success']) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erro no Login"),
            content: Text(result['error']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                const Icon(
                  Icons.restaurant_menu,
                  size: 100,
                  color: Colors.orange,
                ),
                const SizedBox(height: 30),
                Text(
                  'Livro de Receitas',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Seja bem-vindo!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
                const SizedBox(height: 40),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(onTap: signUserIn, text: "Entrar"),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não tem cadastro?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Registre-se agora!',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
