import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../annonces/data/models/articles_models.dart';

class MesAnnoncesRepository {
  final FirebaseFirestore _firestore;

  MesAnnoncesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(kArticlesCollection);

  /// Écoute en temps réel les annonces publiées par un utilisateur donné.
  /// Le flux se met à jour automatiquement si une annonce est ajoutée/supprimée.
  Stream<List<ArticlesModels>> watchAnnoncesByUser(String userId) {
    return _collection
        .where('vendeurId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ArticlesModels.fromJson(doc.data(), id: doc.id))
            .toList());
  }

  Future<void> deleteAnnonce(String articleId) {
    return _collection.doc(articleId).delete();
  }

  Future<void> updateStatut(String articleId, String statut) {
    return _collection.doc(articleId).update({'statut': statut});
  }

  Future<void> updateAnnonce(ArticlesModels annonce) {
    return _collection.doc(annonce.id).update(annonce.toJson());
  }
}
