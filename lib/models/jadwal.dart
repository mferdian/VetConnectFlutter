// models/jadwal.dart
class Jadwal {
  final int tanggalId;
  final String tanggal;
  final List<Waktu> waktu;

  Jadwal({
    required this.tanggalId,
    required this.tanggal,
    required this.waktu,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      tanggalId: json['tanggal_id'],
      tanggal: json['tanggal'],
      waktu: (json['waktu'] as List)
          .map((item) => Waktu.fromJson(item))
          .toList(),
    );
  }
}

class Waktu {
  final int waktuId;
  final String jam;

  Waktu({
    required this.waktuId,
    required this.jam,
  });

  factory Waktu.fromJson(Map<String, dynamic> json) {
    return Waktu(
      waktuId: json['waktu_id'],
      jam: json['jam'],
    );
  }
}
