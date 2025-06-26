import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/jadwal.dart';

class BookingService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<String?> getToken() async {
    final box = GetStorage();
    return box.read('token');
  }

  static Future<List<Jadwal>> getJadwal(int vetId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/vets/$vetId/jadwal'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List jadwalList = data['jadwal'];
      return jadwalList.map((j) => Jadwal.fromJson(j)).toList();
    } else {
      throw Exception("Gagal mengambil jadwal");
    }
  }

  static Future<bool> bookAppointment({
    required int vetId,
    required int vetDateId,
    required int vetTimeId,
    required String keluhan,
    required int totalHarga,
    required String metodePembayaran,
  }) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception("Token tidak ditemukan");

      final response = await http
          .post(
            Uri.parse('$baseUrl/bookings'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "vet_id": vetId,
              "vet_date_id": vetDateId,
              "vet_time_id": vetTimeId,
              "keluhan": keluhan,
              "total_harga": totalHarga,
              "metode_pembayaran": metodePembayaran,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print("Booking response JSON: $jsonData");

        return jsonData['success'] == true;
      } else {
        print("Booking gagal dengan status: ${response.statusCode}");
        print("Response: ${response.body}");
        throw Exception("Gagal booking: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saat booking: $e");
      rethrow;
    }
  }
}
