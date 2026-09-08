class Users {
  String id;
  String name;
  String lastname;
  String email;
  String phoneNumber;
  String photo;

  Users({
    this.id = '',
    required this.name,
    required this.lastname,
    required this.email,
    required this.phoneNumber,
    required this.photo,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lastname': lastname,
    'email': email,
    'phoneNumber': phoneNumber,
    'photo': photo,
  };

  // Factory : permet d'écrire Users.fromJson(json) directement,
  // sans avoir besoin d'une instance existante au préalable.
  factory Users.fromJson(Map<String, dynamic> json, {String id = ''}) => Users(
    id: id.isNotEmpty ? id : (json['id'] ?? ''),
    name: json['name'] ?? '',
    lastname: json['lastname'] ?? '',
    email: json['email'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
    photo: json['photo'] ?? '',
  );
}
