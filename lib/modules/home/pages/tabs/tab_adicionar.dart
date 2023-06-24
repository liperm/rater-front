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

// ignore: must_be_immutable
class TabCriados extends StatefulWidget {
  int idUser;

  TabCriados({Key? key, required this.idUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabCriadosState();
}

class _TabCriadosState extends State<TabCriados> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Future<List<Item>> futureItem;

  @override
  void initState() {
    super.initState();
    futureItem = _fetchItems();
  }

  @override
  void didUpdateWidget(TabCriados oldWidget) {
    super.didUpdateWidget(oldWidget);
    futureItem = _fetchItems();
  }

  Future<List<Item>> _fetchItems() async {
    var url = '$baseURL/users/${widget.idUser}/items';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      try {
        List<Item> objetivos =
            jsonResponse.map((obj) => Item.fromJson(obj)).toList();

        return objetivos;
      } catch (err) {
        return [];
      }
    } else {
      throw Exception('Sem produtos');
    }
  }

  Widget buildThis() {
    return FutureBuilder<List<Item>>(
      future: futureItem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Item> objetivos = snapshot.data!;
          objetivos = objetivos.reversed.toList();
          return ListView.builder(
            itemCount: objetivos.length,
            itemBuilder: (BuildContext context, int index) {
              final objetivo = objetivos[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CardFeed(
                  idUser: widget.idUser,
                  idItem: objetivo.id!,
                  category: objetivo.categoria!,
                  name: objetivo.nome!,
                  stars: objetivo.rating!,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Sem produto criado",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w100,
                fontFamily: 'LatoBold',
              ),
            ),
          );
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
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
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: buildThis(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      futureItem = _fetchItems();
    });
  }
}
