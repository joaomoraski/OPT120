import 'dart:convert';

import 'package:frontend/services/BaseServiceApi.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<void> createUser(
      String nome, String email, String senha) async {
    try {
      final payload = {
        'name': nome,
        'email': email,
        'password': senha,
      };
      await BaseServiceApi.post('users/create', payload);
    } catch (e) {
      print('Erro ao criar usuario: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    final url = Uri.parse('http://localhost:3333/users');
    final response = await http.get(url); // espera a resposta
    if (response.statusCode == 200) {
      // Se deu bom decodifica o json para uma lista de tipo dinamico
      final List<dynamic> responseBody = jsonDecode(response.body);
      final List<Map<String, dynamic>> users =
          responseBody.map((user) => user as Map<String, dynamic>).toList();
      return users;
    } else {
      print('Algo de errado aconteceu: ${response.statusCode}');
    }
    return [];
  }
}
