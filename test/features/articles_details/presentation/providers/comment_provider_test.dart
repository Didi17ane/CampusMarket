// import 'package:campusmarket/core/constants/firestore_collections.dart';
// import 'package:campusmarket/core/providers/firestore_provider.dart';
// import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
// import 'package:campusmarket/features/articles_details/presentation/providers/comment_provider.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   group("test de commentProvider", () {
//     late FakeFirebaseFirestore fakeFirestore;
//     late ProviderContainer container;
//     final arg = (articleId: 'article1', auteurId: 'user1');

//     setUp(() {
//       fakeFirestore = FakeFirebaseFirestore();
//       container = ProviderContainer(
//         overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
//       );
//     });

//     tearDown(() => container.dispose());

//     test("test de getComment", () async {
//       await fakeFirestore.collection(kCommentairesCollection).add({
//         'produitId': 'article1',
//         'auteurId': 'user1',
//         'contenu': 'Top',
//         'datePublication': DateTime.now(),
//       });

//       final comments = await container.read(
//         commentNotifierProvider(arg).future,
//       );
//       expect(comments.length, 1);
//     });

//     test("test de addComment", () async {
//       await container.read(
//         commentNotifierProvider(arg).future,
//       ); // init (liste vide)

//       await container
//           .read(commentNotifierProvider(arg).notifier)
//           .addComment(
//             CommentairesModels(
//               contenu: 'Nouveau commentaire',
//               datePublication: DateTime.now(),
//               produitId: 'article1',
//               auteurId: 'user1',
//             ),
//           );

//       await Future.delayed(Duration.zero);

//       final state = container.read(commentNotifierProvider(arg));
//       expect(state.value?.length, 1);
//     });
//   });
// }

import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/core/providers/firestore_provider.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/comment_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("test de commentProvider", () {
    late FakeFirebaseFirestore fakeFirestore;
    late ProviderContainer container;
    final arg = 'article1';
    //réinitialiser avant chaque test
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      container = ProviderContainer(
        overrides: [firestoreProvider.overrideWithValue(fakeFirestore)],
      );
    });

    tearDown(() => container.dispose());

    test(
      "test de getComment (récupération de commentaires existants)",
      () async {
        final subscription = container.listen(
          commentNotifierProvider(arg),
          (previous, next) {},
        );

        // 1. Arrange : Insérer avec la vraie constante kCommentairesCollection
        await fakeFirestore.collection(kCommentairesCollection).add({
          'id': 'comm1',
          'produitId': 'article1',
          'auteurId': 'user1',
          'contenu': 'Top cet article !',
          'datePublication': DateTime.now(),
        });

        // 2. Act : Lire le premier résultat émis par le Stream via .future
        final comments = await container.read(
          commentNotifierProvider(arg).future,
        );

        // 3. Assert
        expect(comments.length, 1);
        expect(comments.first.contenu, 'Top cet article !');
        expect(comments.first.produitId, 'article1');

        subscription.close();
      },
    );

    test("test de addComment (ajout et mise à jour temps réel)", () async {
      // 1. Activer l'écoute du provider pour qu'il reçoive les événements du Stream
      final subscription = container.listen(
        commentNotifierProvider(arg),
        (previous, next) {},
      );

      // Attendre que le stream s'initialise (liste vide au départ)
      final initialComments = await container.read(
        commentNotifierProvider(arg).future,
      );
      expect(initialComments, isEmpty);

      // 2. Ajouter un nouveau commentaire via le notifier
      await container
          .read(commentNotifierProvider(arg).notifier)
          .addComment(
            CommentairesModels(
              id: 'comm2',
              contenu: 'Nouveau commentaire',
              datePublication: DateTime.now(),
              produitId: 'article1',
              auteurId: 'user1',
            ),
          );

      // Laisser un court instant pour que Firestore propage l'événement au Stream
      await Future.delayed(Duration.zero);

      // 3. Vérifier que l'état du provider s'est mis à jour
      final state = container.read(commentNotifierProvider(arg));
      expect(state.value?.length, 1);
      expect(state.value?.first.contenu, 'Nouveau commentaire');

      subscription.close();
    });
  });
}
