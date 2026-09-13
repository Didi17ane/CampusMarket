import 'package:firebase_auth/firebase_auth.dart';

Future<User?> SignIn(String email, String password) async {
  try {
    final loginCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = loginCredential.user;
    return user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        Exception("L'utilisateur n'existe pas");
        rethrow;
      case 'wrong-password':
        Exception("Mot de passe Incorrect");
      default:
    }
  }
}
