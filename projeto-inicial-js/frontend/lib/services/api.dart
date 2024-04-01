import 'dart:convert';

import 'package:frontend/entities/usuario.dart';
import 'package:http/http.dart' as http;

class ApiUtils {
  Future<List<Usuario>> fetchUsers() async {
    // URL Da api
    final url = Uri.parse('http://localhost:3333/users');
    final response = await http.get(url); // espera a resposta
    print(response);
    if (response.statusCode == 200) {
      print(response.body);
      // Se deu bom decodifica o json para uma lista de tipo dinamico
      final List<dynamic> responseBody = jsonDecode(response.body);
      final List<Usuario> users =
          responseBody.map((user) => Usuario.fromJson(user)).toList();
      return users;
    } else {
      print('Algo de errado aconteceu: ${response.statusCode}');
    }
    return [];
  }
}
