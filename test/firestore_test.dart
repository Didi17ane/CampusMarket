import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('Tests de connexion et d\'écriture Firestore', () {
    test(
      'L\'ajout d\'un document dans la collection tests doit réussir',
      () async {
        final fakeFirestore = FakeFirebaseFirestore();

        final donneesTest = {
          'statut': 'Succès ! Connecté à Firestore depuis Flutter',
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
          snapshot.data()?['statut'],
          equals('Succès ! Connecté à Firestore depuis Flutter'),
        );
      },
    );
  });
}
