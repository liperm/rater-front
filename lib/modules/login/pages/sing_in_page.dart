import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../config/api.dart';
import '../../../entities/usuario.dart';
import '../../home/pages/home_page.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Usuario usuario =
      Usuario(id: 0, nome: "", email: "", senha: "", confirmarSenha: "");

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (usuario.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.email == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o e-mail!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.senha == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a senha!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.confirmarSenha == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a confirmação da senha!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.senha != usuario.confirmarSenha) {
        Fluttertoast.showToast(
            msg: 'As senhas não são iguais!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        criarConta();
      }
    }
  }

  void criarConta() async {
    const url = '$baseURL/users';
    var body = json.encode({
      'name': usuario.nome,
      'email': usuario.email,
      'password': usuario.senha
    });
    print("url");
    print(url);
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = json.decode(response.body);
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
        if (responseMap["message"].contains('EMAIL_DUPLICADO')) {
          Fluttertoast.showToast(
              msg: 'E-mail duplicado!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        } else {
          Fluttertoast.showToast(
              msg: 'Erro ao inserir o usuário!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        }
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print('erro!');
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 56, 107, 1),
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text(
          'Rater',
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: 'OleoScript', color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
      body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 56, 107, 1),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Criar conta',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'LatoBold',
                              color: Colors.white,
                              fontSize: 30))
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  'Informe seus dados abaixo para \ncontinuar.',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'LatoBold',
                                  color: Colors.white,
                                  fontSize: 20))
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 50, //height of button
                    width: 400, //width of button equal to parent widget
                    child: TextFormField(
                      onSaved: (String? value) {
                        usuario.nome = value!;
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
                            color: Colors.white,

                            // Cor branca para a borda quando o campo estiver habilitado
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors
                                .white, // Cor branca para a borda quando o campo estiver em foco
                          ),
                        ),
                        hintText: 'Nome completo',

                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily:
                              'LatoBold', // Cor branca para o texto do hint
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily:
                              'LatoBold', // Cor branca para o texto do rótulo
                        ),
                        // Estilo para o texto digitado
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
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
                          color:
                              Colors.white, // Cor branca para o texto do hint
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 50, //height of button
                    width: 400, //width of button equal to parent widget
                    child: TextFormField(
                      onSaved: (String? value) {
                        usuario.senha = value!;
                      },
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'LatoBold',
                          color: Colors.white),
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
                        hintText: 'Senha',

                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'LatoBold',
                          color:
                              Colors.white, // Cor branca para o texto do hint
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 50, //height of button
                    width: 400, //width of button equal to parent widget
                    child: TextFormField(
                      onSaved: (String? value) {
                        usuario.confirmarSenha = value!;
                      },
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'LatoBold',
                          color: Colors.white),
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
                        hintText: 'Confirmar senha',

                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'LatoBold',
                          color:
                              Colors.white, // Cor branca para o texto do hint
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: screenSize.width,
                  child: SizedBox(
                    height: 50, //height of button
                    width: 500, //width of button equal to parent widget
                    child: ElevatedButton(
                      child: const Text(
                        'Cadastrar',
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
                            color: Colors
                                .transparent, // Cor transparente para a borda
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
                Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.public,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: " RATER.COM",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'LatoBold',
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}
