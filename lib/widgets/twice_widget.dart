import 'package:flutter/material.dart';

class TwiceWidget extends StatelessWidget {
  const TwiceWidget({Key? key, this.onPressedA, this.onPressedB, this.text,}) : super(key: key);
  final Function()? onPressedA;
  final Function()? onPressedB;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
                padding: EdgeInsets.zero,
                minimumSize: Size(60, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)))
            ),
            onPressed:onPressedA, child: Icon(Icons.add),
          ),
          Container(
              color: Colors.white,
              width: 50,
              height: 50,
              child: Center(child: Text(
                text ?? '',
                style: TextStyle(color: Colors.black),))),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(60, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)))
                //maximumSize: Size(50,30)
              ),
              onPressed: onPressedB, child: Icon(Icons.remove)),
        ]);
  }
}