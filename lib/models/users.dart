import 'package:flutter/foundation.dart';

class Users {
  String id;
  String user_id;
  String username;
  String password;
  String name;
  String image;
  String login_type;
  String bio;
  String token;
  String field;


  Users({this.id, this.user_id, this.username, this.password, this.name,
      this.image, this.login_type,this.bio,this.token,this.field});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        id: json["id"],
        user_id: json["user_id"],
        username: json["username"],
        password: json["password"],
        name: json["name"],
        image: json["image"],
        login_type: json["login_typ"],
        bio: json["bio"],
        token: json['token'],
        field: json['field']
    );
  }
}
