import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../models/users_models.dart';

class UsersRepository {
  final FirebaseFirestore _firestore;

  UsersRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(kUtilisateursCollection);

  /// Récupère un utilisateur une seule fois.
  Future<Users?> getUser(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (!doc.exists) return null;
    return Users.fromJson(doc.data()!, id: doc.id);
  }

  /// Écoute un utilisateur en temps réel (utile si son profil peut changer
  /// pendant qu'on est sur l'écran).
  Stream<Users?> watchUser(String userId) {
    return _collection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Users.fromJson(doc.data()!, id: doc.id);
    });
  }

  Future<void> updateUser(Users user) {
    return _collection.doc(user.id).set(user.toJson());
  }
}
