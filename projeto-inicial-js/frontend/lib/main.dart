import 'package:flutter/material.dart';
import 'package:frontend/pages/UsuarioPage.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Flutter Demo',
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => UsuariosScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Atividades'),
              onPressed: () {
                // TODO: Implementar navegação para página de atividades
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Usuário Atividade'),
              onPressed: () {
                // TODO: Implementar navegação para página de usuário atividade
              },
            ),
          ],
        ),
      ),
    );
  }
}
