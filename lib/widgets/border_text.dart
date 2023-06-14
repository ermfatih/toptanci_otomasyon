import 'package:flutter/material.dart';

class BorderText extends StatelessWidget {
  const BorderText({
    Key? key,
    this.text,
    this.width,
    this.height,
    this.textColor,
  }) : super(key: key);
  final String? text;
  final double? width;
  final double? height;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          bottom: 5,
        ),
        width: width,
        height: height ?? 50,
        decoration: BoxDecoration(
            border: Border.all(color: textColor ?? Colors.white30),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Text(
              text ?? '',
              maxLines: 3,
              style: TextStyle(color: textColor),
            )));
  }
}