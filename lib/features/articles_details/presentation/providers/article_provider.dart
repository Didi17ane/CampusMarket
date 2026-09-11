import 'package:campusmarket/core/providers/firestore_provider.dart';
import 'package:campusmarket/features/annonces/data/models/articles_models.dart';
import 'package:campusmarket/features/articles_details/data/data_sources/remote_article_detail_data_source.dart';
import 'package:campusmarket/features/articles_details/data/repositories/article_detail_repository_impl.dart';
import 'package:campusmarket/features/articles_details/domain/repositories/article_detail_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider du Data Source
final remoteArticleDetailDataSourceProvider =
    Provider<RemoteArticleDetailDataSource>((ref) {
      final firestore = ref.watch(firestoreProvider);
      return RemoteArticleDetailDataSourceImpl(firestore: firestore);
    });

//Provider du Repository
final articleDetailRepositoryProvider = Provider<ArticleDetailRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(remoteArticleDetailDataSourceProvider);
  return ArticleDetailRepositoryImpl(
    remoteArticleDetailDataSource: remoteDataSource,
  );
});

//Providers consommés par les écrans

final articleDetailProvider = FutureProvider.family<ArticlesModels, String>((
  ref,
  articleId,
) async {
  final repository = ref.watch(articleDetailRepositoryProvider);
  return repository.getArticleById(articleId);
});
