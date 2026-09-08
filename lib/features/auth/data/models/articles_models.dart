class ArticlesModels {
  String id;
  String photo;
  String nameArticle;
  String description;
  int prix;

  ArticlesModels({
    this.id = '',
    required this.photo,
    required this.nameArticle,
    required this.description,
    required this.prix,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'photo': photo,
    'nameArticles': nameArticle,
    'description': description,
    'prix': prix,
  };

  ArticlesModels fromJson(Map<String, dynamic> json) => ArticlesModels(
    photo: json['photo'],
    nameArticle: json['nameArticle'],
    description: json['description'],
    prix: json['prix'],
  );
}
