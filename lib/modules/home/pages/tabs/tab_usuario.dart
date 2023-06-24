import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mix/mix.dart';

import '../../../../components/title.dart';
import '../../../../config/api.dart';
import '../../../../entities/item.dart';
import '../../../../entities/review.dart';
import '../../../../entities/usuario.dart';
import '../home_page.dart';

class TabUsuario extends StatefulWidget {
  final int id;
  const TabUsuario({Key? key, required this.id}) : super(key: key);

  @override
  _TabUsuarioState createState() => _TabUsuarioState();
}

class _TabUsuarioState extends State<TabUsuario> {
  late Item item = Item(0, "", "", 0, 0, "", []);
  late Review review = Review(
      id: 0, itemId: 0, star: 0, text: "", userId: 0, usuario: Usuario());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController precoController = TextEditingController();

  final TextEditingController ratingController = TextEditingController();
  final TextEditingController comentarioController = TextEditingController();
  @override
  void initState() {
    super.initState();
    categoriaValue = 1; // Defina um valor padrão para a categoria
  }

  late int categoriaValue;
  void criarItem(String categoria) async {
    item.nome = nomeController.text;
    item.categoria = getDropdownValue(categoria);
    item.marca = marcaController.text;
    item.price = double.parse(precoController.text);
    item.rating = double.parse(ratingController.text);
    const url = '$baseURL/items';
    print("url");
    if (categoria == "Categoria") {
      Fluttertoast.showToast(
        msg: 'Erro ao inserir o produto!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0,
      );
      return;
    }
    var body = json.encode({
      'name': item.nome,
      'category': item.categoria,
      'averagerating': item.rating,
      'price': item.price,
      'brand_name': item.marca,
      'user': {"id": widget.id}
    });

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = json.decode(response.body);

      if (response.statusCode == 201) {
        print("response");
        var responseBody = response.body;

        // Fazendo o parsing do JSON
        var parsedJson = json.decode(responseBody);

        // Acessando o valor do campo "id"
        int id = parsedJson['id'];
        print(id);
        criarReview(id);
      } else {
        if (responseMap["message"].contains('EMAIL_DUPLICADO')) {
          Fluttertoast.showToast(
            msg: 'E-mail duplicado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Erro ao inserir o usuário!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0,
          );
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('erro!');
        print(error);
      }
    }
  }

  void criarReview(int itemId) async {
    review.text = comentarioController.text;
    review.star = double.parse(ratingController.text);

    const url = '$baseURL/reviews';

    var body = json.encode({
      'item_id': itemId,
      'text': review.text,
      'stars': review.star,
      'user': {"id": widget.id}
    });

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = json.decode(response.body);

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              id: widget.id,
            ),
          ),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('erro!');
        print(error);
      }
    }
  }

  String getDropdownValue(String value) {
    switch (value) {
      case 'Eletrônicos':
        return "eletronic";
      case 'Livros':
        return "book";
      case 'Mobílias':
        return "furniture";
      case 'Videogames':
        return "video_game";
      case 'Jogos de tabuleiro':
        return "video_game";
      case 'Roupas':
        return "clothe";
      case 'Veículos':
        return "vehicle";

      default:
        return "Categoria";
    }
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Categoria';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const TitleRater(),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromRGBO(
          0, 56, 107, 1), // Alterar a cor de fundo do Scaffold para vermelho
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Adicione um produto aqui',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'LatoBold',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 40),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                  width: 400,
                  child: TextFormField(
                    controller: nomeController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Nome',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: 400,
                  child: DropdownButtonFormField<String>(
                    value: dropdownValue,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    items: <String>[
                      'Categoria',
                      'Livros',
                      'Eletrônicos',
                      'Mobílias',
                      'Videogames',
                      'Jogos de tabuleiro',
                      'Roupas',
                      'Veículos',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'LatoBold',
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        categoriaController.text = dropdownValue;
                        print(dropdownValue);

                        categoriaController.text = dropdownValue;
                        print(categoriaController.text);
                      });
                    },
                    dropdownColor: const Color.fromRGBO(0, 56, 107, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                      color: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: 400,
                  child: TextFormField(
                    controller: marcaController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Marca',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: 400,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: precoController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Preço',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: 400,
                  child: TextFormField(
                    controller: comentarioController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Comentario',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                HBox(
                  children: [
                    const Text(
                      " Nota Geral",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'LatoBold',
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 50,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        ratingController.text =
                            rating.toString(); // Atualiza a precoController
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  height: 60, //height of button
                  width: 400, //width of button equal to parent widget
                  child: ElevatedButton(
                    child: const Text('ADICIONAR',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 56, 107, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'LatoBold',
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Valor para ajustar a curvatura da borda
                      ),
                    ),
                    onPressed: () {
                      criarItem(categoriaController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
