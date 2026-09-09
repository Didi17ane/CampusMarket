class CategoriesModels {
  String id;
  String nameCategorie;

  CategoriesModels({
    this.id = '',
    required this.nameCategorie,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nameCategorie': nameCategorie,
  };

  factory CategoriesModels.fromJson(Map<String, dynamic> json, {String id = ''}) =>
      CategoriesModels(
        id: id.isNotEmpty ? id : (json['id'] ?? ''),
        nameCategorie: json['nameCategorie'] ?? '',
      );
}