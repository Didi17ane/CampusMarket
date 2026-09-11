import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteCommentsDataSource {
  Future<void> addComment(CommentairesModels comment);
  Stream<List<CommentairesModels>> getCommentByArticleIdAndAuteurId(
    String articleId,
    String auteurId,
  );
}

class RemoteCommentsDataSourceImpl implements RemoteCommentsDataSource {
  final FirebaseFirestore firestore;
  RemoteCommentsDataSourceImpl({required this.firestore});

  @override
  Future<void> addComment(CommentairesModels comment) async {
    await firestore.collection(kCommentairesCollection).add(comment.toJson());
  }

  @override
  Stream<List<CommentairesModels>> getCommentByArticleIdAndAuteurId(
    String articleId,
    String auteurId,
  ) {
    return firestore
        .collection(kCommentairesCollection)
        .where('produitId', isEqualTo: articleId)
        .where('auteurId', isEqualTo: auteurId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentairesModels.fromJson(doc.data()))
              .toList(),
        );
  }
}
