// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class ApiUtils {
//   Future<List<Map<String, dynamic>>> fetchUsers() async {
//     final url = Uri.parse('http://localhost:3333/users');
//     final response = await http.get(url); // espera a resposta
//     if (response.statusCode == 200) {
//       // Se deu bom decodifica o json para uma lista de tipo dinamico
//       final List<dynamic> responseBody = jsonDecode(response.body);
//       final List<Map<String, dynamic>> users =
//           responseBody.map((user) => user as Map<String, dynamic>).toList();
//       return users;
//     } else {
//       print('Algo de errado aconteceu: ${response.statusCode}');
//     }
//     return [];
//   }
//
//   Future<List<Map<String, dynamic>>> fetchActivities() async {
//     final url = Uri.parse('http://localhost:3333/activity');
//     final response = await http.get(url); // espera a resposta
//     if (response.statusCode == 200) {
//       // Se deu bom decodifica o json para uma lista de tipo dinamico
//       final List<dynamic> responseBody = jsonDecode(response.body);
//       final List<Map<String, dynamic>> activities =
//           responseBody.map((activity) => activity as Map<String, dynamic>).toList();
//       return activities;
//     } else {
//       print('Algo de errado aconteceu: ${response.statusCode}');
//     }
//     return [];
//   }
// }
