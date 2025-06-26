import 'dart:convert';
import 'package:flutter_application_1/models/doctor.dart';
import 'package:flutter_application_1/models/jadwal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DokterService {
  static const String baseUrl =
      'https://vetconnectmob-production.up.railway.app/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetch semua dokter
  static Future<DokterResponse> getAllDokters() async {
    try {
      final token = await getToken();

      if (token == null) {
        throw Exception('Token not found. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/vets'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return DokterResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load dokters: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllDokters: $e');
      throw Exception('Error fetching dokters: $e');
    }
  }

  // Fetch dokter untuk home page (hanya 5 dokter pertama)
  static Future<List<Dokter>> getDoktersForHome() async {
    try {
      final dokterResponse = await getAllDokters();

      if (dokterResponse.success && dokterResponse.data.isNotEmpty) {
        return dokterResponse.data.take(5).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching dokters for home: $e');
    }
  }

  // Fetch detail dokter by ID
  static Future<Dokter?> getDokterById(int id) async {
    try {
      final token = await getToken();

      if (token == null) {
        throw Exception('Token not found. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/vets/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Dokter.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to fetch dokter by ID: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDokterById: $e');
      throw Exception('Error fetching dokter by ID: $e');
    }
  }

  // Fetch jadwal dokter by ID
  static Future<List<Jadwal>> getJadwalWithWaktuByDokterId(int id) async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/vets/$id/jadwal'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> jadwalList = jsonData['jadwal'];
      return jadwalList.map((e) => Jadwal.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat jadwal');
    }
  }

  static Future<bool> submitBooking({
    required int vetId,
    required int tanggalId,
    required int waktuId,
    required String keluhan,
    required int totalHarga,
    required String metodePembayaran,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'vet_id': vetId,
        'vet_date_id': tanggalId,
        'vet_time_id': waktuId,
        'keluhan': keluhan,
        'total_harga': totalHarga,
        'metode_pembayaran': metodePembayaran,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
