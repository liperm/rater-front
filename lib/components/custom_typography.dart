import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mix/mix.dart";

import 'app_size.dart';

class CustomTypography extends StatelessWidget {
  const CustomTypography({
    super.key,
    required this.text,
    this.weight = FontWeight.w400,
    this.color = Colors.black,
    this.align = TextAlign.left,
    this.mix,
  });

  final FontWeight weight;

  final String text;
  final Color color;
  final TextAlign align;
  final Mix<Attribute>? mix;

  @override
  Widget build(BuildContext context) {
    final style = Mix.combine(
      Mix(fontWeight(weight)),
      Mix(
        textColor(color),
        textAlign(align),
      ),
      mix,
    );

    return TextMix(text, mix: style);
  }

  Mix<TextAttributes> _adjustFontSize(Mix<TextAttributes> type) {
    final double fontSizeAdjust = AppSize(context: Get.context)
        .getHeight(type.attributes[1].style!.fontSize!);
    return Mix.combine(type, Mix(fontSize(fontSizeAdjust)));
  }
}
