import 'package:rater/entities/review.dart';

class Item {
  int? id;
  String? nome;
  String? categoria;
  double? rating;
  double? price;
  String? marca;
  List<Review>? reviews;

  Item(
    this.id,
    this.nome,
    this.categoria,
    this.rating,
    this.price,
    this.marca,
    this.reviews,
  );

  factory Item.fromJson(Map<String, dynamic> json) {
    var list = json['reviews'] as List?;

    List<Review>? reviewList;
    if (list != null) {
      reviewList = list.map((i) => Review.fromJson(i)).toList();
    }

    return Item(
        json['id'],
        json['name'],
        json['category'],
        json['averagerating'] != null
            ? double.parse(json['averagerating'].toString())
            : null,
        json['price'] != null ? double.parse(json['price'].toString()) : null,
        json['brand_name'],
        reviewList);
  }
}
