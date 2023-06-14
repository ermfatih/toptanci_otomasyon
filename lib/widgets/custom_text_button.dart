import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final IconData? icon;
  const CustomTextButton({Key? key, this.onPressed, this.text, this.icon,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text ?? ''));
  }
}