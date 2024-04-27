import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BaseServiceApi {
  static late String _baseUrl;

  static void initialize(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  static Future<Map<String, String>> mountHeadersWithAuth() async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    String? token = await getToken();

    if (token != null) {
      headers['Authorization'] = token;
    }

    return headers;
  }

  static Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$path'),
      headers: {...await mountHeadersWithAuth(), ...?headers},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform GET request');
    }
  }

  static Future<List<Map<String, dynamic>>> getList(String path,
      {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$path'),
      headers: {...await mountHeadersWithAuth(), ...?headers},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      final List<Map<String, dynamic>> dataList =
          responseBody.map((user) => user as Map<String, dynamic>).toList();
      return dataList;
    } else {
      throw Exception('Failed to perform GET request');
    }
  }

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> payload,
      {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$path'),
      headers: {...await mountHeadersWithAuth(), ...?headers},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform POST request');
    }
  }

  static Future<Map<String, dynamic>> put(
      String path, Map<String, dynamic> payload,
      {Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$path'),
      headers: {...await mountHeadersWithAuth(), ...?headers},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform PUT request');
    }
  }

  static Future<void> delete(String path,
      {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$path'),
      headers: {...await mountHeadersWithAuth(), ...?headers},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(jsonDecode(response.body)["message"]);
    }
  }
}
