import 'package:flutter/material.dart';
import 'package:frontend/components/AuthMiddleware.dart';
import 'package:frontend/pages/AtividadePage.dart';
import 'package:frontend/pages/LoginPage.dart';
import 'package:frontend/pages/UsuarioAtividadePage.dart';
import 'package:frontend/pages/UsuarioPage.dart';
import 'package:frontend/services/BaseServiceApi.dart';
import 'package:frontend/services/authService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  BaseServiceApi.initialize('http://localhost:3333');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD Atividades',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(),
      routes: {
        '/usuarios': (context) => const AuthMiddleware(child: UsuarioPage()),
        '/atividades': (context) =>
            const AuthMiddleware(child: AtividadePage()),
        '/usuarioAtividades': (context) =>
            const AuthMiddleware(child: UsuarioAtividadesPage()),
        '/login': (context) => const LoginPage(),
        '/logout': (context) {
          // Remove o token das preferências compartilhadas
          SharedPreferences.getInstance().then((prefs) {
            prefs.remove('token');
            // Redireciona imediatamente para a tela de login
            Navigator.pushReplacementNamed(context, '/');
          });
          // Retorna um widget vazio enquanto a remoção do token é realizada
          return SizedBox();
        },
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

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
    return token != null;
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicação de usuário e atividades'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/logout');
            },
          ),
        ],
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

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            Navigator.pushReplacementNamed(context, '/');
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}


