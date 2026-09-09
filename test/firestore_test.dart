import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../lib/services/firestore_service.dart';
import '../lib/features/auth/data/models/articles_models.dart';

void main() {
  group('Tests de connexion et d\'écriture Firestore', () {
    test(
      'L\'ajout d\'un document dans la collection tests doit réussir',
      () async {
        final fakeFirestore = FakeFirebaseFirestore();

        final donneesTest = {
          'status': 'Succès ! Connecté à Firestore depuis Flutter',
          'date': DateTime.now().toIso8601String(),
          'categories': 'Test',
          'sellerId': 'seller1',
          'createdAt': DateTime.now().toIso8601String(),
        };

        final docRef = await fakeFirestore.collection('tests').add(donneesTest);

        expect(docRef.id, isNotEmpty);

        final snapshot = await fakeFirestore
            .collection('tests')
            .doc(docRef.id)
            .get();

        expect(snapshot.exists, true);
        expect(
          snapshot.data()?['status'],
          equals('Succès ! Connecté à Firestore depuis Flutter'),
        );
      },
    );
  });

  test(
    'L\'ajout d\'un nouveau produit doit enregistrer les bonnes données',
    () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final firestoreService = FirestoreService(firestore: fakeFirestore);

      final nouveauProduit = ArticlesModels(
        photo: 'url_de_la_photo.jpg',
        nameArticle: 'Ordinateur portable HP',
        description: 'Parfait état, idéal pour étudiant en informatique',
        categories: 'Informatique',
        sellerId: 'user_student_123',
        createdAt: DateTime.now(),
        prix: 250000.0,
      );

      final productId = await firestoreService.addArticles(nouveauProduit);

      expect(productId, isNotEmpty);

      final snapshot = await fakeFirestore
          .collection('Articles')
          .doc(productId)
          .get();

      expect(snapshot.exists, true);

      expect(
        snapshot.data()?['nameArticles'],
        equals('Ordinateur portable HP'),
      );
      expect(snapshot.data()?['prix'], equals(250000.0));
      expect(snapshot.data()?['sellerId'], equals('user_student_123'));
    },
  );

  test(
    'La récupération des articles en temps réel doit renvoyer la liste convertie',
    () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final firestoreService = FirestoreService(firestore: fakeFirestore);

      await fakeFirestore.collection('Articles').add({
        'photo': 'ordinateur.jpg',
        'nameArticle': 'MacBook Pro',
        'description': 'Super état',
        'categories': 'Informatique',
        'sellerId': 'seller_999',
        'createdAt': Timestamp.now(),
        'prix': 500000.0,
      });

      final articlesStream = firestoreService.getArticlesStream();

      final listeArticles = await articlesStream.first;

      expect(listeArticles.length, equals(1));
      expect(listeArticles.first.nameArticle, equals('MacBook Pro'));
      expect(listeArticles.first.prix, equals(500000.0));
    },
  );
}
