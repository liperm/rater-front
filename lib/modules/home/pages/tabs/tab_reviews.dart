import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rater/modules/home/pages/tabs/tela_produtos_review.dart';

import '../../../../components/title.dart';
import '../../../../config/api.dart';
import '../../../../entities/listaReview.dart';

class TabProdutos extends StatefulWidget {
  const TabProdutos({Key? key}) : super(key: key);

  @override
  _TabProdutosState createState() => _TabProdutosState();
}

class _TabProdutosState extends State<TabProdutos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 56, 107, 1),
      appBar: AppBar(
        centerTitle: true,
        title: const TitleRater(),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ListaReview>> futureListaReview;

  @override
  void initState() {
    super.initState();
    futureListaReview = _fetchLista();
  }

  @override
  Widget build(BuildContext context) {
    return buildThis();
  }

  Future<List<ListaReview>> _fetchLista() async {
    var url = '$baseURL/categories';

    Map<String, String> headers = {};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);

      try {
        List<dynamic> categories = jsonResponse['categories'];
        List<ListaReview> lista = categories
            .map((category) => ListaReview.fromJson(category))
            .toList();

        return lista;
      } catch (err) {
        return [];
      }
    } else {
      throw Exception('Sem produtos');
    }
  }

  String getDropdownValue(String value) {
    switch (value) {
      case 'eletronic':
        return "Eletrônicos";
      case 'book':
        return "Livros";
      case 'furniture':
        return "Mobílias";
      case 'video_game':
        return "Videogames";
      case 'board_game':
        return "Jogos de tabuleiro";
      case 'clothe':
        return "Roupas";
      case 'vehicle':
        return "Veículos";

      default:
        return "Categoria";
    }
  }

  Widget buildThis() {
    return FutureBuilder<List<ListaReview>>(
      future: futureListaReview,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          List<ListaReview> lista = snapshot.data!;
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListTile(
                  title: Text(
                    getDropdownValue(lista[index].nome!),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'LatoBold',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TelaProdutos(categoria: lista[index].nome!)),
                    );
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Sem ListaReview"),
          );
        }
        return const SizedBox(); // Caso contrário, retorna um widget vazio.
      },
    );
  }
}
