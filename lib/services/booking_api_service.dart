import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/jadwal.dart';

class BookingService {
  static const String baseUrl =
      'https://vetconnectmob-production.up.railway.app/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Jadwal>> getJadwal(int vetId) async {
    final token = await getToken();
    if (token == null) throw Exception("Token tidak ditemukan");

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

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData['success']?.toString() == 'true';
      } else {
        throw Exception("Gagal booking: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saat booking: $e");
      rethrow;
    }
  }
}
