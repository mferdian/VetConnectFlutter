import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/order_service.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = Get.arguments as int;
    final c = Get.put(OrderDetailController(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan'), centerTitle: true),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final o = c.order;
        if (o == null) {
          return const Center(child: Text('Detail tidak ditemukan.'));
        }

        final tgl = o.vetDate.substring(0, 10);
        final jam =
            "${o.vetTimeMulai.substring(0, 5)} - ${o.vetTimeSelesai.substring(0, 5)}";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QrImageView(data: o.orderId, size: 200),
              const SizedBox(height: 16),
              Text(
                "ID Pesanan: ${o.orderId}",
                style: const TextStyle(fontSize: 16),
              ),
              const Divider(),
              ListTile(title: const Text('Dokter'), subtitle: Text(o.vetNama)),
              ListTile(title: const Text('Tanggal'), subtitle: Text(tgl)),
              ListTile(title: const Text('Waktu'), subtitle: Text(jam)),
              ListTile(title: const Text('Keluhan'), subtitle: Text(o.keluhan)),
              ListTile(
                title: const Text('Total Harga'),
                subtitle: Text("Rp ${o.totalHarga}"),
              ),
              ListTile(title: const Text('Status'), subtitle: Text(o.status)),
              ListTile(
                title: const Text('Status Pembayaran'),
                subtitle: Text(o.statusBayar),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class OrderDetailController extends GetxController {
  final int id;
  var isLoading = true.obs;
  OrderDetail? order;

  OrderDetailController(this.id);

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  void fetchDetail() async {
    try {
      isLoading.value = true;
      order = await OrderService.getOrderDetail(id);
    } catch (e) {
      Get.snackbar("Error", "Gagal fetch detail pesanan");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}

class OrderDetail {
  final String orderId,
      vetNama,
      vetDate,
      vetTimeMulai,
      vetTimeSelesai,
      keluhan,
      status,
      statusBayar;
  final int totalHarga;

  OrderDetail({
    required this.orderId,
    required this.vetNama,
    required this.vetDate,
    required this.vetTimeMulai,
    required this.vetTimeSelesai,
    required this.keluhan,
    required this.status,
    required this.statusBayar,
    required this.totalHarga,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> j) {
    return OrderDetail(
      orderId: j['order_id'],
      vetNama: j['vet']['nama'] ?? '',
      vetDate: j['vet_date']['tanggal'] ?? '',
      vetTimeMulai: j['vet_time']['jam_mulai'] ?? '',
      vetTimeSelesai: j['vet_time']['jam_selesai'] ?? '',
      keluhan: j['keluhan'] ?? '',
      status: j['status'] ?? '',
      statusBayar: j['status_bayar'] ?? '',
      totalHarga: j['total_harga'] ?? 0,
    );
  }
}
