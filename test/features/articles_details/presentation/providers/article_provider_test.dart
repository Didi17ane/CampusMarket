import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/core/providers/firestore_provider.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/article_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("test de articleProvider", () {
    late FakeFirebaseFirestore fakeFirestore;
    late ProviderContainer container;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      container = ProviderContainer(
        overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
      );
    });

    tearDown(() => container.dispose());

    test("récupère les détails de l'article avec succès", () async {
      await fakeFirestore.collection(kArticlesCollection).doc("article1").set({
        'id': "article1",
        'photo': 'https://picsum.photos/seed/livre1/400/300',
        'nameArticle': 'Manuel Algorithmique S3',
        'description': 'Livre en très bon état',
        'prix': 1500,
        'vendeurId': 'test-user-001',
        'categorieId': '',
        'statut': 'active',
      });

      final articleDetail = await container.read(
        articleDetailProvider("article1").future,
      );

      expect(articleDetail.nameArticle, "Manuel Algorithmique S3");
      expect(articleDetail.vendeurId, "test-user-001");
      expect(articleDetail.description, "Livre en très bon état");
      expect(articleDetail.prix, 1500);
      expect(articleDetail.photo, "https://picsum.photos/seed/livre1/400/300");
      expect(articleDetail.categorieId, "");
      expect(articleDetail.statut, "active");
    });
  });
}
