import 'package:flutter/material.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles({Key? key, required this.text, required this.time, required this.isCome,}) : super(key: key);
  final String text;
  final DateTime time;
  final bool isCome;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10,right: 10),
      child: Column(
        crossAxisAlignment:isCome?CrossAxisAlignment.start:CrossAxisAlignment.end,
        children: [
          Container(
              decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 8,left: 8),
            child: Text('${time.hour}:${time.minute}',
                style: const TextStyle(
                  fontSize: 12,
                )),
          )
        ],
      ),
    );
  }
}
