import 'package:flutter/material.dart';
import 'package:frontend/pages/AtividadePage.dart';
import 'package:frontend/pages/UsuarioAtividadePage.dart';
import 'package:frontend/pages/UsuarioPage.dart';
import 'package:frontend/services/BaseServiceApi.dart';

void main() {
  BaseServiceApi.initialize('http://localhost:3333');
  runApp(const MaterialApp(
    title: 'CRUD Atividades',
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Usuários'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsuariosScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Atividades'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AtividadesScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Usuário Atividade'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsuarioAtividadesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
