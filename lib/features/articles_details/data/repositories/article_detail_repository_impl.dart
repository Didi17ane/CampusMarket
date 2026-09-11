import 'package:campusmarket/features/annonces/data/models/articles_models.dart';
import 'package:campusmarket/features/articles_details/data/data_sources/remote_article_detail_data_source.dart';
import 'package:campusmarket/features/articles_details/domain/repositories/article_detail_repository.dart';
import 'package:firebase_core/firebase_core.dart';

class ArticleDetailRepositoryImpl implements ArticleDetailRepository {
  final RemoteArticleDetailDataSource remoteArticleDetailDataSource;

  ArticleDetailRepositoryImpl({required this.remoteArticleDetailDataSource});

  @override
  Future<ArticlesModels> getArticleById(String articleId) async {
    try {
      return await remoteArticleDetailDataSource.getArticleById(articleId);
    } on FirebaseException catch (e) {
      throw Exception(e.message.toString());
    }
  }
}
