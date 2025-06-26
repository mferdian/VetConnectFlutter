class ArticleListItemModel {
  final int id;
  final String judul;
  final String gambar;

  ArticleListItemModel({
    required this.id,
    required this.judul,
    required this.gambar,
  });

  factory ArticleListItemModel.fromJson(Map<String, dynamic> json) {
    return ArticleListItemModel(
      id: json['id'],
      judul: json['judul'],
      gambar: json['gambar'],
    );
  }
}
