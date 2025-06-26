// models/dokter_model.dart
class DokterResponse {
  final bool success;
  final List<Dokter> data;

  DokterResponse({
    required this.success,
    required this.data,
  });

  factory DokterResponse.fromJson(Map<String, dynamic> json) {
    return DokterResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Dokter.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Dokter {
  final int id;
  final String nama;
  final String email;
  final String noTelp;
  final String alamat;
  final String str;
  final String sip;
  final String? alumni;
  final int harga;
  final String jenisKelamin;
  final String foto;
  final String tglLahir;
  final String deskripsi;

  Dokter({
    required this.id,
    required this.nama,
    required this.email,
    required this.noTelp,
    required this.alamat,
    required this.str,
    required this.sip,
    this.alumni,
    required this.harga,
    required this.jenisKelamin,
    required this.foto,
    required this.tglLahir,
    required this.deskripsi,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      noTelp: json['no_telp'] ?? '',
      alamat: json['alamat'] ?? '',
      str: json['STR'] ?? '',
      sip: json['SIP'] ?? '',
      alumni: json['alumni'],
      harga: json['harga'] ?? 0,
      jenisKelamin: json['jenis_kelamin'] ?? '',
      foto: json['foto'] ?? '',
      tglLahir: json['tgl_lahir'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'no_telp': noTelp,
      'alamat': alamat,
      'STR': str,
      'SIP': sip,
      'alumni': alumni,
      'harga': harga,
      'jenis_kelamin': jenisKelamin,
      'foto': foto,
      'tgl_lahir': tglLahir,
      'deskripsi': deskripsi,
    };
  }

  // Format harga menjadi Rupiah
  String get formattedHarga {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Format tanggal lahir
  String get formattedTglLahir {
    try {
      DateTime dateTime = DateTime.parse(tglLahir);
      return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    } catch (e) {
      return tglLahir;
    }
  }
}