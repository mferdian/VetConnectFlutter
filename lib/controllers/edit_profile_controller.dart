import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/profile_service.dart';

class EditProfileController extends GetxController {
  var isLoading = false.obs;
  var selectedImage = Rxn<File>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void pickImage(File file) {
    selectedImage.value = file;
  }

  void updateProfile(BuildContext context) async {
    try {
      isLoading.value = true;

      final success = await ProfileService.updateProfile(
        name: nameController.text,
        email: emailController.text,
        noTelp: phoneController.text,
        umur: ageController.text,
        alamat: addressController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        profilePhoto: selectedImage.value,
      );

      if (success) {
        Get.back(result: true); // untuk trigger refresh di ProfilePage
        Get.snackbar('Sukses', 'Profil berhasil diperbarui');
      } else {
        Get.snackbar('Gagal', 'Profil gagal diperbarui');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
