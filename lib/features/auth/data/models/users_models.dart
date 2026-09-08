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

  Users fromJson(Map<String, dynamic> json) => Users(
    name: json['name'],
    lastname: json['lastname'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    photo: json['photo'],
  );
}
