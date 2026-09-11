import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/features/annonces/data/models/articles_models.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteArticleDetailDataSource {
  Future<ArticlesModels> getArticleById(String articleId);
}

class RemoteArticleDetailDataSourceImpl
    implements RemoteArticleDetailDataSource {
  final FirebaseFirestore firestore;
  RemoteArticleDetailDataSourceImpl({required this.firestore});

  @override
  Future<ArticlesModels> getArticleById(String articleId) async {
    final doc = await firestore
        .collection(kArticlesCollection)
        .doc(articleId)
        .get();

    if (!doc.exists) {
      throw Exception('Article introuvable');
    }
    return ArticlesModels.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> addComment(
    String articleId,
    String auteurId,
    String texte,
  ) async {
    await firestore.collection('comments').add({
      'articleId': articleId,
      'auteurId': auteurId,
      'texte': texte,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
