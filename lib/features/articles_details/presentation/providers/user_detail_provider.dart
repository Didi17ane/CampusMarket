import 'package:campusmarket/features/auth/data/models/users_models.dart';
import 'package:campusmarket/features/auth/presentation/providers/user_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider pour récuperer les informations du vendeur
final userDetailProvider = FutureProvider.family<Users?, String>((
  ref,
  vendeurId,
) async {
  final repository = ref.watch(usersRepositoryProvider);
  return repository.getUser(vendeurId);
});
