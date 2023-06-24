import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/card.dart';
import '../../../../components/title.dart';
import '../../../../config/api.dart';
import '../../../../entities/item.dart';
import '../../../../entities/usuario.dart';

bool criarCard = false;
bool isVisible2 = false;
String? myData;
Usuario? usuario2;

class TelaProdutos extends StatefulWidget {
  String categoria;

  TelaProdutos({Key? key, required this.categoria}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TelaProdutos();
}

class _TelaProdutos extends State<TelaProdutos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Item>> futureItems;
  late Future<Usuario> futureUsuario;

  @override
  void initState() {
    super.initState();
    futureItems = _fetchItems();
  }

  Future<List<Item>> _fetchItems() async {
    var url = '$baseURL/items';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      try {
        List<Item> objetivos = jsonResponse
            .map((obj) => Item.fromJson(obj))
            .where((objetivo) => objetivo.categoria == widget.categoria)
            .toList();
        return objetivos;
      } catch (err) {
        return [];
      }
    } else {
      throw ('Sem produtos');
    }
  }

  Widget buildThis() {
    return FutureBuilder<List<Item>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Item> objetivos = snapshot.data!;
          return ListView.builder(
            itemCount: objetivos.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CardFeed(
                  idUser: 0,
                  idItem: objetivos[index].id!,
                  category: objetivos[index].categoria!,
                  name: objetivos[index].nome!,
                  stars: objetivos[index].rating!,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text("Sem objetivos");
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
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
      backgroundColor: const Color.fromRGBO(0, 56, 107, 1),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 56, 107, 1),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(top: 10), child: buildThis()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
