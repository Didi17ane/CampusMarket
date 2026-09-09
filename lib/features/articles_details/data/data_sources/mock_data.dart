import '../../../annonces/data/models/articles_models.dart';
import '../../../annonces/data/models/commentaires_models.dart';
import '../../../auth/data/models/users_models.dart';

/// Listes de données de test (Mock Data) pour les Articles, Commentaires et Utilisateurs

final List<Users> mockUsers = [
  Users(
    id: 'user_vendeur_1',
    name: 'Alexandre',
    lastname: 'Dubois',
    email: 'alex.dubois@campus.edu',
    phoneNumber: '+261 34 12 345 67',
    photo: 'https://i.pravatar.cc/150?img=11',
  ),
  Users(
    id: 'user_vendeur_2',
    name: 'Sarah',
    lastname: 'Ravelo',
    email: 'sarah.ravelo@campus.edu',
    phoneNumber: '+261 32 98 765 43',
    photo: 'https://i.pravatar.cc/150?img=5',
  ),
  Users(
    id: 'user_rina',
    name: 'Rina',
    lastname: 'Andria',
    email: 'rina.andria@campus.edu',
    phoneNumber: '+261 33 11 222 33',
    photo: 'https://i.pravatar.cc/150?img=1',
  ),
  Users(
    id: 'user_toky',
    name: 'Toky',
    lastname: 'Randria',
    email: 'toky.randria@campus.edu',
    phoneNumber: '+261 34 55 666 77',
    photo: 'https://i.pravatar.cc/150?img=2',
  ),
  Users(
    id: 'user_misa',
    name: 'Misa',
    lastname: 'Rakoto',
    email: 'misa.rakoto@campus.edu',
    phoneNumber: '+261 32 44 555 66',
    photo: 'https://i.pravatar.cc/150?img=3',
  ),
];

final List<ArticlesModels> mockArticles = [
  ArticlesModels(
    id: 'art_1',
    nameArticle: 'Veste noire vintage',
    description:
        'Veste noire tendance en très bon état. Idéale pour les étudiants, style vintage et confortable.',
    prix: 20000,
    photo:
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop',
    vendeurId: 'user_vendeur_1',
    categorieId: 'cat_vetements',
    statut: 'active',
  ),
  ArticlesModels(
    id: 'art_2',
    nameArticle: 'Sweat à capuche bordeaux',
    description:
        'Sweat très confortable taille L. Porté quelques fois, quasi neuf.',
    prix: 15000,
    photo:
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop',
    vendeurId: 'user_vendeur_2',
    categorieId: 'cat_vetements',
    statut: 'active',
  ),
  ArticlesModels(
    id: 'art_3',
    nameArticle: 'Jean Slim Denim Blue',
    description: 'Jean classique coupe slim, taille 40. Marque originale.',
    prix: 25000,
    photo:
        'https://images.unsplash.com/photo-1542272604-780c96856592?w=800&auto=format&fit=crop',
    vendeurId: 'user_vendeur_1',
    categorieId: 'cat_vetements',
    statut: 'active',
  ),
];

final List<CommentairesModels> mockCommentaires = [
  CommentairesModels(
    id: 'com_1',
    contenu: 'Est-ce que la veste est encore disponible ?',
    datePublication: DateTime.now().subtract(const Duration(hours: 3)),
    produitId: 'art_1',
    auteurId: 'user_rina',
  ),
  CommentairesModels(
    id: 'com_2',
    contenu: 'Le prix est négociable ?',
    datePublication: DateTime.now().subtract(const Duration(hours: 1)),
    produitId: 'art_1',
    auteurId: 'user_toky',
  ),
  CommentairesModels(
    id: 'com_3',
    contenu: 'Possibilité de remise en main propre sur le campus ?',
    datePublication: DateTime.now().subtract(const Duration(minutes: 30)),
    produitId: 'art_1',
    auteurId: 'user_misa',
  ),
];
