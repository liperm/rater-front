import 'item.dart';

class Favorito {
  int? id;
  int? idUser;
  int? idItem;

  Item item;

  Favorito({
    this.id,
    this.idUser,
    this.idItem,
    required this.item,
  });

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
      id: json['id'],
      idUser: json['user_id'],
      idItem: json['item_id'],
      item: Item.fromJson(json['item']),
    );
  }
}
