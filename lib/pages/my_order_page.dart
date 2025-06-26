import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/order_service.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyOrderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.orders.isEmpty) {
          return const Center(child: Text('Belum ada pesanan.'));
        }
        return ListView.builder(
          itemCount: c.orders.length,
          itemBuilder: (ctx, i) {
            final o = c.orders[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(o.vetNama),
                subtitle: Text(
                  "Tanggal: ${o.vetDate.substring(0,10)}\nStatus: ${o.status}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Get.toNamed('/order-detail', arguments: o.id),
              ),
            );
          },
        );
      }),
    );
  }
}

class MyOrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <OrderSummary>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      isLoading.value = true;
      final data = await OrderService.getMyOrders();
      orders.value = data.map((j) => OrderSummary.fromJson(j)).toList();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat pesanan");
    } finally {
      isLoading.value = false;
    }
  }
}

/// Model ringkas untuk list
class OrderSummary {
  final int id;
  final String orderId, vetNama, vetDate, status;

  OrderSummary({
    required this.id,
    required this.orderId,
    required this.vetNama,
    required this.vetDate,
    required this.status,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> j) {
    return OrderSummary(
      id: j['id'],
      orderId: j['order_id'],
      vetNama: j['vet']['nama'] ?? '',
      vetDate: j['vet_date']['tanggal'] ?? '',
      status: j['status'] ?? '',
    );
  }
}
