import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/jadwal.dart';
import 'package:flutter_application_1/services/booking_api_service.dart';
import 'package:get/get.dart';

class BookAppointmentController extends GetxController {
  final int doctorId;
  final int doctorPrice;

  BookAppointmentController({
    required this.doctorId,
    required this.doctorPrice,
  });

  var jadwalList = <Jadwal>[].obs;
  var selectedTanggal = Rx<Jadwal?>(null);
  var selectedJam = Rx<Waktu?>(null);
  var isLoading = false.obs;

  final keluhanController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchJadwal();
  }

  void fetchJadwal() async {
    try {
      final jadwals = await BookingService.getJadwal(doctorId);
      jadwalList.value = jadwals;
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil jadwal");
    }
  }

  void bookAppointment() async {
    if (selectedTanggal.value == null || selectedJam.value == null || keluhanController.text.isEmpty) {
      Get.snackbar("Validasi Gagal", "Isi semua data terlebih dahulu");
      return;
    }

    isLoading.value = true;

    final success = await BookingService.bookAppointment(
      vetId: doctorId,
      vetDateId: selectedTanggal.value!.tanggalId,
      vetTimeId: selectedJam.value!.waktuId,
      keluhan: keluhanController.text,
      totalHarga: doctorPrice,
      metodePembayaran: "cash",
    );

    isLoading.value = false;

    if (success) {
      Get.offAllNamed('/my-orders');
    } else {
      Get.snackbar("Gagal", "Booking gagal. Silakan coba lagi.");
    }
  }
}
