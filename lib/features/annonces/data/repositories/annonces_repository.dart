import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/models/articles_models.dart';

class AnnoncesRepository {
  
  final CollectionReference _produitsRef =
      FirebaseFirestore.instance.collection('Articles');

  Stream<List<ArticlesModels>> getProduits() {
    return _produitsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ArticlesModels(
          id: doc.id,
          photo: data['photo'] ?? '',
          nameArticle: data['titre'] ?? '', 
          description: data['description'] ?? '',
          prix: data['prix'] ?? 0,
        );
      }).toList();
    });
  }
}