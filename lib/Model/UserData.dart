// User data model class
class UserData {
  final String email;
  final String uid;
  final String name;
  final String password;
  final String phone;
  final String gender;
  final String age;

  UserData({
    required this.email,
    required this.uid,
    required this.name,
    required this.password,
    required this.phone,
    required this.gender,
    required this.age,
  });

  // Convert UserData to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': uid,
      'name': name,
      'password': password,
      'phone': phone,
      'gender': gender,
      'age': age,
    };
  }

  // Create UserData from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      uid: json['uid'],
      name: json['name'],
      password: json['password'],
      phone: json['phone'],
      gender: json['gender'],
      age: json['age'],
    );
  }
}
