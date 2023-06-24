// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart" hide Icon;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mix/mix.dart';

import 'customDivider.dart';
import 'custom_typography.dart';

class CardCategoria extends StatefulWidget {
  final String? text;
  final String? name;
  final String? category;
  final double? stars;

  final void Function()? onPressed;

  const CardCategoria({
    Key? key,
    this.name,
    this.text,
    this.category,
    this.stars,
    this.onPressed,
  }) : super(key: key);

  static const Key circleKey = Key("circleKey");
  static const Key cardKey = Key("cardKey");

  @override
  State<CardCategoria> createState() => _CardCategoriaState();
}

class _CardCategoriaState extends State<CardCategoria>
    with TickerProviderStateMixin {
  final style = Mix(
    bgColor(
      Colors.white,
    ),
    px(25),
    py(20),
    mainAxis(MainAxisAlignment.spaceBetween),
  );
  final color = Mix(
    bgColor(
      Colors.black,
    ),
    width(100),
  );
  final vboxstyle = Mix(
    mainAxis(MainAxisAlignment.start),
    crossAxis(CrossAxisAlignment.start),
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: HBox(
        mix: color,
        children: [
          ClipRRect(
            child: SizedBox(
              width: 100,
              child: VBox(
                mix: color,
                children: [
                  HBox(
                    mix: style,
                    children: [
                      VBox(
                        mix: vboxstyle,
                        children: [
                          Text(
                            'Autor: ${widget.name!}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'LatoBold',
                              fontSize: 20,
                              color: Color.fromRGBO(0, 56, 107, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Marca: ${widget.category}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontFamily: 'LatoBold',
                              fontSize: 20,
                              color: Color.fromRGBO(0, 56, 107, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(width: 16),
                          RatingBar.builder(
                            initialRating: widget.stars!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 24,
                            ignoreGestures: true,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              // Callback para atualização da classificação selecionada
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTypography(
                            text: 'Comentario: ${widget.text!}',
                          )
                        ],
                      ),
                    ],
                  ),
                  const CustomDivider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
