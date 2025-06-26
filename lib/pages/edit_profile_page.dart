import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/edit_profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Profile Photo Upload
                  Center(
                    child: Obx(() {
                      return GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            controller.pickImage(File(pickedFile.path));
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: controller.selectedImage.value != null
                              ? FileImage(controller.selectedImage.value!)
                              : null,
                          child: controller.selectedImage.value == null
                              ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                              : null,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("Name"),
                  _buildTextField(controller.nameController, "Enter your full name"),
                  const SizedBox(height: 15),
                  _buildLabel("Email"),
                  _buildTextField(controller.emailController, "Enter your email", email: true),
                  const SizedBox(height: 15),
                  _buildLabel("Phone Number"),
                  _buildTextField(controller.phoneController, "Enter your phone number", phone: true),
                  const SizedBox(height: 15),
                  _buildLabel("Age"),
                  _buildTextField(controller.ageController, "Enter your age", number: true),
                  const SizedBox(height: 15),
                  _buildLabel("Address"),
                  _buildTextField(controller.addressController, "Enter your address"),
                  const SizedBox(height: 15),
                  _buildLabel("Password (optional)"),
                  _buildTextField(controller.passwordController, "Enter your password", password: true),
                  const SizedBox(height: 15),
                  _buildLabel("Confirm Password"),
                  _buildTextField(controller.confirmPasswordController, "Confirm your password", password: true),
                  const SizedBox(height: 30),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    controller.updateProfile(context);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF497D74),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledBackgroundColor: const Color(0xFF497D74).withOpacity(0.6),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Text(
                                  "Save Changes",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                        ),
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool email = false,
    bool phone = false,
    bool number = false,
    bool password = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      keyboardType: email
          ? TextInputType.emailAddress
          : phone
              ? TextInputType.phone
              : number
                  ? TextInputType.number
                  : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if ((value == null || value.isEmpty) && !password) {
          return '${hint.replaceAll('Enter your ', '').replaceAll('Confirm your ', '')} tidak boleh kosong';
        }
        if (email && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value!)) {
          return 'Format email tidak valid';
        }
        if (phone && !RegExp(r"^\d{10,15}$").hasMatch(value!)) {
          return 'Nomor telepon harus 10-15 digit';
        }
        if (number) {
          int? age = int.tryParse(value!);
          if (age == null || age <= 0 || age > 120) {
            return 'Umur harus 1–120';
          }
        }
        if (password && value!.isNotEmpty && value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }
}