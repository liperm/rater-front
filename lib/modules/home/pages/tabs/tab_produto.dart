// ...

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mix/mix.dart';

import '../../../../components/common_modal.dart';
import '../../../../components/dispatch_bottom_modal.dart';
import '../../../../components/title.dart';
import '../../../../config/api.dart';
import '../../../../entities/item.dart';
import '../home_page.dart';

class TabProduto extends StatefulWidget {
  final int idItem;
  final int idUser;

  const TabProduto({Key? key, required this.idUser, required this.idItem})
      : super(key: key);

  @override
  State<TabProduto> createState() => _TabProdutoState();
}

class _TabProdutoState extends State<TabProduto> {
  late Future<Item> _futureItem;
  bool _buttonColor = false;

  @override
  void initState() {
    super.initState();
    _futureItem = _fetchItem(widget.idItem);
    _initializeButtonColor();
  }

  Future<void> _initializeButtonColor() async {
    bool fetchResult = await _fetchItems();
    setState(() {
      _buttonColor = fetchResult;
    });
  }

  final style = Mix(
    bgColor(
      const Color.fromRGBO(0, 56, 107, 1),
    ),
    mainAxis(MainAxisAlignment.spaceEvenly),
  );

  Future<Item> _fetchItem(int id) async {
    final url = '$baseURL/items/$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Response");
      print(response.body);
      return Item.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch objetivo');
    }
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
      throw ('Sem produtos');
    }
  }

  DispatchBottomModal _buildModal({required Widget child}) {
    return DispatchBottomModal(
      context: context,
      child: child,
    );
  }

  void _refreshItem() {
    setState(() {
      _futureItem = _fetchItem(widget.idItem);
    });
  }

  void adicionarFavorito(int itemId, int userId) async {
    const url = '$baseURL/users/favorites';

    var body = json.encode({
      'item_id': itemId,
      'user_id': userId,
    });

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = json.decode(response.body);

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: 'Adicionado como favorito',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } catch (error) {
      if (kDebugMode) {
        print('erro!');
        print(error);
      }
    }
  }

  void removerFavorito() async {
    int iduser = widget.idUser;
    int iditem = widget.idItem;
    var url = '$baseURL/users/$iduser/favorites/$iditem';

    var body = json.encode({});

    try {
      final response = await http.delete(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 204) {
        Fluttertoast.showToast(
            msg: 'removido dos favoritos',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } catch (error) {
      if (kDebugMode) {
        print('erro!');
        print(error);
      }
    }
  }

  void _changeColor() {
    setState(() {
      _buttonColor = !_buttonColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              width: width,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(100)),
                child: VBox(mix: style, children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const <Widget>[
                      TitleRater(
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FutureBuilder<Item>(
                                future: _futureItem,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else {
                                    final objetivo = snapshot.data!;
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Lottie.network(
                                            'https://assets4.lottiefiles.com/packages/lf20_NODCLWy3iX.json',
                                            height: 100),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          textDirection: TextDirection.ltr,
                                          children: [
                                            Text("Produto: ${objetivo.nome!}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'LatoBold',
                                                )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "Categoria: ${objetivo.categoria!}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'LatoBold',
                                                )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text("Marca: ${objetivo.marca!}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'LatoBold',
                                                )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            RatingBar.builder(
                                              initialRating: objetivo.rating!,
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "Valor: R\$${objetivo.price!.toString()}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'LatoBold',
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 60,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _changeColor();
                                            if (_buttonColor == true) {
                                              adicionarFavorito(
                                                  widget.idItem, widget.idUser);
                                              print('Heart button pressed');
                                            } else {
                                              removerFavorito();
                                            }
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: _buttonColor
                                                ? Colors.red
                                                : Colors.black,
                                            size: 35,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
            FutureBuilder<Item>(
              future: _futureItem,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final objetivo = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: objetivo.reviews!.length,
                      itemBuilder: (context, index) {
                        final review = objetivo.reviews![index];
                        return Card(
                          shadowColor: Colors.grey,
                          margin: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Ajuste o valor do raio conforme necessário
                          ),
                          color: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListTile(
                              title: Text(
                                review.usuario!.nome!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'LatoBold',
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Nota: ",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w100,
                                          fontFamily: 'LatoBold',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      RatingBar.builder(
                                        initialRating: review.star,
                                        minRating: 1,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          // Callback for updating selected rating
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Comentario:\n${review.text}",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      // fontWeight: FontWeight.w100,
                                      fontFamily: 'LatoBold',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 90,
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(id: 32),
                  ),
                );
              },
              child: const Icon(Icons.home),
              backgroundColor: const Color.fromRGBO(0, 56, 107, 1),
              foregroundColor: Colors.white,
            ),
            FloatingActionButton(
              onPressed: () async {
                await _buildModal(
                  child: CommonModal(
                    modalHeight: 700,
                    context: context,
                    idUser: widget.idUser,
                    idReview: widget.idItem,
                    title: 'a',
                    description: "a",
                  ),
                ).openModal();
                _refreshItem();
              },
              child: const Icon(Icons.add),
              backgroundColor: const Color.fromRGBO(0, 56, 107, 1),
              foregroundColor: Colors.white,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
