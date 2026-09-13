import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';


//Exposition de la connexion utilisateur a toute l'app, retourne l'instance
//User? de firebaseAuth si connecté, null dans le cas contraire
final userLoginProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
