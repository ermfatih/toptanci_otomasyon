import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({Key? key, required this.onPressed, this.text,}) : super(key: key);

  final void Function()? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(minimumSize: Size(width, height / 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), primary: Colors.indigo),
      child:Text(text ?? ''),
    );
  }

}
