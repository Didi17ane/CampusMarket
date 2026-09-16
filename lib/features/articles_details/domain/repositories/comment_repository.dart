import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';

abstract class CommentRepository {
  Stream<List<CommentairesModels>> getCommentByArticleId(String articleId);

  Future<void> addComment(CommentairesModels comment);
}
