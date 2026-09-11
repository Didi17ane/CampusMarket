import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/features/articles_details/data/data_sources/remote_article_detail_data_source.dart';
import 'package:campusmarket/features/articles_details/data/repositories/article_detail_repository_impl.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(" Recupération des Articles et commentaire", () {
    final firestore = FakeFirebaseFirestore();
    final remote = RemoteArticleDetailDataSourceImpl(firestore: firestore);
    final articleDetailRepositoryImpl = ArticleDetailRepositoryImpl(
      remoteArticleDetailDataSource: remote,
    );
    test("test pour la récupération d'article par rapport à son Id", () async {
      const articleId = "Hc2ERMJetxGw8nh5yVcL";
      await firestore.collection(kArticlesCollection).doc(articleId).set({
        'id': articleId,
        'photo': 'https://picsum.photos/seed/livre1/400/300',
        'nameArticle': 'Manuel Algorithmique S3',
        'description': 'Livre en très bon état',
        'prix': 1500,
        'vendeurId': 'test-user-001',
        'categorieId': '',
        'statut': 'active',
      });
      final articleDetail = await articleDetailRepositoryImpl.getArticleById(
        articleId,
      );

      expect(articleDetail.nameArticle, "Manuel Algorithmique S3");
      expect(articleDetail.vendeurId, 'test-user-001');
      expect(articleDetail.description, "Livre en très bon état");
      expect(articleDetail.prix, 1500);
      expect(articleDetail.photo, 'https://picsum.photos/seed/livre1/400/300');
    });
  });
}
