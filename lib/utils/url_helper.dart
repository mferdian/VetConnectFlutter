class UrlHelper {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Ganti sesuai device

  static String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$baseUrl$path';
  }
}
