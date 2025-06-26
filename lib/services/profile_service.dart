import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<ProfileModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return ProfileModel.fromJson(data);
    } else {
      throw Exception("Gagal memuat profil");
    }
  }

  static Future<bool> updateProfile({
    required String name,
    required String email,
    required String noTelp,
    required String umur,
    required String alamat,
    required String password,
    required String confirmPassword,
    File? profilePhoto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception("Token tidak ditemukan");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/profile/update'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['no_telp'] = noTelp;
    request.fields['umur'] = umur;
    request.fields['alamat'] = alamat;
    if (password.isNotEmpty) {
      request.fields['password'] = password;
      request.fields['password_confirmation'] = confirmPassword;
    }

    if (profilePhoto != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_photo', profilePhoto.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200;
  }
}
