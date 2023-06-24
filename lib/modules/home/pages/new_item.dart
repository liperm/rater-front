// import 'dart:convert';

// import 'package:biblioteca_flutter/entities/usuario.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../config/api.dart';
// import '../../login/pages/login_page.dart';
// import '../../login/pages/sing_in_page.dart';

// Usuario? usuarioData;

// class NewItem extends StatefulWidget {
//   const NewItem({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _NewItem();
// }

// class _NewItem extends State<NewItem> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late Usuario usuario =
//       Usuario(id: 0, nome: "", email: "", senha: "", confirmarSenha: "");
//   late Future<Usuario> futureUsuario;

//   @override
//   void initState() {
//     super.initState();
//     futureUsuario = _fetchUsuario();
//   }

//   void submit() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       if (usuario.nome == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe o nome!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else if (usuario.email == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe o e-mail!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else if (usuario.senha == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe a senha!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else if (usuario.confirmarSenha == "") {
//         Fluttertoast.showToast(
//             msg: 'Por favor, informe a confirmação da senha!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else if (usuario.senha != usuario.confirmarSenha) {
//         Fluttertoast.showToast(
//             msg: 'As senhas não são iguais!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.red,
//             fontSize: 20.0);
//       } else {
//         _editarUsuario();
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
//       usuarioData = Usuario.fromJson(jsonResponse);

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

//   void _editarUsuario() async {
//     var id = usuarioData?.id;
//     var url = '$baseURL/usuarios/$id';
//     var body = '';
//     if (usuario.senha != "") {
//       body = json.encode({
//         'nome': usuario.nome,
//         'email': usuario.email,
//         'senha': usuario.senha
//       });
//     } else {
//       body = json.encode({'nome': usuario.nome, 'email': usuario.email});
//     }
//     final preferences = await SharedPreferences.getInstance();
//     final token = preferences.getString('auth_token');
//     Map<String, String> headers = {};
//     headers["Content-Type"] = "application/json";
//     headers["Authorization"] = 'Bearer $token';
//     try {
//       final response =
//           await http.put(Uri.parse(url), headers: headers, body: body);
//       if (response.statusCode == 200) {
//         Navigator.of(context).pop();
//         Fluttertoast.showToast(
//             msg: 'Usuário Editado!',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.green,
//             fontSize: 20.0);
//       } else {
//         Map<String, dynamic> responseMap = json.decode(response.body);
//         if (responseMap["message"].contains('ConstraintViolationException')) {
//           Fluttertoast.showToast(
//               msg: 'E-mail duplicado!',
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.CENTER,
//               backgroundColor: Colors.red,
//               fontSize: 20.0);
//         } else {
//           Fluttertoast.showToast(
//               msg: 'Erro ao editar o usuário!',
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.CENTER,
//               backgroundColor: Colors.red,
//               fontSize: 20.0);
//         }
//       }
//     } on Object catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     Future.delayed(Duration.zero, () async {
//       await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
//       final preferences = await SharedPreferences.getInstance();
//       final token = preferences.getString('auth_token');
//       if (token != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const LoginPage(),
//           ),
//         );
//       }
//     });
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
//       body: Container(
//           decoration: const BoxDecoration(color: Colors.red),
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                     child: RichText(
//                   textAlign: TextAlign.start,
//                   text: const TextSpan(
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: 'PERFIL',
//                           style: TextStyle(
//                               fontFamily: 'BebasNeue',
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontSize: 30))
//                     ],
//                   ),
//                 )),
//                 Container(
//                     margin: const EdgeInsets.only(top: 30.0),
//                     child: RichText(
//                       textAlign: TextAlign.start,
//                       text: const TextSpan(
//                         children: <TextSpan>[
//                           TextSpan(
//                               text: 'Dados pessoais',
//                               style: TextStyle(
//                                   fontFamily: 'BebasNeue',
//                                   color: Colors.white,
//                                   fontSize: 20))
//                         ],
//                       ),
//                     )),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                     height: 50, //height of button
//                     width: 400, //width of button equal to parent widget
//                     child: TextFormField(
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors.white, // Cor branca para a borda
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver habilitado
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver em foco
//                           ),
//                         ),
//                         hintText: 'Nome completo',

//                         hintStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do hint
//                         ),
//                         labelStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do rótulo
//                         ),
//                         // Estilo para o texto digitado
//                       ),
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     height: 50, //height of button
//                     width: 400, //width of button equal to parent widget
//                     child: TextFormField(
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors.white, // Cor branca para a borda
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver habilitado
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver em foco
//                           ),
//                         ),
//                         hintText: 'Email',

//                         hintStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do hint
//                         ),
//                         labelStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do rótulo
//                         ),
//                         // Estilo para o texto digitado
//                       ),
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     height: 50, //height of button
//                     width: 400, //width of button equal to parent widget
//                     child: TextFormField(
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors.white, // Cor branca para a borda
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver habilitado
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver em foco
//                           ),
//                         ),
//                         hintText: 'Senha',

//                         hintStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do hint
//                         ),
//                         labelStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do rótulo
//                         ),
//                         // Estilo para o texto digitado
//                       ),
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     height: 50, //height of button
//                     width: 400, //width of button equal to parent widget
//                     child: TextFormField(
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors.white, // Cor branca para a borda
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver habilitado
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: const BorderSide(
//                             color: Colors
//                                 .white, // Cor branca para a borda quando o campo estiver em foco
//                           ),
//                         ),
//                         hintText: 'Confirmar senha',

//                         hintStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do hint
//                         ),
//                         labelStyle: const TextStyle(
//                           color:
//                               Colors.white, // Cor branca para o texto do rótulo
//                         ),
//                         // Estilo para o texto digitado
//                       ),
//                     )),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   width: screenSize.width,
//                   child: SizedBox(
//                     height: 50, //height of button
//                     width: 500, //width of button equal to parent widget
//                     child: ElevatedButton(
//                       child: const Text(
//                         'Alterar senha',
//                         style: TextStyle(
//                           color: Color.fromRGBO(0, 56, 107, 1),
//                           fontSize: 20,
//                           fontFamily: 'BebasNeue',
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           side: const BorderSide(
//                             color: Colors
//                                 .transparent, // Cor transparente para a borda
//                           ),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SingInPage(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   alignment: Alignment.center,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                   height: 50, //height of button
//                   width: 500, //width of button equal to parent widget
//                   child: ElevatedButton(
//                     child: const Text(
//                       'Sair',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontFamily: 'BebasNeue',
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         side: const BorderSide(
//                           color: Colors
//                               .transparent, // Cor transparente para a borda
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SingInPage(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                     margin: const EdgeInsets.only(top: 50.0),
//                     child: RichText(
//                       text: const TextSpan(
//                         children: [
//                           WidgetSpan(
//                             child: Icon(
//                               Icons.public,
//                               size: 20,
//                               color: Colors.white,
//                             ),
//                           ),
//                           TextSpan(
//                             text: " RATER.COM",
//                           ),
//                         ],
//                       ),
//                     )),
//               ],
//             ),
//           )),
//     );
//   }
// }
