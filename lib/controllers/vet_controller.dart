// controllers/vet_controller.dart
import 'package:get/get.dart';
import 'package:flutter_application_1/models/doctor.dart';
import 'package:flutter_application_1/services/vet_api_service.dart';

class VetController extends GetxController {
  var dokters = <Dokter>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var searchQuery = ''.obs;

  List<Dokter> get filteredDokters {
    if (searchQuery.value.isEmpty) return dokters;
    return dokters
        .where(
          (d) => d.nama.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    fetchDokters();
    super.onInit();
  }

  void fetchDokters() async {
    try {
      isLoading.value = true;
      isError.value = false;
      final response = await DokterService.getAllDokters();
      if (response.success) {
        dokters.value = response.data;
      } else {
        isError.value = true;
      }
    } catch (e) {
      print("Error: $e");
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
