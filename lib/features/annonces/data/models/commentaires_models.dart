class CommentairesModels {
  String id;
  String contenu;
  DateTime datePublication;
  String produitId;  // Lien vers ArticlesModels.id : sur quel produit porte le commentaire
  String auteurId;   // Lien vers Users.id : qui a écrit le commentaire

  CommentairesModels({
    this.id = '',
    required this.contenu,
    required this.datePublication,
    required this.produitId,
    required this.auteurId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'contenu': contenu,
    'datePublication': datePublication,
    'produitId': produitId,
    'auteurId': auteurId,
  };

  factory CommentairesModels.fromJson(Map<String, dynamic> json, {String id = ''}) =>
      CommentairesModels(
        id: id.isNotEmpty ? id : (json['id'] ?? ''),
        contenu: json['contenu'] ?? '',
        datePublication: json['datePublication'] is DateTime
            ? json['datePublication']
            : (json['datePublication']?.toDate() ?? DateTime.now()),
        produitId: json['produitId'] ?? '',
        auteurId: json['auteurId'] ?? '',
      );
}
