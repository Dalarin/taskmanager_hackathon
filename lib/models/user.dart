class User {
  int? id;
  String FIO;
  String phone;
  String email;
  String password;

  User(
      {this.id,
      required this.FIO,
      required this.phone,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {'fio': FIO, 'tel': phone, 'email': email, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      FIO: map['fio'] ?? '',
      phone: map['tel'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
