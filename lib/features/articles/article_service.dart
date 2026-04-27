import 'dart:convert';
import 'package:flutter/services.dart';
import 'article_model.dart';

class ArticleService {
  Future<List<Article>> loadArticles() async {
    final jsonString = await rootBundle.loadString('assets/articles.json');
    final List data = jsonDecode(jsonString);

    return data.map((e) => Article.fromJson(e)).toList();
  }
}
