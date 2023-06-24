import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../../components/title.dart';
import '../../../../config/api.dart';
import '../../../../entities/item.dart';
import '../../../../entities/review.dart';
import '../../../../entities/usuario.dart';
import '../home_page.dart';

class TabReview extends StatefulWidget {
  final int id;
  const TabReview({Key? key, required this.id}) : super(key: key);

  @override
  _TabReviewState createState() => _TabReviewState();
}

class _TabReviewState extends State<TabReview> {
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

  void criarItem() async {
    item.nome = nomeController.text;
    item.categoria = categoriaController.text;
    item.marca = marcaController.text;
    item.price = double.parse(precoController.text);
    item.rating = double.parse(ratingController.text);

    const url = '$baseURL/items';
    print("url");
    print(item.rating);
    var body = json.encode({
      'name': item.nome,
      'category': item.categoria,
      'averagerating': item.rating,
      'price': item.price,
      'brand_name': item.marca,
      'user': {"id": 1}
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const TitleRater(),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      backgroundColor:
          Colors.brown[200], // Alterar a cor de fundo do Scaffold para vermelho
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: 400,
                child: TextFormField(
                  controller: comentarioController,
                  style: const TextStyle(color: Colors.white),
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
                      color: Colors.white,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  criarItem();
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
