import 'package:frontend/services/BaseServiceApi.dart' as ApiService;
import 'package:frontend/services/BaseServiceApi.dart';

class UserService {
  static Future<void> createUser(
      String nome, String email, String senha) async {
    try {
      final payload = {
        'name': nome,
        'email': email,
        'password': senha,
      };
      Map<String, dynamic> responseBody = await BaseServiceApi.post('users/', payload);
      print(responseBody);
    } catch (e) {
      print('Erro ao criar usuario: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await BaseServiceApi.getList('users/');
      return response;
    } catch (e) {
      print('Erro ao listar usuarios: $e');
      rethrow;
    }
  }

  static Future<void> updateUser(
      int id, String nome, String email, String password) async {
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
