class Admin {
  final int? adminId;
  final String username;
  final String password;

  Admin({
    this.adminId,
    required this.username,
    required this.password,
  });

  factory Admin.fromMap(Map<String, dynamic> json) => Admin(
        adminId: json["adminid"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "adminid": adminId,
        "username": username,
        "password": password,
      };
}
