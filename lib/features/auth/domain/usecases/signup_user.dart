import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/users_models.dart';

Future<User?> signUpUser({
  required Users utilisateurs,
  required String password,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: utilisateurs.email,
          password: password,
        );

    User? user = userCredential.user;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Utilisateurs')
          .doc(user.uid)
          .set({
            'uid': user.uid,
            'name': utilisateurs.name,
            'lastname': utilisateurs.lastname,
            'phoneNumber': utilisateurs.phoneNumber,
            'email': utilisateurs.email,
          });
    }
    return user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        throw Exception('Email deja utilisé');
      case 'weak-password':
        throw Exception("Mot de passe faible 6 caractères minimim");
      default:
        throw Exception("Erreur intervenue lors de l'authentification ");
    }
  } catch (e) {
    Exception("Database Error: $e");
    rethrow;
  }
}
