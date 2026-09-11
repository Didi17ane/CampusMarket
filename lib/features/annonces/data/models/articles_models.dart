class ArticlesModels {
  String id;
  String photo;
  String nameArticle;
  String description;
  int prix;
  String
  vendeurId; // Lien vers Users.id : indispensable pour "Mes annonces" (T-09) et le contact vendeur (T-06)
  String
  categorieId; // Lien vers CategoriesModels.id : utilisé par les filtres (T-03) et la recherche (T-10)
  String
  statut; // 'active' ou 'vendue' : utilisé par l'écran "Mes annonces" (T-09)

  ArticlesModels({
    this.id = '',
    required this.photo,
    required this.nameArticle,
    required this.description,
    required this.prix,
    required this.vendeurId,
    required this.categorieId,
    this.statut = 'active',
  });

  Map<String, dynamic> toJson() => {
    'photo': photo,
    'nameArticle': nameArticle,
    'description': description,
    'prix': prix,
    'vendeurId': vendeurId,
    'categorieId': categorieId,
    'statut': statut,
  };

  factory ArticlesModels.fromJson(
    Map<String, dynamic> json, {
    String id = '',
  }) => ArticlesModels(
    id: id.isNotEmpty ? id : (json['id'] ?? ''),
    photo: json['photo'] ?? '',
    nameArticle: json['nameArticle'] ?? '',
    description: json['description'] ?? '',
    prix: json['prix'] ?? 0,
    vendeurId: json['vendeurId'] ?? '',
    categorieId: json['categorieId'] ?? '',
    statut: json['statut'] ?? 'active',
  );
}
