import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/features/annonces/data/models/articles_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteArticleDetailDataSource {
  Future<ArticlesModels> getArticleById(String articleId);
  Stream<ArticlesModels> watchArticleById(String articleId);
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
    return ArticlesModels.fromJson(
      doc.data() as Map<String, dynamic>,
      id: doc.id,
    );
  }

  @override
  Stream<ArticlesModels> watchArticleById(String articleId) {
    return firestore
        .collection(kArticlesCollection)
        .doc(articleId)
        .snapshots()
        .map((doc) {
          if (!doc.exists || doc.data() == null) {
            throw Exception('Article introuvable');
          }
          return ArticlesModels.fromJson(
            doc.data() as Map<String, dynamic>,
            id: doc.id,
          );
        });
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
