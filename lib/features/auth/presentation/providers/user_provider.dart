import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../data/repositories/users_repository.dart';
import '../../data/models/users_models.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository();
});

/// Écoute en temps réel les infos du profil de l'utilisateur connecté.
/// null tant qu'on charge, ou si personne n'est connecté / le doc n'existe pas.
final currentUserProvider = StreamProvider<Users?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(null);
  return ref.watch(usersRepositoryProvider).watchUser(userId);
});
