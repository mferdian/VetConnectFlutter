class BookingRequest {
  final int vetId;
  final int vetDateId;
  final int vetTimeId;
  final String keluhan;
  final int totalHarga;
  final String metodePembayaran;

  BookingRequest({
    required this.vetId,
    required this.vetDateId,
    required this.vetTimeId,
    required this.keluhan,
    required this.totalHarga,
    required this.metodePembayaran,
  });

  Map<String, dynamic> toJson() {
    return {
      'vet_id': vetId,
      'vet_date_id': vetDateId,
      'vet_time_id': vetTimeId,
      'keluhan': keluhan,
      'total_harga': totalHarga,
      'metode_pembayaran': metodePembayaran,
    };
  }
}
