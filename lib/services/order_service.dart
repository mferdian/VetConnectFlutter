import 'dart:convert';
import 'package:flutter_application_1/pages/order_detail_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const baseUrl = 'http://10.0.2.2:8000/api';
  static Future<String?> _token() async => GetStorage().read('token');

  static Future<List<dynamic>> getMyOrders() async {
    final t = await _token();
    final r = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Authorization': 'Bearer $t', 'Accept': 'application/json'},
    );
    if (r.statusCode >=200 && r.statusCode <300) {
      final j = json.decode(r.body);
      return j['data'];
    }
    throw Exception('Gagal fetch orders');
  }

  static Future<OrderDetail> getOrderDetail(int id) async {
    final t = await _token();
    final r = await http.get(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: {'Authorization': 'Bearer $t', 'Accept': 'application/json'},
    );
    if (r.statusCode >=200 && r.statusCode <300) {
      final j = json.decode(r.body);
      return OrderDetail.fromJson(j['data']);
    }
    throw Exception('Gagal fetch detail');
  }
}
