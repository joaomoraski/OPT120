import 'package:frontend/services/BaseServiceApi.dart' as ApiService;
import 'package:intl/intl.dart';

class ActivityService {
  static Future<void> createActivity(
      String titulo, String descricao, double nota, DateTime dataLimite) async {
    try {
      final payload = {
        'titulo': titulo,
        'descricao': descricao,
        'nota': nota,
        'dataLimite': DateFormat('yyyy-MM-dd').format(dataLimite),
      };
      await ApiService.BaseServiceApi.post('activity/', payload);
    } catch (e) {
      print('Error creating activity: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  static Future<void> updateActivity(int id, String titulo, String descricao,
      double nota, DateTime dataLimite) async {
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

  static Future<void> deleteActivity(int id) async {
    try {
      await ApiService.BaseServiceApi.delete('activity/$id');
    } catch (e) {
      print('Error deleting activity: $e');
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
    try {
      final response = await ApiService.BaseServiceApi.getList('activity/');
      return response;
    } catch (e) {
      print('Erro ao listar usuarios: $e');
      rethrow;
    }
  }
}
