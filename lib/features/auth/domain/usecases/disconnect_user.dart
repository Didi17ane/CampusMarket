import 'package:firebase_auth/firebase_auth.dart';

Future<void> disconnectUser() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    Exception("Erreur lors de la deconnexion");
    rethrow;
  }
}
