import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/models/categories_models.dart';

class CategoriesRepository {
  final CollectionReference _categoriesRef =
      FirebaseFirestore.instance.collection('Categories');

  Stream<List<CategoriesModels>> getCategories() {
    return _categoriesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final nom = (data['nom'] ?? data['nameCategorie'] ?? '').toString().trim();
        return CategoriesModels(
          id: doc.id,
          nameCategorie: nom.isEmpty ? 'Autres' : nom,
        );
      }).toList();
    });
  }
}