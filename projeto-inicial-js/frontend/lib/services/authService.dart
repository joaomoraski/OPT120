import 'package:frontend/services/BaseServiceApi.dart' as ApiService;


class AuthService {
  Future<String> login(String email, String password) async {
    try {
      final payload = {
        'email': email,
        'password': password
      };
      final response = await ApiService.BaseServiceApi.post('auth/login', payload);
      return response['token'];
    } catch (e) {
      print('Error making the login: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final payload = {
        'name': name,
        'email': email,
        'password': password
      };
      print(payload);
      await ApiService.BaseServiceApi.post('auth/register', payload);
    } catch (e) {
      print('Error making the login: $e');
      rethrow; // Re-throw the error to propagate it to the caller
    }
  }
}
