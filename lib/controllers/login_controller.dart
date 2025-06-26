// controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/login_api_service.dart';


class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  Future<void> login(BuildContext context) async {
    isLoading.value = true;

    final email = emailController.text;
    final password = passwordController.text;

    final success = await LoginService.login(email, password);

    isLoading.value = false;

    if (success) {
      // opsional: bisa langsung ambil nama user dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('user_name') ?? 'User';

      Get.snackbar('Success', 'Welcome, $userName!',
          snackPosition: SnackPosition.TOP);

      // navigasi ke halaman home
      Get.offAllNamed('/home'); // pastikan route '/home' sudah terdaftar
    } else {
      Get.snackbar('Login Gagal', 'Email atau password salah',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
