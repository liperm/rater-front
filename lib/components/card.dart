import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Icon;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mix/mix.dart';
import 'package:rater/config/api.dart';

import '../entities/item.dart';
import '../modules/home/pages/tabs/tab_produto.dart';

class CardFeed extends StatefulWidget {
  final String name;
  final String category;
  final double stars;
  final int idUser;
  final int idItem;
  final void Function()? onPressed;

  const CardFeed({
    Key? key,
    required this.name,
    required this.category,
    required this.idUser,
    required this.idItem,
    this.onPressed,
    required this.stars,
  }) : super(key: key);

  static const Key circleKey = Key("circleKey");
  static const Key cardKey = Key("cardKey");

  @override
  _CardFeedState createState() => _CardFeedState();
}

class _CardFeedState extends State<CardFeed> with TickerProviderStateMixin {
  late bool _buttonColor = false;
  final style = Mix(
    bgColor(Colors.white),
    px(25),
    py(20),
    mainAxis(MainAxisAlignment.spaceEvenly),
  );
  final vboxstyle = Mix(
    mainAxis(MainAxisAlignment.start),
    crossAxis(CrossAxisAlignment.start),
  );

  @override
  void initState() {
    super.initState();
    _initializeButtonColor();
  }

  Future<void> _initializeButtonColor() async {
    bool fetchResult = await _fetchItems();
    setState(() {
      _buttonColor = fetchResult;
    });
  }

  Future<bool> _fetchItems() async {
    var url = '$baseURL/users/${widget.idUser}/favorites';

    Map<String, String> headers = {};

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      try {
        List<Item> objetivos =
            jsonResponse.map((obj) => Item.fromJson(obj)).toList();

        // Verificar se o ID é igual ao ID de algum objetivo
        bool objetivoEncontrado = false;
        for (var objetivo in objetivos) {
          if (objetivo.id == widget.idItem) {
            objetivoEncontrado = true;
            break;
          }
        }

        return objetivoEncontrado;
      } catch (err) {
        return false;
      }
    } else {
      throw Exception('Sem produtos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TabProduto(idItem: widget.idItem, idUser: widget.idUser),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: HBox(
              mix: style,
              children: [
                Lottie.network(
                    'https://assets4.lottiefiles.com/packages/lf20_NODCLWy3iX.json',
                    height: 70),
                const SizedBox(width: 16),
                HBox(
                  mix: vboxstyle,
                  children: [
                    HBox(
                      mix: vboxstyle,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Alinha os itens à esquerda
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'LatoBold',
                                color: Color.fromRGBO(0, 56, 107, 1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Categoria: ${widget.category}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'LatoBold',
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Alinha os itens à esquerda
                              children: [
                                const Text(
                                  "Nota Geral",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'LatoBold',
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: widget.stars,
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 16,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    // Callback para atualização da classificação selecionada
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 100),
                VBox(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: _buttonColor ? Colors.red : Colors.black,
                      size: 35,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
