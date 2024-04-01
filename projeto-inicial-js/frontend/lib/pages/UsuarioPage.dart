import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/entities/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/api.dart' as api;

class UsuarioPage extends StatelessWidget {
  const UsuarioPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: UsuariosScreen(title: title),
    );
  }
}

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key, required this.title});

  final String title;

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}
class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Usuario> _usuarios = [];
  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }
  Future<void> _fetchUsuarios() async {
    final apiUtils = api.ApiUtils();
    final List<Usuario> listUsuario = await apiUtils.fetchUsers();
    setState(() {
      _usuarios = listUsuario;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários'),
      ),
      body: ListView.builder(
        itemCount: _usuarios.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_usuarios[index].nome),
            subtitle: Text(_usuarios[index].email),
          );
        },
      ),
    );
  }
}