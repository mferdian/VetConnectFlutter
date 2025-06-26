// controllers/doctor_detail_controller.dart
import 'package:get/get.dart';
import 'package:flutter_application_1/models/doctor.dart';
import 'package:flutter_application_1/services/vet_api_service.dart';

class DoctorDetailController extends GetxController {
  var dokter = Rxn<Dokter>();
  var isLoading = true.obs;
  var isError = false.obs;

  Future<void> fetchDokterById(int id) async {
    try {
      isLoading.value = true;
      isError.value = false;
      final result = await DokterService.getDokterById(id);
      dokter.value = result;
    } catch (e) {
      isError.value = true;
      print('Error in fetchDokterById: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
