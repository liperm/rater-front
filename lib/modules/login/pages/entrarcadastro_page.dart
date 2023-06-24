import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rater/modules/login/pages/sing_in_page.dart';

import '../../../config/api.dart';
import '../../../entities/usuario.dart';
import '../../home/pages/home_page.dart';

class EntrarCadastroPage extends StatefulWidget {
  const EntrarCadastroPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntrarCadastroPageState();
}

class _EntrarCadastroPageState extends State<EntrarCadastroPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Usuario usuario =
      Usuario(id: 0, nome: "", email: "", senha: "", confirmarSenha: "");

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (usuario.email == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o email!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        login();
      }
    }
  }

  void login() async {
    const url = '$baseURL/auth/login';
    var body = json.encode({'email': usuario.email, 'password': usuario.senha});

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      var responseBody = response.body;

      var parsedJson = json.decode(responseBody);

      final int id = parsedJson['id'];

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(id: id),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: 'E-mail e/ou senha incorretos!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  List skills = <String>[
    "Rater",
  ];
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    });
    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 56, 107, 1),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 200),
            buildAnimatedText(),
            const SizedBox(height: 100),
            Container(
              width: screenSize.width,
              child: SizedBox(
                  height: 50, //height of button
                  width: 400, //width of button equal to parent widget
                  child: TextFormField(
                    onSaved: (String? value) {
                      usuario.email = value!;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white, // Cor branca para a borda
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors
                              .white, // Cor branca para a borda quando o campo estiver habilitado
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors
                              .white, // Cor branca para a borda quando o campo estiver em foco
                        ),
                      ),
                      hintText: 'Email',

                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white, // Cor branca para o texto do hint
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color:
                            Colors.white, // Cor branca para o texto do rótulo
                      ),
                      // Estilo para o texto digitado
                    ),
                  )),
              alignment: Alignment.center,
            ),
            const SizedBox(height: 10),
            Container(
              width: screenSize.width,
              child: SizedBox(
                  height: 50, //height of button
                  width: 400, //width of button equal to parent widget
                  child: TextFormField(
                    onSaved: (String? value) {
                      usuario.senha = value!;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white, // Cor branca para a borda
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors
                              .white, // Cor branca para a borda quando o campo estiver habilitado
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors
                              .white, // Cor branca para a borda quando o campo estiver em foco
                        ),
                      ),
                      hintText: 'Password',

                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color: Colors.white, // Cor branca para o texto do hint
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LatoBold',
                        color:
                            Colors.white, // Cor branca para o texto do rótulo
                      ),
                      // Estilo para o texto digitado
                    ),
                  )),
              alignment: Alignment.center,
            ),
            const SizedBox(height: 10),
            Container(
              width: screenSize.width,
              child: SizedBox(
                height: 50, //height of button
                width: 400, //width of button equal to parent widget
                child: ElevatedButton(
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 56, 107, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LatoBold',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color:
                            Colors.transparent, // Cor transparente para a borda
                      ),
                    ),
                  ),
                  onPressed: () {
                    submit();
                  },
                ),
              ),
              alignment: Alignment.center,
            ),
            const SizedBox(height: 10),
            Container(
              width: screenSize.width,
              child: SizedBox(
                height: 50, //height of button
                width: 400, //width of button equal to parent widget
                child: ElevatedButton(
                  child: const Text('CRIAR CONTA',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingInPage(),
                      ),
                    );
                  },
                ),
              ),
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildAnimatedText() => AnimatedTextKit(
        animatedTexts: [
          for (var i = 0; i < skills.length; i++) buildText(i),
        ],
        repeatForever: true,
        pause: const Duration(milliseconds: 50),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      );

  buildText(int index) {
    return TypewriterAnimatedText(
      skills[index],
      cursor: ".",
      textAlign: TextAlign.center,
      textStyle: const TextStyle(
          fontFamily: 'OleoScript',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 100),
      speed: const Duration(milliseconds: 100),
    );
  }
}
