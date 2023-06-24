// import 'dart:convert';

// import 'package:biblioteca_flutter/entities/investimento.dart';
// import 'package:biblioteca_flutter/entities/usuario.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:mix/mix.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../components/cardCategoria.dart';
// import '../../../../config/api.dart';

// String? myData;
// Usuario? usuario1;

// class TabInvestimento extends StatefulWidget {
//   const TabInvestimento({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _TabInvestimento();
// }

// class _TabInvestimento extends State<TabInvestimento> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late Future<List<Investimento>> futureInvestimentos;
//   late Future<Usuario> futureUsuario;
//   bool _buttonColor = false;

//   late Item objetivo = Item(
//       id: 0, nome: "", valorEntrada: 0, valorEstimado: 0, valorMensal: "0");

//   @override
//   void initState() {
//     super.initState();
//     futureInvestimentos = _mostrarInvest();
//     futureUsuario = _fetchUsuario();
//   }

//   void submit() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       if (objetivo.nome == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe o nome!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else if (objetivo.valorEstimado == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe o valor estimado!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else if (objetivo.valorEntrada == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe o valor entrada!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else if (objetivo.tempoConclusao == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe o tempo conclusao!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else {
//         futureInvestimentos = _mostrarInvestimentos();
//         setState(() {
//           myData = "a";
//         });
//       }
//     }
//   }

//   Future<Usuario> _fetchUsuario() async {
//     const url = '$baseURL/usuarios/getUsuario';
//     final preferences = await SharedPreferences.getInstance();
//     final token = preferences.getString('auth_token');
//     Map<String, String> headers = {};
//     headers["Authorization"] = 'Bearer $token';
//     final response = await http.get(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonResponse =
//           json.decode(utf8.decode(response.bodyBytes));
//       usuario1 = Usuario.fromJson(jsonResponse);

//       Usuario usuario = Usuario.fromJson(jsonResponse);
//       return usuario;
//     } else {
//       Fluttertoast.showToast(
//           msg: 'Erro ao listar os usuario',
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           backgroundColor: Colors.red,
//           fontSize: 20.0);
//       throw ('Sem Usuário');
//     }
//   }

//   void _adicionarItem(Item objetivo, Investimento investimento1) async {
//     String pmt = (investimento1.pmt).toString();
//     print(pmt);
//     const url = '$baseURL/objetivos';
//     var body = json.encode({
//       'nome': objetivo.nome,
//       'tempoConclusao': objetivo.tempoConclusao,
//       'valorEstimado': objetivo.valorEstimado,
//       'valorEntrada': objetivo.valorEntrada,
//       'valorMensal': investimento1.pmt,
//       'usuario': {'id': usuario1?.id},
//       'investimento': {'id': investimento1.id},
//     });

//     final preferences = await SharedPreferences.getInstance();
//     final token = preferences.getString('auth_token');
//     Map<String, String> headers = {};
//     headers["Content-Type"] = "application/json";
//     headers["Authorization"] = 'Bearer $token';
//     try {
//       final response =
//           await http.post(Uri.parse(url), headers: headers, body: body);
//       Fluttertoast.showToast(
//           msg: 'OBJETIVO ADICIONADO!',
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           backgroundColor: Colors.blue,
//           fontSize: 20.0);
//     } on Object catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//     }
//   }

//   Future<List<Investimento>> _mostrarInvestimentos() async {
//     var url =
//         '$baseURL/investimentos/getInvestimentosComPmt/${objetivo.tempoConclusao}/${objetivo.valorEntrada}/${objetivo.valorEstimado}';
//     final preferences = await SharedPreferences.getInstance();
//     final token = preferences.getString('auth_token');
//     Map<String, String> headers = {};
//     headers["Authorization"] = 'Bearer $token';
//     final response = await http.get(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
//       return jsonResponse
//           .map((investmento) => Investimento.fromJson(investmento))
//           .toList();
//     } else {
//       throw ('Sem investimentos');
//     }
//   }

//   Future<List<Investimento>> _mostrarInvest() async {
//     var url = '$baseURL/investimentos/getInvestimentosComPmt/1/0/0';
//     final preferences = await SharedPreferences.getInstance();
//     final token = preferences.getString('auth_token');
//     Map<String, String> headers = {};
//     headers["Authorization"] = 'Bearer $token';
//     final response = await http.get(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
//       return jsonResponse
//           .map((investmento) => Investimento.fromJson(investmento))
//           .toList();
//     } else {
//       throw ('Sem investimentos');
//     }
//   }

//   Widget buildThis() {
//     return FutureBuilder<List<Investimento>>(
//       future: futureInvestimentos,
//       builder: (context, snapshot) {
//         if (snapshot.data != null) {
//           List<Investimento> _investimento = snapshot.data!;
//           return ListView.builder(
//               itemCount: _investimento.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                   color: Colors.white,
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Text(
//                             'Investimento: ${_investimento[index].investimento}\nRisco: ${_investimento[index].risco!.nome!}\nTaxa: ${_investimento[index].rentabilidade}\nInvestimento mensal: ${_investimento[index].pmt}',
//                             textAlign: TextAlign.start,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 fontFamily: 'BebasNeue', color: Colors.grey),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: IconButton(
//                               icon: const Icon(Icons.add, size: 20),
//                               color: Colors.blue,
//                               onPressed: () {
//                                 _adicionarItem(
//                                     objetivo, _investimento[index]);
//                               }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               });
//         } else if (myData == "error") {
//           return const Text("Sem investimentoss");
//         }
//         // By default show a loading spinner.
//         return const Text("Sem investimentoss");
//       },
//     );
//   }

//   final hboxstyle = Mix(
//     mainAxis(MainAxisAlignment.spaceBetween),
//   );

//   Widget buildItens() {
//     return const VBox(
//       children: [
//         CardCategoria(
//           category: "a",
//           name: "d",
//           stars: 4,
//         ),
//         CardCategoria(
//           category: "a",
//           name: "d",
//           stars: 4,
//         ),
//         CardCategoria(
//           category: "a",
//           name: "d",
//           stars: 4,
//         ),
//       ],
//     );
//   }

//   void _changeColor() {
//     setState(() {
//       // Altera a cor do botão para uma cor aleatória
//       _buttonColor = !_buttonColor;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//           ),
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                   color: Colors.red,
//                   height: 300,
//                   width: double.infinity,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 HBox(
//                   mix: hboxstyle,
//                   children: [
//                     const Text(
//                       'ITEM NAME',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Color.fromRGBO(0, 56, 107, 1),
//                         fontSize: 70,
//                         fontFamily: 'BebasNeue',
//                       ),
//                     ),
//                     IconButton(
//                       iconSize: 50,
//                       icon: const Icon(Icons.favorite),
//                       color: _buttonColor ? Colors.red : Colors.black,
//                       onPressed: () {
//                         // Ação quando o botão de coração for pressionado
//                         // Insira o código desejado aqui
//                         _changeColor();
//                         print('Botão de coração pressionado');
//                       },
//                     ),
//                   ],
//                 ),
//                 buildItens(),
//               ],
//             ),
//           )),
//     );
//   }
// }
