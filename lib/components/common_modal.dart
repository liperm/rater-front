import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart" hide Icon;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import "package:mix/mix.dart";
import 'package:rater/components/title.dart';

import '../config/api.dart';
import '../entities/review.dart';
import '../entities/usuario.dart';

class ButtonPropertiesCustomModal {
  final Function() onPress;
  final String title;

  ButtonPropertiesCustomModal({
    required this.onPress,
    required this.title,
  });
}

class CommonModal extends StatelessWidget {
  final ButtonPropertiesCustomModal? onPressButton;
  final ButtonPropertiesCustomModal? onCloseButton;
  final ButtonPropertiesCustomModal? tertiaryButton;

  final String title;
  final String description;
  final double modalHeight;
  final bool? loading;
  final int idUser;
  final int idReview;
  final BuildContext context;

  CommonModal({
    super.key,
    required this.title,
    required this.description,
    required this.idReview,
    required this.idUser,
    required this.context,
    this.modalHeight = 450,
    this.onPressButton,
    this.onCloseButton,
    this.tertiaryButton,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: modalHeight,
      child: _buildBody(),
    );
  }

  late Review review = Review(
      id: 0, itemId: 0, star: 0, text: "", userId: 0, usuario: Usuario());
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController comentarioController = TextEditingController();
  void criarReview(int itemId) async {
    review.text = comentarioController.text;
    review.star = double.parse(ratingController.text);

    const url = '$baseURL/reviews';

    var body = json.encode({
      'item_id': idReview,
      'text': review.text,
      'stars': review.star,
      'user': {"id": idUser}
    });
    print("body");
    print(body);

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = json.decode(response.body);

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (kDebugMode) {
        print('erro!');
        print(error);
      }
    }
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: SafeArea(
        child: Column(
          children: [
            ..._buildHeader(),
            const SizedBox(height: 10),
            ..._buildContent(),
            const Spacer(),
            const Spacer()
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      const TitleRater(
        color: Color.fromRGBO(0, 56, 107, 1),
      ),
      TextFormField(
        controller: comentarioController,
        style: const TextStyle(color: Color.fromRGBO(0, 56, 107, 1)),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color.fromRGBO(0, 56, 107, 1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color.fromRGBO(0, 56, 107, 1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color.fromRGBO(0, 56, 107, 1)),
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 50), // Aumenta a altura da caixa de texto
          hintText: '   Comentario',
          hintStyle: const TextStyle(color: Color.fromRGBO(0, 56, 107, 1)),
          labelStyle: const TextStyle(color: Color.fromRGBO(0, 56, 107, 1)),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "  Avaliacao",
            textAlign: TextAlign.start,
            style:
                TextStyle(color: Color.fromRGBO(0, 56, 107, 1), fontSize: 20),
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 24,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              ratingController.text = rating.toString();
            },
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text(
              'Adicionar comentario',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'BebasNeue',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 56, 107, 1),
              foregroundColor: const Color.fromRGBO(0, 56, 107, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: Colors.transparent, // Cor transparente para a borda
                ),
              ),
            ),
            onPressed: () {
              criarReview(idUser);
            },
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildHeader() {
    final styles = Mix(
      height(8),
      width(40),
      bgColor(Colors.grey),
      rounded(5),
    );
    return [
      const SizedBox(height: 10),
      Box(
        key: const Key("line-header"),
        mix: styles,
      ),
      const SizedBox(height: 10),
    ];
  }
}
