import 'package:flutter/material.dart';
import 'package:frontend/pages/UsuarioPage.dart'; // conjunto de widgets

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Atividades',
      initialRoute: '/users',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UsuarioPage(title: 'Listagem Usuários'),
      routes: {
        '/users': (context) => const UsuarioPage(title: 'Usuarios')
      },
    );
  }
}
