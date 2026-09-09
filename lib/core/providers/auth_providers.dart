// Providers minimaux pour connaître l'utilisateur connecté.
// À compléter par N'Guessan dans le cadre de T-01 (écrans inscription/
// connexion) : ce fichier fournit juste la base dont les autres écrans
// (Profil, Mes annonces...) ont besoin dès maintenant.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Écoute l'état de connexion Firebase Auth en temps réel (null si déconnecté).
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Raccourci pratique : l'id de l'utilisateur actuellement connecté,
/// ou null si personne n'est connecté.
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.uid;
});
