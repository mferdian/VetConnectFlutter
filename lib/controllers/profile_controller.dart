import 'package:get/get.dart';
import 'package:flutter_application_1/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  var profile = Rx<ProfileModel?>(null);
  var isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('Token digunakan di loadProfile: $token'); // untuk debug

      final response = await http.get(
        Uri.parse(
          'https://vetconnectmob-production.up.railway.app/api/profile',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        profile.value = ProfileModel.fromJson(data['data']);
      } else {
        print('Gagal mengambil profil: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat ambil profil: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
