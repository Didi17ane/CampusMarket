import 'package:campusmarket/features/annonces/data/models/articles_models.dart';

abstract class ArticleDetailRepository {
  Future<ArticlesModels> getArticleById(String articleId);
}
