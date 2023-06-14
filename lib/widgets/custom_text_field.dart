
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {


  const CustomTextField({Key? key, required this.labelText, this.textEditingController, this.initialValue, this.readOnly, this.validator, this.obscureText,}) : super(key: key);
  final String labelText;
  final TextEditingController? textEditingController;
  final String? initialValue;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction:TextInputAction.next,
      obscureText: obscureText ?? false,
      validator: validator,
      readOnly: readOnly ?? false,
      initialValue: initialValue,
        controller: textEditingController,
        decoration: InputDecoration(
            labelText: labelText,
            contentPadding:const EdgeInsets.only(left: 12),
            border:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))));
  }
}