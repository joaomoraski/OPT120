import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/BaseServiceApi.dart' as ApiService;

class ActivityService {
  static Future<void> createActivity(String titulo, String descricao, double nota, DateTime dataLimite) async {
    try {
      final payload = {
        'titulo': titulo,
        'descricao': descricao,
        'nota': nota,
        'dataLimite': DateFormat('yyyy-MM-dd').format(dataLimite),
      };
      await ApiService.BaseServiceApi.post('activity/create', payload);
    } catch (e) {
      print('Error creating activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<void> updateActivity(int id, String titulo, String descricao, double nota, DateTime dataLimite) async {
    try {
      final payload = {
        'titulo': titulo,
        'descricao': descricao,
        'nota': nota,
        'dataLimite': DateFormat('yyyy-MM-dd').format(dataLimite),
      };
      await ApiService.BaseServiceApi.put('activity/$id', payload);
    } catch (e) {
      print('Error updating activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<Map<String, dynamic>> getActivity(int id) async {
    try {
      return await ApiService.BaseServiceApi.get('activity/$id');
    } catch (e) {
      print('Error getting activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<List<Map<String, dynamic>>> fetchActivities() async {
    final url = Uri.parse('http://localhost:3333/activity');
    final response = await http.get(url); // espera a resposta
    if (response.statusCode == 200) {
      // Se deu bom decodifica o json para uma lista de tipo dinamico
      final List<dynamic> responseBody = jsonDecode(response.body);
      final List<Map<String, dynamic>> activities =
          responseBody.map((activity) => activity as Map<String, dynamic>).toList();
      return activities;
    } else {
      print('Algo de errado aconteceu: ${response.statusCode}');
    }
    return [];
  }
}
