import 'package:flutter/material.dart';

class TitleRater extends StatelessWidget {
  final Color? color;
  final double? size;

  const TitleRater({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Rater.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'OleoScript',
          fontWeight: FontWeight.bold,
          color: color ?? Colors.white,
          fontSize: size ?? 20,
        ),
      ),
    );
  }
}
