// services/auth_service.dart
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<void> logout() async {
    final box = GetStorage();
    final token = box.read('token');

    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      box.remove('token');
    } else {
      throw Exception('Logout gagal: ${response.statusCode}');
    }
  }
}
