import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../features/annonces/data/models/articles_models.dart';

class FirestoreService {
  final FirebaseFirestore _db;
  final Cloudinary _cloudinary;

  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance,
      // Initialisation de Cloudinary
      _cloudinary = Cloudinary.signedConfig(
        apiKey: dotenv.env['CLOUDINARY_API_KEY'] ?? '',
        apiSecret: dotenv.env['CLOUDINARY_API_SECRET'] ?? '',
        cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '',
      );

  // -------------------- GESTION DE L'IMAGE --------------------
  // TELEVERSEMENT SUR FIRESTORE
  Future<String> uploadArticleImage(File imageFile, String vendeurId) async {
    try {
      // Préparation de la requête de téléversement
      final response = await _cloudinary.upload(
        file: imageFile.path,
        fileBytes: imageFile.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder:
            "articles_photos", // Crée automatiquement un dossier dans Cloudinary
        fileName: '${vendeurId}_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Si le téléversement réussit, on récupère l'URL sécurisée (https)
      if (response.isSuccessful && response.secureUrl != null) {
        return response.secureUrl!;
      } else {
        throw Exception(response.error ?? "Erreur inconnue Cloudinary");
      }
    } catch (e) {
      throw Exception("Échec de l'envoi de la photo sur Cloudinary : $e");
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
