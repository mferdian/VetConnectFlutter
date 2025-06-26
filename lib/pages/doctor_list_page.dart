// pages/doctor_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/vet_controller.dart';
import 'package:flutter_application_1/pages/doctor_detail_page.dart';
import 'package:flutter_application_1/widgets/dokter_card.dart';

class DoctorListPage extends StatelessWidget {
  final vetController = Get.put(VetController());

  DoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Doctors', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: vetController.setSearchQuery,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search a Doctor',
                filled: true,
                fillColor: const Color.fromARGB(255, 235, 235, 235),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (vetController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (vetController.isError.value) {
                  return const Center(child: Text('Failed to load doctors.'));
                }
                final dokters = vetController.filteredDokters;
                if (dokters.isEmpty) {
                  return const Center(child: Text('No doctors found.'));
                }
                return ListView.builder(
                  itemCount: dokters.length,
                  itemBuilder: (context, index) {
                    final dokter = dokters[index];
                    return DokterCard(
                      dokter: dokter,
                      isCompact: false,
                     onTap: () => Get.to(() => DoctorDetailPage(dokterId: dokter.id)),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
