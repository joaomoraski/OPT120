import 'dart:convert';

import 'package:frontend/services/BaseServiceApi.dart' as ApiService;
import 'package:frontend/services/BaseServiceApi.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserActivitiesService {
  static Future<void> createUserActivity(
      List<Map<String, dynamic>> usuariosSelecionados,
      Map<String, dynamic>? atividadeSelecionada,
      double nota,
      DateTime dataEntrega) async {
    try {
      List<int> ids = [];
      for (var element in usuariosSelecionados) {
        ids.add(element['id']);
      }
      final payload = {
        'usuario_id': ids,
        'atividade_id': atividadeSelecionada?['id'],
        'nota': nota,
        'entrega': DateFormat('yyyy-MM-dd').format(dataEntrega),
      };
      await BaseServiceApi.post('userActivity/', payload);
    } catch (e) {
      print('Erro ao criar usuario: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUsuariosFromAtividade() async {
    try {
      final response = await ApiService.BaseServiceApi.getList('userActivity/');
      return response;
    } catch (e) {
      print('Erro ao listar usuarios: $e');
      rethrow;
    }
  }

  static Future<void> updateUserActivity(int id,
      List<Map<String, dynamic>> usuariosSelecionados,
      Map<String, dynamic>? atividadeSelecionada,
      double nota,
      DateTime dataEntrega) async {
    try {
      List<int> ids = [];
      for (var element in usuariosSelecionados) {
        ids.add(element['id']);
      }
      final payload = {
        'usuario_id': ids,
        'atividade_id': atividadeSelecionada?['id'],
        'nota': nota,
        'entrega': DateFormat('yyyy-MM-dd').format(dataEntrega),
      };
      await ApiService.BaseServiceApi.put('userActivity/$id', payload);
    } catch (e) {
      print('Error updating user: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<void> deleteUserActivity(int id) async {
    try {
      await ApiService.BaseServiceApi.delete('userActivity/$id');
    } catch (e) {
      print('Error deleting activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<Map<String, dynamic>> getUserActivity(int id) async {
    try {
      return await ApiService.BaseServiceApi.get('userActivity/$id');
    } catch (e) {
      print('Error getting activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }
}
