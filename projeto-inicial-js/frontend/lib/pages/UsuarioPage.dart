import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/entities/usuario.dart';
import 'package:http/http.dart' as http;

void main() => runApp(UsuarioApp());

class UsuarioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: UsuariosScreen(),
    );
  }
}

class UsuariosScreen extends StatefulWidget {
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
    final response = await http.get(Uri.http('localhost:3333', '/users'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        _usuarios = json.map((item) => Usuario.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load books');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: ListView.builder(
        itemCount: _usuarios.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("${_usuarios[index].id} - ${_usuarios[index].nome}"),
            subtitle: Text(_usuarios[index].email),
          );
        },
      ),
    );
  }
}