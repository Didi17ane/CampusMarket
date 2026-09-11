import 'package:campusmarket/core/providers/firestore_provider.dart';
import 'package:campusmarket/features/annonces/data/models/commentaires_models.dart';
import 'package:campusmarket/features/articles_details/data/data_sources/remote_comment_data_source.dart';
import 'package:campusmarket/features/articles_details/data/repositories/comment_repository_impl.dart';
import 'package:campusmarket/features/articles_details/domain/repositories/comment_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteCommentsDataSourceProvider = Provider<RemoteCommentsDataSource>((
  ref,
) {
  final firestore = ref.watch(firestoreProvider);
  return RemoteCommentsDataSourceImpl(firestore: firestore);
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final remoteDataSource = ref.watch(remoteCommentsDataSourceProvider);
  return CommentRepositoryImpl(remote: remoteDataSource);
});

class CommentNotifier extends StreamNotifier<List<CommentairesModels>> {
  final ({String articleId, String auteurId}) arg;
  CommentNotifier(this.arg);

  @override
  Stream<List<CommentairesModels>> build() {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.getCommentByArticleIdAndAuteurId(
      arg.articleId,
      arg.auteurId,
    );
  }

  Future<void> addComment(CommentairesModels comment) async {
    final repository = ref.watch(commentRepositoryProvider);

    await repository.addComment(comment);
  }
}

// 2. Déclaration du Provider associé
final commentNotifierProvider =
    StreamNotifierProvider.family<
      CommentNotifier,
      List<CommentairesModels>,
      ({String articleId, String auteurId})
    >(CommentNotifier.new);
