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
    return MaterialApp(
      title: 'Aplicação de usuario e atividades',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Aplicação de usuario e atividades')),
          titleTextStyle: const TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20),
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
                    MaterialPageRoute(
                        builder: (context) => const UsuariosScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Atividades'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AtividadesScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Usuário Atividade'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UsuarioAtividadesScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      theme: ThemeData(
        primaryColor: Colors.blue,
        // Define a cor primária do aplicativo
        highlightColor: Colors.green,
        // Define a cor de destaque do aplicativo
        fontFamily: 'Roboto',
        // Define a fonte padrão do aplicativo
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 16.0),
                minimumSize: Size(200, 48),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)))),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Define a cor da barra de navegação
        ),
      ),
    );
  }
}
