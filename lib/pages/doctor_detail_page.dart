// pages/doctor_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/vet_detail_controller.dart';
import 'package:flutter_application_1/pages/book_appointment_page.dart';

class DoctorDetailPage extends StatelessWidget {
  final int dokterId;

  DoctorDetailPage({super.key, required this.dokterId}) {
    final controller = Get.put(DoctorDetailController());
    controller.fetchDokterById(dokterId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorDetailController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Doctor Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isError.value || controller.dokter.value == null) {
          return const Center(child: Text('Failed to load doctor data.'));
        }

        final dokter = controller.dokter.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorProfileCard(dokter),
              const SizedBox(height: 24),
              _buildAboutSection(dokter),
              const SizedBox(height: 24),
              _buildPriceSection(dokter),
              const SizedBox(height: 32),
              _buildBookButton(dokter, context),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDoctorProfileCard(dokter) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              dokter.foto ?? '',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/profile.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dokter.nama, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Veterinarian', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.medical_services, 'STR Number', dokter.str),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.email, 'Email', dokter.email),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.location_on, 'Location', dokter.alamat, isMultiLine: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(dokter) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About Doctor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          dokter.deskripsi ?? 'No description available.',
          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
        ),
      ],
    ),
  );

  Widget _buildPriceSection(dokter) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Consultation Fee', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          'Rp ${dokter.harga.toString()}',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF497D74)),
        ),
        const SizedBox(height: 8),
        const Text('Per consultation session', style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    ),
  );

  Widget _buildBookButton(dokter, BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: () {
        Get.to(() => BookAppointmentPage(
          doctorId: dokter.id,
          doctorName: dokter.nama,
          doctorPrice: dokter.harga,
          imageUrl: dokter.foto,
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF497D74),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Book Appointment', style: TextStyle(fontSize: 18, color: Colors.white)),
    ),
  );

  Widget _buildDetailRow(IconData icon, String title, String value, {bool isMultiLine = false}) {
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Color(0xFF497D74), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
