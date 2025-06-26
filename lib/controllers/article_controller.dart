import 'package:flutter_application_1/models/article_detail.dart';
import 'package:get/get.dart';
import '../models/article_list_item.dart';
import '../services/article_service.dart';

class ArticleController extends GetxController {
  var articles = <ArticleListItemModel>[].obs;
  var isLoadingList = false.obs;
  var articleDetail = Rxn<ArticleDetailModel>();
  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  void fetchArticles() async {
    try {
      isLoadingList.value = true;
      final result = await ArticleService.fetchArticles();
      articles.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat artikel');
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> fetchArticleDetail(int id) async {
    try {
      articleDetail.value = await ArticleService.fetchArticleDetail(id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail artikel');
    }
  }
}
