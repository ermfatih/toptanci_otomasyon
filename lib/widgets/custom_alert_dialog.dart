import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key, this.onPressedA, this.onPressedB,}) : super(key: key);
  final void Function()? onPressedA;
  final void Function()? onPressedB;

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text('Sipariş Durumu'),
      content: Text('Teslim Edilsin Mi?'),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(width / 4, height / 20),
                shape: RoundedRectangleBorder(borderRadius:
                BorderRadius.circular(12)), primary: Colors.indigo),
            onPressed: onPressedA,
            child:
            Text('Onayla')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize:
                Size(width / 4, height / 20),
                shape: RoundedRectangleBorder(borderRadius:
                    BorderRadius.circular(12)),
                primary: Colors.indigo),
            onPressed: onPressedB,
            child:
            Text('İptal')),
      ],
    );
  }
}