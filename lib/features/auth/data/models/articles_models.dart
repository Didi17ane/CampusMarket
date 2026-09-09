import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesModels {
  String id;
  String photo;
  String nameArticle;
  String description;
  String categories;
  String sellerId;
  DateTime createdAt;
  double prix;
  String etat;
  int quantite;

  ArticlesModels({
    this.id = '',
    required this.photo,
    required this.nameArticle,
    required this.description,
    this.etat = 'disponible',
    required this.categories,
    required this.sellerId,
    required this.createdAt,
    required this.prix,
    this.quantite = 1,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'photo': photo,
    'nameArticles': nameArticle,
    'description': description,
    'categories': categories,
    'sellerId': sellerId,
    'createdAt': createdAt,
    'prix': prix,
    'etat': etat,
    'quantite': quantite,
  };

  factory ArticlesModels.fromMap(Map<String, dynamic> map, String documentId) =>
      ArticlesModels(
        id: documentId,
        photo: map['photo'] ?? '',
        nameArticle: map['nameArticle'] ?? '',
        description: map['description'] ?? '',
        categories: map['categories'] ?? '',
        sellerId: map['sellerId'] ?? '',
        createdAt: map['createdAt'] is Timestamp
            ? (map['createdAt'] as Timestamp).toDate()
            : DateTime.parse(
                map['createdAt'] ?? DateTime.now().toIso8601String(),
              ),
        prix: (map['prix'] as num?)?.toDouble() ?? 0.0,
        etat: map['etat'] ?? '',
        quantite: map['quantite'] ?? 1,
      );
}
