import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(UsuarioApp());

class UsuarioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    final response = await http.get(Uri.http('localhost:3333', '/users'));
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: DataTable(
        headingTextStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontFamily: 'Inter',
        ),
        columns: _usuarios.isNotEmpty
            ? _usuarios.first.keys
                .map((key) => DataColumn(label: Text(key.toUpperCase())))
                .toList()
            : [],
        rows: _usuarios
            .map((item) => DataRow(
                  cells: item.keys
                      .map((key) => DataCell(Text(item[key].toString())))
                      .toList(),
                ))
            .toList(),
      ),
    );
  }
}
