import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import '../services/authService.dart';

enum LoginMode { LOGIN, REGISTER }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginMode _loginMode = LoginMode.LOGIN;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> loginOrRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      final authService = AuthService();

      try {
        if (_loginMode == LoginMode.LOGIN) {
          final token = await authService.login(email, password);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          Navigator.pushReplacementNamed(context, '/');
        } else if (_loginMode == LoginMode.REGISTER) {
          final String name = nameController.text;
          await authService.register(
              name, email, password);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registrado com súcesso, faça o login'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void toggleLoginMode() {
    setState(() {
      _loginMode =
          _loginMode == LoginMode.LOGIN ? LoginMode.REGISTER : LoginMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRegisterMode = _loginMode == LoginMode.REGISTER;

    return Scaffold(
      appBar: AppBar(
        title: Text(_loginMode == LoginMode.LOGIN ? 'Login' : 'Registrar'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isRegisterMode)
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
              if (isRegisterMode) const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um e-mail';
                  } else if (!value.contains('@') || !value.contains('.')) {
                    return 'Por favor, insira um e-mail valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  } else if (value.length < 4) {
                    return 'Por favor, insira uma senha com 4 ou mais caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => loginOrRegister(context),
                child:
                    Text(_loginMode == LoginMode.LOGIN ? 'Login' : 'Registrar'),
              ),
              TextButton(
                onPressed: toggleLoginMode,
                child: Text(_loginMode == LoginMode.LOGIN
                    ? 'Criar conta'
                    : 'Fazer Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
