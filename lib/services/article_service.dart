import 'dart:convert';
import 'package:flutter_application_1/models/article_detail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_list_item.dart';

class ArticleService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<ArticleListItemModel>> fetchArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token not found');

      final response = await http.get(
        Uri.parse('$baseUrl/articles'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List articles = data['data'];
        return articles
            .map((json) => ArticleListItemModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Error fetching articles: $e');
      rethrow;
    }
  }

  static Future<ArticleDetailModel> fetchArticleDetail(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token not found');

      final response = await http.get(
        Uri.parse('$baseUrl/articles/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ArticleDetailModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load article detail');
      }
    } catch (e) {
      print('Error fetching article detail: $e');
      rethrow;
    }
  }
}
