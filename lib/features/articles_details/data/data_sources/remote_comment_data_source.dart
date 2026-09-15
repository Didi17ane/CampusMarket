import 'package:campusmarket/core/constants/firestore_collections.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteCommentsDataSource {
  Future<void> addComment(CommentairesModels comment);
  Stream<List<CommentairesModels>> getCommentByArticleId(String articleId);
}

class RemoteCommentsDataSourceImpl implements RemoteCommentsDataSource {
  final FirebaseFirestore firestore;
  RemoteCommentsDataSourceImpl({required this.firestore});

  @override
  Future<void> addComment(CommentairesModels comment) async {
    final docRef = firestore
        .collection(kCommentairesCollection)
        .doc(); //génère un  document avec ID seulement côté client
    comment.id = docRef.id;
    await docRef.set(comment.toJson());
  }

  @override
  Stream<List<CommentairesModels>> getCommentByArticleId(String articleId) {
    return firestore
        .collection(kCommentairesCollection)
        .where('produitId', isEqualTo: articleId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentairesModels.fromJson(doc.data()))
              .toList(),
        );
  }
}
