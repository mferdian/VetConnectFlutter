class BookingResponse {
  final bool success;
  final String message;
  final BookingData? data;

  BookingResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
    );
  }
}

class BookingData {
  final String orderId;
  final int userId;
  final int vetId;
  final int vetDateId;
  final int vetTimeId;
  final String keluhan;
  final int totalHarga;
  final String status;
  final String statusBayar;
  final String metodePembayaran;
  final String updatedAt;
  final String createdAt;
  final int id;

  BookingData({
    required this.orderId,
    required this.userId,
    required this.vetId,
    required this.vetDateId,
    required this.vetTimeId,
    required this.keluhan,
    required this.totalHarga,
    required this.status,
    required this.statusBayar,
    required this.metodePembayaran,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      orderId: json['order_id'] ?? '',
      userId: json['user_id'] ?? 0,
      vetId: json['vet_id'] ?? 0,
      vetDateId: json['vet_date_id'] ?? 0,
      vetTimeId: json['vet_time_id'] ?? 0,
      keluhan: json['keluhan'] ?? '',
      totalHarga: json['total_harga'] ?? 0,
      status: json['status'] ?? '',
      statusBayar: json['status_bayar'] ?? '',
      metodePembayaran: json['metode_pembayaran'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}