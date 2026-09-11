import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:campusmarket/features/articles_details/data/data_sources/remote_comment_data_source.dart';
import 'package:campusmarket/features/articles_details/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final RemoteCommentsDataSource remote;
  CommentRepositoryImpl({required this.remote});

  @override
  Future<void> addComment(CommentairesModels comment) async {
    await remote.addComment(comment);
  }

  @override
  Stream<List<CommentairesModels>> getCommentByArticleIdAndAuteurId(
    String articleId,
    String auteurId,
  ) {
    return remote.getCommentByArticleIdAndAuteurId(articleId, auteurId);
  }
}
