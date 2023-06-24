import "package:flutter/material.dart";

class CustomDivider extends StatelessWidget {
  final Color? color;
  const CustomDivider({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? Colors.grey,
      thickness: 1,
      height: 1,
    );
  }
}
