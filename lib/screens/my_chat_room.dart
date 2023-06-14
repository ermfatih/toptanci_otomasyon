import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/widgets/chat_bubbles.dart';
import 'package:toptanci_otomasyon/core/services/message_service.dart';

class MyRoom extends StatefulWidget {
  const MyRoom({Key? key, required this.id, required this.userName}) : super(key: key);
  final String id;
  final String userName;

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  TextEditingController messageEditingController2=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages').doc(widget.id).collection('messages')
                  .orderBy('dateTime',descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) return Container();
                List<Message> list=snapshot.data!.docs.map((e) => Message.fromMap(e.data() as Map<String ,dynamic>)).toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ChatBubbles(
                        isCome: (list[index].senderId==null) ? false:true,
                        text: list[index].message!,
                        time: list[index].dateTime!,
                      );
                  },
                );
              }
          )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
            child: Card(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextField(
                    controller: messageEditingController2,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (messageEditingController2.text != '') {
                                  MessageService().adminSendMessage(
                                      Message(
                                          message: messageEditingController2.text,
                                          dateTime: DateTime.now(),
                                          senderId: widget.id,
                                      ),widget.id,
                                  );
                                  messageEditingController2.text = '';
                                }
                              });
                            },
                            icon: const Icon(Icons.send)),
                        contentPadding: const EdgeInsets.all(12),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: 'buraya mesajınızı giriniz')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}