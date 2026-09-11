import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';

abstract class CommentRepository {
  Stream<List<CommentairesModels>> getCommentByArticleIdAndAuteurId(
    String articleId,
    String auteurId,
  );

  Future<void> addComment(CommentairesModels comment);
}
