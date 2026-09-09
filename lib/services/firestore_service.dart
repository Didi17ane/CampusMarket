import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/auth/data/models/articles_models.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  // AJOUT D'UN ARTICLE
  Future<String> addArticles(ArticlesModels articles) async {
    try {
      final docRef = await _db.collection('Articles').add(articles.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception("Erreur lors de l'ajout du produit:$e");
    }
  }

  // LECTURE DES ARTICLES DEPUIS FIRESTORE

  Stream<List<ArticlesModels>> getArticlesStream() {
    try {
      return _db
          .collection('Articles')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return ArticlesModels.fromMap(doc.data(), doc.id);
            }).toList(); 
          });
    } catch (e) {
      throw Exception('ERROR network $e');
    }
  }
}
