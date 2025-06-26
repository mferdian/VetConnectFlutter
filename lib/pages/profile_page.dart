// profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/profile_model.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/utils/url_helper.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final user = controller.profile.value;

      if (user == null) {
        return const Scaffold(
          body: Center(child: Text("Data tidak ditemukan")),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(user),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/edit-profile',
                );
                if (result == true) {
                  controller.loadProfile(); // Refresh setelah edit
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Pesanan Saya'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.toNamed('/my-orders'),
            ),

            const Spacer(),
            _buildLogoutButton(context),
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  Widget _buildProfileHeader(ProfileModel user) {
    final photoUrl = UrlHelper.getFullImageUrl(user.foto);

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              (photoUrl.isNotEmpty)
                  ? NetworkImage(photoUrl)
                  : const AssetImage('assets/images/profile.jpg')
                      as ImageProvider,
          onBackgroundImageError: (_, __) {}, // Optional: suppress error logs
        ),
        const SizedBox(height: 10),
        Text(
          user.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          user.email,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        if (user.noTelp != null)
          Text(
            user.noTelp!,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          await AuthService.logout();
          Get.offAllNamed('/sign-in');
        } catch (e) {
          Get.snackbar("Logout Gagal", e.toString());
        }
      },
      child: const Text(
        'Log Out',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
