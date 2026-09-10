import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../features/annonces/data/models/articles_models.dart';

class FirestoreService {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  FirestoreService({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _db = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  // -------------------- GESTION DE L'IMAGE --------------------
  // TELEVERSEMENT SUR FIRESTORE
  Future<String> uploadArticleImage(File imageFile, String vendeurId) async {
    try {
      String fileName =
          '${vendeurId}_${DateTime.now().millisecondsSinceEpoch}.jpg'; // No; unique pour l'image base sur timestamp
      Reference ref = _storage
          .ref()
          .child('articles_photo')
          .child(fileName); // reference dans le dossier 'articles_photos'

      // TELEVERSEMENT DE L'IMAGE
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // RECUPERATION DE L'URL PUBLIQUE
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Eche de l'envoi de la photo: $e");
    }
  }

  ///-------------------- GESTION DES CATEGORIES --------------------

  // RECHERCHER OU CREER UNE CATEGORIE DYNAMIQUE
  Future<String> getOrCreateCategorieId(String nomCategorie) async {
    try {
      final nomNettoye = nomCategorie.trim(); // recuperer la caregorie entrente

      // verifions si elle existe deja en base
      final querySnapshot = await _db
          .collection('Categories')
          .where('nom', isEqualTo: nomNettoye)
          .limit(1)
          .get();

      //Si oui on retourn son id
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        // Sinon on l'a cree
        final docRef = await _db.collection('Categories').add({
          'nom': nomNettoye,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return docRef.id;
      }
    } catch (e) {
      throw Exception("Erreur lors de la gestion de la categorie: $e");
    }
  }

  //RECUPERER LES CATEGORIES
  Stream<List<Map<String, String>>> getCategoriesStream() {
    return _db.collection('Categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, 'nom': (doc.data()['nom'] ?? '').toString()};
      }).toList();
    });
  }

  /// --------------------  GESTION DES ARTICLES --------------------
  // AJOUT D'UN ARTICLE
  Future<String> addArticles(ArticlesModels articles) async {
    try {
      final docRef = await _db.collection('Articles').add(articles.toJson());
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
              return ArticlesModels.fromJson(doc.data(), id: doc.id);
            }).toList();
          });
    } catch (e) {
      throw Exception('ERROR network $e');
    }
  }
}
