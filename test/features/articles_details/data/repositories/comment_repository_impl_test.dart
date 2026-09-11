import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:campusmarket/features/articles_details/data/data_sources/remote_comment_data_source.dart';
import 'package:campusmarket/features/articles_details/data/repositories/comment_repository_impl.dart';
import 'package:campusmarket/features/articles_details/domain/repositories/comment_repository.dart';
import 'package:campusmarket/features/articles_details/presentation/providers/comment_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Recupération des commentaires", () {
    final firestore = FakeFirebaseFirestore();
    final remote = RemoteCommentsDataSourceImpl(firestore: firestore);
    final commentRepository = CommentRepositoryImpl(remote: remote);

    test("émission de commentaires en temps réel", () async {
      final stream = commentRepository.getCommentByArticleIdAndAuteurId(
        "articleId",
        "auteurId",
      );

      expectLater(
        stream,
        emitsInOrder([
          [],
          predicate<List<CommentairesModels>>((list) => list.length == 1),
        ]),
      );

      commentRepository.addComment(
        CommentairesModels(
          id: 'commentaire1',
          produitId: 'articleId',
          auteurId: 'auteurId',
          contenu: 'commentaire',
          datePublication: DateTime.now(),
        ),
      );
    });
    test("recupérer un commentaire spécifique", () async {
      await firestore.collection(kCommentairesCollection).doc("comment1").set({
        'contenu': 'commentaireSpeciale',
        'datePublication': DateTime.now(),
        'produitId': 'articleId',
        'auteurId': 'auteurId',
      });

      final stream = commentRepository.getCommentByArticleIdAndAuteurId(
        "articleId",
        "auteurId",
      );

      final commentaires =
          await stream.first; // récupère juste la 1ère émission

      expect(commentaires.length, 1);
      expect(commentaires.first.contenu, 'commentaireSpeciale');
      expect(commentaires.first.produitId, 'articleId');
      expect(commentaires.first.auteurId, 'auteurId');
    });
  });
}
