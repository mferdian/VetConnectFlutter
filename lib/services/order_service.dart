import 'dart:convert';
import 'package:flutter_application_1/pages/order_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const baseUrl = 'https://vetconnectmob-production.up.railway.app/api';

  // Ganti ke SharedPreferences
  static Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<dynamic>> getMyOrders() async {
    final t = await _token();
    if (t == null) throw Exception("Token tidak ditemukan (SharedPreferences)");

    final r = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Authorization': 'Bearer $t', 'Accept': 'application/json'},
    );

    if (r.statusCode >= 200 && r.statusCode < 300) {
      final j = json.decode(r.body);
      return j['data'];
    }

    print("❌ Error ${r.statusCode}: ${r.body}");
    throw Exception('Gagal fetch orders');
  }

  static Future<OrderDetail> getOrderDetail(int id) async {
    final t = await _token();
    if (t == null) throw Exception("Token tidak ditemukan (SharedPreferences)");

    final r = await http.get(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: {'Authorization': 'Bearer $t', 'Accept': 'application/json'},
    );

    if (r.statusCode >= 200 && r.statusCode < 300) {
      final j = json.decode(r.body);
      return OrderDetail.fromJson(j['data']);
    }

    print("❌ Detail Error ${r.statusCode}: ${r.body}");
    throw Exception('Gagal fetch detail');
  }
}
