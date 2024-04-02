import 'dart:convert';

import 'package:frontend/services/BaseServiceApi.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/BaseServiceApi.dart' as ApiService;


class UserActivitiesService {
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

  static Future<List<Map<String, dynamic>>> fetchUsuariosFromAtividade() async {
    final url = Uri.parse('http://localhost:3333/userActivity');
    final response = await http.get(url); // espera a resposta
    if (response.statusCode == 200) {
      // Se deu bom decodifica o json para uma lista de tipo dinamico
      final List<dynamic> responseBody = jsonDecode(response.body);
      final List<Map<String, dynamic>> userActivities =
          responseBody.map((user) => user as Map<String, dynamic>).toList();
      return userActivities;
    } else {
      print('Algo de errado aconteceu: ${response.statusCode}');
    }
    return [];
  }

  static Future<void> updateUser(int id, String nome, String email, String password) async {
    try {
      final payload = {
        'nome': nome,
        'email': email,
        'password': password,
      };
      await ApiService.BaseServiceApi.put('users/$id', payload);
    } catch (e) {
      print('Error updating user: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<void> deleteUser(int id) async {
    try {
      await ApiService.BaseServiceApi.delete('users/$id');
    } catch (e) {
      print('Error deleting activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<Map<String, dynamic>> getUser(int id) async {
    try {
      return await ApiService.BaseServiceApi.get('users/$id');
    } catch (e) {
      print('Error getting activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

}

