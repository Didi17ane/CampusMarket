import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../services/firestore_service.dart';
import '../../data/models/articles_models.dart';

// Simulation d'un user temporaire
final authUserIdProvider = Provider<String?>((ref) {
  // return FirebaseAuth.instance.currentUser?.uid;
  return "vendeur_etudiant_id_999";
});

// Définition des états de publication
class PublishState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  PublishState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });
}

class PublishNotifier extends StateNotifier<PublishState> {
  final FirestoreService _firestoreService;
  final String? _currentUserId;

  PublishNotifier(this._firestoreService, this._currentUserId)
    : super(PublishState());

  Future<void> publierAnnonce({
    required String name,
    required String description,
    required int prix,
    required String categorieSaisie, // le texte selectionne ou tape
    required File imageFile,
    List<File> imagesSecondaires = const [],
  }) async {
    if (_currentUserId == null) {
      state = PublishState(
        errorMessage: "Vous devez etre connecte pour publier un article.",
      );
      return;
    }
    state = PublishState(isLoading: true);

    try {
      String urlPhoto = 'url_par_defaut.jpg';

      // GESTION DE l'IMAGE SUR FIRESTORAGE

      // 1. Téléversement de l'image principale
      urlPhoto = await _firestoreService.uploadArticleImage(
        imageFile,
        _currentUserId,
      );

      // 2. Téléversement des images secondaires en parallèle
      List<String> urlsSecondaires = [];
      for (File file in imagesSecondaires) {
        String url = await _firestoreService.uploadArticleImage(
          file,
          _currentUserId!,
        );
        urlsSecondaires.add(url);
      }

      //GESTION DE LA COLLECTION CATEGORIE(Cherche ou cree)
      String finalCategorieId = await _firestoreService.getOrCreateCategorieId(
        categorieSaisie,
      );
      // CRTEACTION DU MODEL FINAL
      final nouvelArticle = ArticlesModels(
        photo: urlPhoto,
        imagesDetails: urlsSecondaires,
        nameArticle: name,
        description: description,
        prix: prix,
        vendeurId: _currentUserId,
        categorieId: finalCategorieId,
        statut: 'active',
      );

      // ENVOI SUR FIRESTORE ('Articles')
      await _firestoreService.addArticles(nouvelArticle);

      state = PublishState(isSuccess: true);
    } catch (e) {
      state = PublishState(errorMessage: e.toString());
    }
  }
}

// Le Provider accessible depuis l'interface graphique
final publishProvider = StateNotifierProvider<PublishNotifier, PublishState>((
  ref,
) {
  // Supposons que vous ayez un provider global pour votre service Firestore
  final firestoreService = FirestoreService();
  final currentUserId = ref.watch(authUserIdProvider);

  return PublishNotifier(firestoreService, currentUserId);
});

// alimenter directement l'interface en catégories depuis Firestore
final categoriesStreamProvider = StreamProvider<List<Map<String, String>>>((
  ref,
) {
  return FirestoreService().getCategoriesStream();
});
