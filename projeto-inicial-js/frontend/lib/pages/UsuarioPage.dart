import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/custom_data_table.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const UsuarioApp());

class UsuarioApp extends StatelessWidget {
  const UsuarioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UsuariosScreen(),
    );
  }
}

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    final response = await http.get(Uri.parse('http://localhost:3333/users'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      final List<Map<String, dynamic>> users =
      json.map((user) => user as Map<String, dynamic>).toList();
      setState(() {
        _usuarios = users;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTable(data: _usuarios, title: 'Lista de Usuários');
  }
}
