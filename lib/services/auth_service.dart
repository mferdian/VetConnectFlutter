// services/auth_service.dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      'https://vetconnectmob-production.up.railway.app/api';

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await prefs.remove('token');
      await prefs.remove('user_name');
      await prefs.remove('user_id');
    } else {
      throw Exception('Logout gagal: ${response.statusCode}');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_name');
    await prefs.remove('user_id');
  }
}
