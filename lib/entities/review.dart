// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:rater/entities/usuario.dart';

class Review {
  int id;
  int userId;
  double star;
  String text;
  int itemId;
  Usuario? usuario;

  Review({
    required this.id,
    required this.userId,
    required this.star,
    required this.text,
    required this.itemId,
    this.usuario,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      itemId: json['item_id'],
      star: double.parse(json['stars'].toString()),
      text: json['text'],
      userId: json['user_id'],
      usuario: Usuario.fromJson(json['user']),
    );
  }
}
