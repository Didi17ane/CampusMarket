class CommentairesModels {
  String id;
  String contenu;
  DateTime datePublication;

  CommentairesModels({
    this.id = '',
    required this.contenu,
    required this.datePublication,
  });

  Map<String, dynamic> toJson() => {
  'id': id,
  'contenu': contenu,
  'datePublication': datePublication,
};

  CommentairesModels fromJson(Map<String, dynamic> json) => CommentairesModels(
  id: json['id'],
  contenu: json['contenu'],
  datePublication: json['datePublication'],
);

}


