import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../data/repositories/mes_annonces_repository.dart';
import '../../../annonces/data/models/articles_models.dart';

final mesAnnoncesRepositoryProvider = Provider<MesAnnoncesRepository>((ref) {
  return MesAnnoncesRepository();
});

/// Liste des annonces de l'utilisateur connecté, mise à jour en temps réel
/// (une suppression ou un ajout se reflète automatiquement à l'écran).
final mesAnnoncesProvider = StreamProvider<List<ArticlesModels>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(mesAnnoncesRepositoryProvider).watchAnnoncesByUser(userId);
});
