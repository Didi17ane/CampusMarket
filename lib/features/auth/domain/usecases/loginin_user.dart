import 'package:firebase_auth/firebase_auth.dart';

Future<User?> LogIn(String email, String password) async {
  try {
    final loginCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = loginCredential.user;
    return user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found' || 'invalid-credential':
        throw Exception("Utilisateur ou mot de passe incorrect");
      default:
        print("Database error $e");
        throw Exception("Database error");
    }
  }
}
