// 2. RegisterController.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/register_api_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); 

  var isLoading = false.obs;
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void register(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi');
      return;
    }

    isLoading.value = true;

    try {
      final response = await RegisterService.register(
        name,
        email,
        password,
        password,
      );

      // Menggunakan flag untuk memastikan widget masih ada
      if (Get.isRegistered<RegisterController>()) {
        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Success",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Akun Anda berhasil dibuat",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Get.back(); // Menutup dialog
                        Navigator.pushReplacementNamed(context, '/sign-in'); // Gunakan GetX untuk navigasi dengan penghapusan semua route
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Lanjutkan"),
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );
        } else {
          final errorMessage = data['message'] ?? 'Terjadi kesalahan saat mendaftar';
          Get.defaultDialog(
            title: 'Registrasi Gagal',
            middleText: errorMessage,
            textConfirm: "Tutup",
            confirmTextColor: Colors.white,
            buttonColor: Colors.red,
            onConfirm: () => Get.back(),
          );
        }
      }
    } catch (e) {
      // Pastikan controller masih terdaftar sebelum menampilkan snackbar
      if (Get.isRegistered<RegisterController>()) {
        Get.snackbar("Error", "Terjadi kesalahan server: ${e.toString()}");
      }
    } finally {
      // Pastikan controller masih terdaftar sebelum mengubah isLoading
      if (Get.isRegistered<RegisterController>()) {
        isLoading.value = false;
      }
    }
  }
}