class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String? noTelp;
  final int? umur;
  final String? alamat;
  final String? foto;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.noTelp,
    this.umur,
    this.alamat,
    this.foto,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      noTelp: json['no_telp'],
      umur: json['umur'],
      alamat: json['alamat'],
      foto: json['foto'],
    );
  }
}
