class CategoriesModels {
  String id;
  String nameCategorie;

  CategoriesModels({
    this.id ='',
    required this.nameCategorie,
  });

  Map<String, dynamic> toJson()=>{
    'id':id,
    'nameCategorie': nameCategorie,
  };

  CategoriesModels fromJson(Map<String, dynamic> json) => CategoriesModels(
    nameCategorie: json['nameCategorie'],
  );
}
