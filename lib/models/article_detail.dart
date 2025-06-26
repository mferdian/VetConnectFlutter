class ArticleDetailModel {
  final int id;
  final String judul;
  final String isi;
  final List<String> gambar;
  final DateTime createdAt;

  ArticleDetailModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.gambar,
    required this.createdAt,
  });

  factory ArticleDetailModel.fromJson(Map<String, dynamic> json) {
    return ArticleDetailModel(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      gambar: [json['gambar']], // jika hanya 1 gambar
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
