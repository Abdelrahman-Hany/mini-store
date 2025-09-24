import 'package:mini_store/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
  }); // here we are passing the parameters to the super class constructor which is the User class

  factory UserModel.fromJeson(Map<String, dynamic> map) {
    return UserModel(id: map["id"] ?? '', email: map["email"] ?? '', name: map["name"] ?? '');
  }
}
