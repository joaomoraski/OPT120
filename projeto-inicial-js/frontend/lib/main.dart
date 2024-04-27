import 'package:flutter/material.dart';
import 'package:frontend/pages/UsuarioPage.dart';
import 'package:frontend/pages/AtividadePage.dart';
import 'package:frontend/pages/UsuarioAtividadePage.dart';
import 'package:frontend/services/BaseServiceApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Atividades',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(),
      routes: {
        '/usuarios': (context) => const UsuarioPage(),
        '/atividades': (context) => const AtividadePage(),
        '/usuarioAtividades': (context) => const UsuarioAtividadesPage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return const MyHomePage();
          } else {
            return const LoginPage();
          }
        }
      },
    );
  }

  Future<bool> checkAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // Aqui você pode implementar a lógica para verificar se o token é válido
    // Por exemplo, enviar o token para o backend para verificar sua validade
    return token != null;
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicação de usuário e atividades'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/usuarios');
              },
              child: const Text('Usuários'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/atividades');
              },
              child: const Text('Atividades'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/usuarioAtividades');
              },
              child: const Text('Usuário Atividade'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'Senha'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implemente a lógica de autenticação aqui
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Nome'),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(labelText: 'Senha'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implemente a lógica de cadastro aqui
            },
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }
}
