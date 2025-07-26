class Users {
  final int? userId;
  final String? name;
  final String? email;
  final String username;
  final String password;
  final int? phone;

  Users({
    this.userId,
    this.name,
    this.email,
    required this.username,
    required this.password,
    this.phone,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userid"],
        name: json["name"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        phone: int.parse(json["phone"]),
      );

  Map<String, dynamic> toMap() => {
        "userid": userId,
        "name": name,
        "email": email,
        "username": username,
        "password": password,
        "phone": phone,
      };
}
