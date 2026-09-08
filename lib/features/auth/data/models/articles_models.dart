class ArticlesModels {
  String id;
  String photo;
  String nameArticle;
  String description;
  String categories;
  String sellerId;
  DateTime createdAt;
  int prix;

  ArticlesModels({
    this.id = '',
    required this.photo,
    required this.nameArticle,
    required this.description,

    required this.categories,
    required this.sellerId,
    required this.createdAt,
    required this.prix,
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
  };

  factory ArticlesModels.fromMap(Map<String, dynamic> map, String documentId) =>
      ArticlesModels(
        id: documentId,
        photo: map['photo'],
        nameArticle: map['nameArticle'],
        description: map['description'],
        categories: map['categories'],
        sellerId: map['sellerId'],
        createdAt: map['createdAt'],
        prix: map['prix'],
      );
}
