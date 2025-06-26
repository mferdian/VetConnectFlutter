import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/book_appointment_controller.dart';
import 'package:flutter_application_1/models/jadwal.dart';
import 'package:get/get.dart';

class BookAppointmentPage extends StatelessWidget {
  final int doctorId;
  final String doctorName;
  final String imageUrl;
  final int doctorPrice;

  const BookAppointmentPage({
    Key? key,
    required this.doctorId,
    required this.doctorName,
    required this.imageUrl,
    required this.doctorPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BookAppointmentController(
      doctorId: doctorId,
      doctorPrice: doctorPrice,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking untuk $doctorName'),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildDropdownTanggal(c),
              const SizedBox(height: 12),
              _buildDropdownWaktu(c),
              const SizedBox(height: 12),
              TextField(
                controller: c.keluhanController,
                decoration: const InputDecoration(
                  labelText: 'Keluhan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Total Harga: Rp $doctorPrice',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: c.isLoading.value ? null : c.bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF497D74),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: c.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Booking Sekarang'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDropdownTanggal(BookAppointmentController c) {
    return Obx(() {
      return DropdownButtonFormField<Jadwal>(
        value: c.selectedTanggal.value,
        items: c.jadwalList.map((item) {
          final tgl = DateTime.parse(item.tanggal);
          final label = "${tgl.day}-${tgl.month}-${tgl.year}";
          return DropdownMenuItem<Jadwal>(
            value: item,
            child: Text(label),
          );
        }).toList(),
        onChanged: (value) {
          c.selectedTanggal.value = value;
          c.selectedJam.value = null;
        },
        decoration: const InputDecoration(
          labelText: 'Pilih Tanggal',
          border: OutlineInputBorder(),
        ),
      );
    });
  }

  Widget _buildDropdownWaktu(BookAppointmentController c) {
    return Obx(() {
      final waktuList = c.selectedTanggal.value?.waktu ?? [];
      return DropdownButtonFormField<Waktu>(
        value: c.selectedJam.value,
        items: waktuList.map((w) {
          return DropdownMenuItem<Waktu>(
            value: w,
            child: Text(w.jam),
          );
        }).toList(),
        onChanged: (value) => c.selectedJam.value = value,
        decoration: const InputDecoration(
          labelText: 'Pilih Waktu',
          border: OutlineInputBorder(),
        ),
      );
    });
  }
}
